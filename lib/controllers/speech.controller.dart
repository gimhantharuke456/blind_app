import 'package:speech_to_text/speech_to_text.dart';

class SpeechController {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;

  SpeechController();

  Future<bool> initialize() async {
    bool hasSpeech = await _speechToText.initialize();
    return hasSpeech;
  }

  Future<void> startListening({required Function(String text) onResult}) async {
    _speechToText.listen(onResult: (result) {
      print("results $result");
      onResult(result.recognizedWords);
    });
  }

  void stopListening() {
    if (_isListening) {
      _speechToText.stop();
      _isListening = false;
    }
  }
}
