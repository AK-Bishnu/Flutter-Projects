import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:sound_bound/utils/appConst.dart';

typedef OnClientConnected = void Function(Socket client);
typedef OnDataReceived = void Function(Socket client, String data);

class TCPServer {
  ServerSocket? _server;
  final List<Socket> clients = [];
  final OnClientConnected? onClientConnected;
  final OnDataReceived? onDataReceived;

  TCPServer({
    this.onClientConnected,
    this.onDataReceived
});

  Future<void> start() async{
    _server = await ServerSocket.bind(InternetAddress.anyIPv4, AppConst.port);
    print('Server started on port ${AppConst.port}');

    _server!.listen((client) {
      client.setOption(SocketOption.tcpNoDelay, true);
      clients.add(client);
      print('New client connected: ${client.remoteAddress.address}');
      onClientConnected?.call(client);

      client.listen((data) {
        final msg = String.fromCharCodes(data);
        print('Received from client: $msg');
        onDataReceived?.call(client, msg);
      },onDone: () {
        print('Client disconnected: ${client.remoteAddress.address}');
        clients.remove(client);
      },);
    },);
  }

  void sendToAll(String msg){
    for(var client in clients){
      client.write(msg);
    }
  }
  void sendRaw(Uint8List data) {
    for (var client in clients) {
      client.add(data); // send raw bytes
    }
  }

  void sendMetaToAll(String json) {
    final metaBytes = utf8.encode(json);
    final lengthBytes = Uint8List(4);
    ByteData.view(lengthBytes.buffer).setUint32(0, metaBytes.length, Endian.big);

    final packet = Uint8List(1 + 4 + metaBytes.length);
    packet[0] = 0x02;
    packet.setRange(1, 5, lengthBytes);
    packet.setRange(5, packet.length, metaBytes);

    for (var c in clients) {
      c.add(packet);
    }
  }

  void sendChunkToAll(Uint8List chunk) {
    final lengthBytes = Uint8List(4);
    ByteData.view(lengthBytes.buffer).setUint32(0, chunk.length, Endian.big);

    final packet = Uint8List(1 + 4 + chunk.length);
    packet[0] = 0x03;
    packet.setRange(1, 5, lengthBytes);
    packet.setRange(5, packet.length, chunk);

    for (var c in clients) {
      c.add(packet);
    }
  }

  void sendFileEndToAll() {
    for (var c in clients) {
      c.add(Uint8List.fromList([0x04]));
    }
  }




  void stop(){
    for(var client in clients){
      client.close();
    }
    _server?.close();
    print('server closed');
  }
}