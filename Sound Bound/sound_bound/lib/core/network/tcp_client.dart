import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sound_bound/utils/appConst.dart';

typedef OnConnected = void Function();
typedef OnMessageReceived = void Function(String message);
typedef OnDataReceived = void Function(Uint8List data);

class TCPClient {
  Socket? _socket;
  final OnConnected? onConnected;
  final OnMessageReceived? onMessageReceived;
  final OnDataReceived? onDataReceived;

  final List<int> _buffer = [];

  TCPClient({
    this.onConnected,
    this.onMessageReceived,
    this.onDataReceived,
  });

  Future<void> connect() async {
    _socket = await Socket.connect(AppConst.hostIp, AppConst.port);
    _socket!.setOption(SocketOption.tcpNoDelay, true);

    print('Connected to host ${AppConst.hostIp}:${AppConst.port}');
    onConnected?.call();

    _socket!.listen(_onData);
  }

  void _onData(Uint8List data) {
    _buffer.addAll(data);

    while (_buffer.isNotEmpty) {
      // Need at least header byte
      if (_buffer.length < 1) return;

      final header = _buffer[0];

      if (header == 0x04) {
        // File end marker - single byte
        _buffer.removeAt(0);
        onMessageReceived?.call('FILE_END');
        continue;
      }

      // For header 0x02 or 0x03, need header + 4-byte length
      if (_buffer.length < 5) return;

      final length = ByteData.sublistView(
        Uint8List.fromList(_buffer.sublist(1, 5)),
      ).getUint32(0, Endian.big);

      // Need complete packet
      if (_buffer.length < 5 + length) return;

      // Remove header and length bytes
      _buffer.removeRange(0, 5);

      // Extract payload
      final payload = Uint8List.fromList(
        _buffer.sublist(0, length),
      );

      // Remove payload from buffer
      _buffer.removeRange(0, length);

      if (header == 0x02) {
        // Metadata
        onMessageReceived?.call(utf8.decode(payload));
      } else if (header == 0x03) {
        // File chunk
        onDataReceived?.call(payload);
      }
    }
  }

  void send(String message) {
    _socket?.write(message);
  }

  void disconnect() {
    _socket?.close();
  }
}