import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/cart/cart.view.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/views/order/my.orders.view.dart';
import 'package:blind_app/views/shoppinglist/shoppinglist.view.dart';
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
      print(text);
      _handleVoiceCommand(text);
    });
  }

  void _handleVoiceCommand(String command) async {
    command = command.toLowerCase();

    if (command.contains('go to item list') ||
        command.contains('go to product list')) {
      await _voiceController.speek(
          message: "You are going to navigate item list view");
      _speechController.stopListening();
      buildContext.navigator(buildContext, ItemListView());
    } else if (command.contains('go to my orders')) {
      await _voiceController.speek(
          message: "You are going to navigate my orders view");
      _speechController.stopListening();
      buildContext.navigator(buildContext, const MyOrdersView());
    } else if (command.contains('go to cart') ||
        command.contains('navigate to cart')) {
      await _voiceController.speek(
          message: "You are going to navigate cart view");
      _speechController.stopListening();
      buildContext.navigator(buildContext, CartView());
    } else if (command.contains('go to shopping list') ||
        command.contains('navigate to shopping list')) {
      await _voiceController.speek(
          message: "You are going to navigate Shopping list");
      _speechController.stopListening();
      buildContext.navigator(buildContext, ShoppingList());
    }

    _speechController.stopListening();
  }
}
