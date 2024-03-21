import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/cart/cart.view.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/views/order/my.orders.view.dart';
import 'package:flutter/material.dart';

class VoiceNavigator {
  final BuildContext buildContext;
  final SpeechController _speechController = SpeechController();
  final VoiceController _voiceController = VoiceController();
  VoiceNavigator({required this.buildContext}) {
    _speechController.initialize();
  }

  void startVoiceNavigation() {
    _speechController.startListening(onResult: (String text) {
      _handleVoiceCommand(text);
    });
  }

  void _handleVoiceCommand(String command) async {
    command = command.toLowerCase();

    if (command.contains('go to item list')) {
      await _voiceController.speek(
          message: "You are going to navigate items list view");
      buildContext.navigator(buildContext, ItemListView());
    } else if (command.contains('go to my orders')) {
      await _voiceController.speek(
          message: "You are going to navigate my orders view");
      buildContext.navigator(buildContext, const MyOrdersView());
    } else if (command.contains('go to cart') ||
        command.contains('navigate to cart')) {
      await _voiceController.speek(
          message: "You are going to navigate cart view");
      buildContext.navigator(buildContext, CartView());
    }

    _speechController.stopListening();
  }
}
