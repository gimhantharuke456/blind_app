import 'package:blind_app/controllers/voice.navigator.controller.dart';
import 'package:blind_app/providers/cart.provider.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blind_app/controllers/voice.controller.dart';

class CartView extends StatelessWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Access the CartProvider instance using Provider.of
    final cartProvider = Provider.of<CartProvider>(context);
    final voiceController =
        VoiceController(); // Initialize your voice controller

    // Get the list of items from the cart
    final List<Item> cartItems = cartProvider.cartItems;

    // Check if the cart is empty
    if (cartItems.isEmpty) {
      voiceController.speek(message: 'Your cart is empty');
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Cart'),
      ),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Your cart is empty',
              ),
            )
          : PageView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return buildCartItem(item, voiceController, context);
              },
            ),
    );
  }

  Widget buildCartItem(
      Item item, VoiceController voiceController, BuildContext context) {
    return GestureDetector(
      onTap: () {
        voiceController.speek(
            message:
                'Item details: ${item.name}, ${item.description}, \$${item.price}');
      },
      onLongPress: () {
        final _navigator = VoiceNavigator(buildContext: context);
        _navigator.startVoiceNavigation();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Item ID: ${item.id}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                'Name: ${item.name}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Description: ${item.description}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Price: \$${item.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
