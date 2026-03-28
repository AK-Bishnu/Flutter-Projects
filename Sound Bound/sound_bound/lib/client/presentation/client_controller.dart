import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/network/tcp_client.dart';

class ClientController extends ChangeNotifier {
  final List<String> logs = [];
  TCPClient? client;

  File? _receivingFile;
  IOSink? _fileSink;
  int _expectedFileSize = 0;
  int _receivedBytes = 0;
  String? _fileName;

  /// Connect to host and start receiving file
  Future<void> connect() async {
    client = TCPClient(
      onConnected: () => addLog('Connected to host!'),

      onMessageReceived: (msg) {
        if (msg == 'FILE_END') {
          handleFileEnd();
          return;
        }
        addLog('📄 META RECEIVED: $msg');
        handleMeta(msg);
      },

      onDataReceived: (bytes) {
        handleFileChunk(bytes);
      },
    );
    try {
      await client!.connect();
      client!.send('Hello from client!');
    } catch (e) {
      addLog('Connection error: $e');
    }
  }

  /// Handle incoming metadata
  void handleMeta(String msg) async {
    try {
      final Map<String, dynamic> meta = jsonDecode(msg);
      if (meta['type'] != 'FILE_META') return;

      _fileName = meta['name'];
      _expectedFileSize = meta['size'];
      _receivedBytes = 0;

      final downloadsDir = Directory('/storage/emulated/0/Download');
      final filePath = '${downloadsDir.path}/$_fileName';
      _receivingFile = File(filePath);
      _fileSink = _receivingFile!.openWrite();

      addLog('📄 Receiving file: $_fileName ($_expectedFileSize bytes)');
    } catch (e) {
      addLog('❌ Meta parse error: $e');
    }
  }

  /// Handle incoming file chunks
  void handleFileChunk(Uint8List bytes) {
    if (_fileSink == null) return;

    _fileSink!.add(bytes);
    _receivedBytes += bytes.length;

    addLog('📦 Received chunk: ${bytes.length} bytes ($_receivedBytes/$_expectedFileSize)');

    if (_receivedBytes >= _expectedFileSize) {
      _fileSink!.close();
      _fileSink = null;
      addLog('✅ File received completely: $_fileName');
    }
  }

  /// Handle file end
  Future<void> handleFileEnd() async {
    addLog('✅ FILE_END received');

    if (_fileSink != null) {
      await _fileSink!.close();
      _fileSink = null;
    }

    if (_receivedBytes != _expectedFileSize) {
      addLog('❌ Size mismatch! $_receivedBytes != $_expectedFileSize');
    } else {
      addLog('💾 File saved successfully: ${_receivingFile!.path}');
    }

    // Reset for next file
    _receivingFile = null;
    _fileName = null;
    _expectedFileSize = 0;
    _receivedBytes = 0;
  }

  /// Disconnect client
  Future<void> disconnect() async {
    client?.disconnect();
    addLog('Disconnected');
  }

  void addLog(String msg) {
    logs.add(msg);
    notifyListeners();
  }
}