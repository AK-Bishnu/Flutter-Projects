import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sound_bound/core/audio/mic_capture_service.dart';
import 'package:sound_bound/core/network/tcp_server.dart';
import '../../utils/appConst.dart';
import 'package:file_picker/file_picker.dart';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';

class HostController extends ChangeNotifier {
  final List<String> logs = [];
  TCPServer? server;
  final MicCaptureService micCaptureService = MicCaptureService();

  // 🔹 PCM FRAME BUFFER (HOST SIDE ONLY)
  Uint8List _pcmBuffer = Uint8List(0);
  static const int FRAME_SIZE = 640; // 20ms @ 16kHz PCM16 mono
  Timer? _audioTimer;

  // 🔹 Consolidated file variables (replaces all duplicates)
  File? _selectedFile;  // Single variable for selected file
  String? _fileName;    // File name
  int _fileSize = 0;    // File size in bytes
  int _sentBytes = 0;   // Bytes sent so far
  int _chunkSize = 1024 * 8; // 8KB chunks

  HostController() {
    server = TCPServer(
      onClientConnected: (client) {
        client.setOption(SocketOption.tcpNoDelay, true);
        addLog('Client connected: ${client.remoteAddress.address}');
      },
      onDataReceived: (client, data) =>
          addLog('Received from client: ${data.length} bytes'),
    );
  }

  Future<void> startServer() async {
    await requestMicPermission();
    await server?.start();
    await micCaptureService.init();
    addLog('Server started on port ${AppConst.port}');
  }

  Future<void> stopServer() async {
    await micCaptureService.stop();
    micCaptureService.dispose();
    server?.stop();
    addLog('Server stopped');
  }

  Future<void> requestMicPermission() async {
    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission denied');
    }
  }

  // Existing file play - streaming audio to clients
  Future<String?> pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pcm', 'wav', 'mp3'],
    );

    if (result != null && result.files.single.path != null) {
      return result.files.single.path!;
    } else {
      return null;
    }
  }

  void playLocalAudio() async {
    final path = await pickAudioFile();
    if (path == null) {
      addLog('No file selected');
      return;
    }

    addLog('Streaming audio file: $path');
    await streamAudioFile(path);
  }

  Future<void> streamAudioFile(String path) async {
    final file = File(path);
    if (!file.existsSync()) {
      addLog('File does not exist: $path');
      return;
    }

    // Create temporary WAV file
    final tempPath = '${file.parent.path}/temp.wav';
    await FFmpegKit.execute('-i "$path" -ar 16000 -ac 1 -f wav "$tempPath"');

    final wavFile = File(tempPath);
    final fileBytes = await wavFile.readAsBytes();

    addLog('WAV file read: ${fileBytes.length} bytes');

    // Skip WAV header (first 44 bytes for PCM16)
    final pcmBytes = fileBytes.sublist(44);

    // Stream in chunks
    const chunkSize = 640;
    int offset = 0;

    while (offset < pcmBytes.length) {
      final end = (offset + chunkSize > pcmBytes.length)
          ? pcmBytes.length
          : offset + chunkSize;

      final chunk = pcmBytes.sublist(offset, end);

      // Packet header
      final packet = Uint8List(1 + chunk.length);
      packet[0] = 0x01; // audio marker
      packet.setRange(1, 1 + chunk.length, chunk);

      server?.sendRaw(packet);

      offset = end;
      await Future.delayed(Duration(milliseconds: 20));
    }

    addLog('Finished streaming audio file');

    // Delete temp WAV if needed
    await wavFile.delete();
  }

  // File selection for sending to clients
  Future<void> pickAndPrepareAudioFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'wav', 'm4a', 'pcm'],
    );

    if (result == null || result.files.single.path == null) {
      addLog('File picking cancelled');
      return;
    }

    _selectedFile = File(result.files.single.path!);
    _fileName = _selectedFile!.path.split('/').last;
    _fileSize = await _selectedFile!.length();

    addLog('Selected file: $_fileName');
    addLog('Size: ${(_fileSize / (1024 * 1024)).toStringAsFixed(2)} MB');

    notifyListeners();
  }

  // Getter for selected file
  File? get selectedFile => _selectedFile;

  // Getter for file info
  String? get fileName => _fileName;
  int get fileSize => _fileSize;
  int get sentBytes => _sentBytes;
  int get progressPercent => _fileSize > 0 ? ((_sentBytes / _fileSize) * 100).toInt() : 0;

  /// Send file to all connected clients
  Future<void> sendFileToAll() async {
    if (_selectedFile == null) {
      addLog('❌ No file selected');
      return;
    }

    if (server == null || server!.clients.isEmpty) {
      addLog('❌ No clients connected');
      return;
    }

    try {
      // Reset counters
      _sentBytes = 0;

      // 1. Send metadata
      final meta = {
        'type': 'FILE_META',
        'name': _fileName,
        'size': _fileSize,
      };
      final jsonMeta = jsonEncode(meta);

      server!.sendMetaToAll(jsonMeta);
      addLog('📤 Sent metadata: $jsonMeta');

      await Future.delayed(Duration(milliseconds: 100));

      // 2. Send file in chunks
      final stream = _selectedFile!.openRead();
      await for (final data in stream) {
        final chunk = Uint8List.fromList(data);
        server!.sendChunkToAll(chunk);
        _sentBytes += chunk.length;

        addLog('📤 Sent chunk: ${chunk.length} bytes ($_sentBytes/$_fileSize)');
        notifyListeners(); // Update progress

        // Small delay to prevent overwhelming the network
        await Future.delayed(Duration(milliseconds: 1));
      }

      // 3. Send file end marker
      await Future.delayed(Duration(milliseconds: 100));
      server!.sendFileEndToAll();
      addLog('✅ File sent completely: $_fileName');

    } catch (e) {
      addLog('❌ Error sending file: $e');
    } finally {
      // Keep _sentBytes for progress display
      notifyListeners();
    }
  }

  /// Reset file selection
  void resetFileSelection() {
    _selectedFile = null;
    _fileName = null;
    _fileSize = 0;
    _sentBytes = 0;
    notifyListeners();
  }

  void addLog(String msg) {
    final timestamp = DateTime.now().toString().split(' ')[1].substring(0, 8);
    logs.add('[$timestamp] $msg');
    notifyListeners();
  }
}