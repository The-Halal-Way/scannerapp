import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

abstract class VoiceSearchService {
  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<bool> onListeningChanged,
  });

  Future<void> start({required ValueChanged<String> onResult});

  Future<void> stop();

  Future<void> cancel();

  bool get isListening;
}

class DeviceVoiceSearchService implements VoiceSearchService {
  final SpeechToText _speech = SpeechToText();

  @override
  bool get isListening => _speech.isListening;

  @override
  Future<bool> initialize({
    required ValueChanged<String> onError,
    required ValueChanged<bool> onListeningChanged,
  }) {
    return _speech.initialize(
      onError: (error) => onError(error.errorMsg),
      onStatus: (status) => onListeningChanged(status == 'listening'),
      options: [SpeechToText.androidNoBluetooth],
    );
  }

  @override
  Future<void> start({required ValueChanged<String> onResult}) async {
    await _speech.listen(
      onResult: (result) {
        final words = result.recognizedWords.trim();
        if (words.isNotEmpty) onResult(words);
      },
      listenFor: const Duration(seconds: 15),
      pauseFor: const Duration(seconds: 3),
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.search,
        partialResults: true,
        cancelOnError: true,
      ),
    );
  }

  @override
  Future<void> stop() => _speech.stop();

  @override
  Future<void> cancel() => _speech.cancel();
}
