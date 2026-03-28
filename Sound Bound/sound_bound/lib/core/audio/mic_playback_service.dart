import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';

class MicPlaybackService {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final int kSAMPLERATE = 16000;
  final int kNUMBEROFCHANNELS = 1;

  /// Initialize the player
  Future<void> init() async {
    await _player.openPlayer();

    await _player.startPlayerFromStream(
      codec: Codec.pcm16,       // match capture PCM16
      interleaved: true,
      numChannels: kNUMBEROFCHANNELS,
      sampleRate: kSAMPLERATE,
      bufferSize: 640,
    );
  }

  void playChunk(Uint8List bytes) {
    if (bytes.isEmpty) return;

    // Ensure even number of bytes
     final len = bytes.length - (bytes.length % 2);
     if (len <= 0) return;

    // final samples = Int16List.view(
    //   bytes.buffer,
    //   bytes.offsetInBytes,
    //   len ~/ 2,
    // );
    //
    // _player.int16Sink!.add([samples]);
    _player.uint8ListSink!.add(bytes);
    print(' ▶️ PLAY CHUNK: $len');
  }


  Future<void> stop() async {
    await _player.stopPlayer();
    await _player.closePlayer();
  }

  /// Dispose player
  void dispose() {
    _player.closePlayer();
  }
}
