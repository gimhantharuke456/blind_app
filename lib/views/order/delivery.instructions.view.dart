import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:flutter/material.dart';

class DeliverInstructionsView extends StatefulWidget {
  const DeliverInstructionsView({Key? key}) : super(key: key);

  @override
  State<DeliverInstructionsView> createState() =>
      _DeliverInstructionsViewState();
}

class _DeliverInstructionsViewState extends State<DeliverInstructionsView> {
  final VoiceController _voiceController = VoiceController();
  final _speechController = SpeechController();
  String details = "";
  @override
  void initState() {
    _voiceController.speek(
      message:
          "Please provide your card details. Tap anywhere on the screen to input your address, name, and city. On long-press, you can navigate back to the item list view.",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _speechController.startListening(onResult: (onResult) {
          setState(() {
            details = onResult;
          });
        });
      },
      onLongPress: () {
        _voiceController.speek(message: "Order placed successfully");
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Card Details"),
          backgroundColor: Colors.grey,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            details.isNotEmpty ? details : "Tap anywhere to input card details",
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
