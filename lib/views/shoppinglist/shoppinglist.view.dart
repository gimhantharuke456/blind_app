import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/controllers/voice.navigator.controller.dart';
import 'package:blind_app/providers/cart.provider.dart';
import 'package:blind_app/providers/shoppinglist.provider.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShoppingList extends StatefulWidget {
  const ShoppingList({super.key});

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _voiceController = VoiceController();
  @override
  void initState() {
    _voiceController.speek(
        message:
            "Welcome to shopping list, from clicking bottom u can add your shopping list to cart");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _shoppingListProvider = Provider.of<ShoppingListProvider>(context);
    final _cartProvider = Provider.of<CartProvider>(context);
    if (_shoppingListProvider.shoppingList.isEmpty) {
      _voiceController.speek(message: "Your shopping list is empty");
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: const Text("Shopping List"),
      ),
      body: _shoppingListProvider.shoppingList.isEmpty
          ? InkWell(
              onLongPress: () {
                final voiceNavigator = VoiceNavigator(buildContext: context);
                voiceNavigator.startVoiceNavigation();
              },
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    "Shpping list is empty",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      itemCount: _shoppingListProvider.shoppingList.length,
                      itemBuilder: (context, index) {
                        ShoppingListItem item =
                            _shoppingListProvider.shoppingList[index];
                        return GestureDetector(
                          onLongPress: () {
                            final voiceNavigator =
                                VoiceNavigator(buildContext: context);
                            voiceNavigator.startVoiceNavigation();
                          },
                          onTap: () {
                            _voiceController.speek(
                                message:
                                    "${item.name}. ${item.description}. Price is ${item.price}");
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width,
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.name),
                                  Text(item.description),
                                  Text('\$${item.price}')
                                ]),
                          ),
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    onSingleTap: () {
                      _voiceController.speek(
                          message:
                              "You are going to add your shopping list to cart, double tap to confirm");
                    },
                    onDoubleTap: () {
                      _shoppingListProvider.shoppingList.forEach((element) {
                        Item item = Item(
                            id: _cartProvider.cartItems.length + 1,
                            name: element.name,
                            description: element.description,
                            price: element.price);
                        _cartProvider.addItemToCart(item);
                      });
                      _voiceController.speek(
                          message: "Shopping list added to cart successfully");
                    },
                    label: "Convert to cart",
                  )
                ],
              ),
            ),
    );
  }
}
