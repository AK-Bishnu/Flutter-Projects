import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class MicCaptureService {
  final int kSAMPLERATE = 16000;
  final int kNUMBEROFCHANNELS = 1; // mono
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamController<Uint8List>? _recordingDataController;

  /// Initialize the recorder and request microphone permission
  Future<void> init() async {
    await Permission.microphone.request();



    await _recorder.openRecorder();
    _recordingDataController = StreamController<Uint8List>();
  }

  /// Start capturing mic audio
  void start(void Function(Uint8List) onFrame) async {
    if (_recordingDataController == null) return;

    // Listen to recorder stream
    _recordingDataController!.stream.listen((data) {
      onFrame(Uint8List.fromList(data)); // send chunk to callback
    });

    await _recorder.startRecorder(
      codec: Codec.pcm16,                  // PCM16 is better for streaming
      sampleRate: kSAMPLERATE,
      numChannels: kNUMBEROFCHANNELS,
      audioSource: AudioSource.voice_communication,
      toStream: _recordingDataController!.sink,
    );
  }

  /// Stop capturing
  Future<void> stop() async {
    await _recorder.stopRecorder();
    await _recordingDataController?.close();
    _recordingDataController = null;
  }

  /// Dispose recorder
  void dispose() {
    _recorder.closeRecorder();
  }
}
