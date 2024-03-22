import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/controllers/voice.navigator.controller.dart';
import 'package:blind_app/models/order.model.dart';
import 'package:blind_app/models/order.mongo.model.dart';
import 'package:blind_app/providers/cart.provider.dart';
import 'package:blind_app/providers/order.provder.dart';
import 'package:blind_app/providers/shoppinglist.provider.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/order/order.view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final List<Item> items = [
  Item(
    id: 1,
    name: "Wireless Headphones",
    description:
        "High-quality wireless headphones with noise cancellation feature.",
    price: 99.99,
  ),
  Item(
    id: 2,
    name: "Smartwatch",
    description:
        "Multi-functional smartwatch with heart rate monitor and fitness tracker.",
    price: 149.99,
  ),
  Item(
    id: 3,
    name: "Digital Camera",
    description:
        "Professional-grade digital camera with 4K video recording capabilities.",
    price: 399.99,
  ),
  Item(
    id: 4,
    name: "Bluetooth Speaker",
    description:
        "Portable Bluetooth speaker with waterproof design, perfect for outdoor use.",
    price: 79.99,
  ),
];

class ItemListView extends StatefulWidget {
  @override
  State<ItemListView> createState() => _ItemListViewState();
}

class _ItemListViewState extends State<ItemListView> {
  final VoiceController _voiceController = VoiceController();

  @override
  void initState() {
    _voiceController.speek(
      message:
          "Welcome to iShop. You can explore items by swiping left or right. "
          "Double-tap to buy an item. Swipe up to add the item to your shopping cart, "
          "and swipe down to add it to your shopping list.",
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    VoiceNavigator voiceNavigator = VoiceNavigator(buildContext: context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Item List'),
        automaticallyImplyLeading: false,
      ),
      body: PageView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return buildItemCard(item, context, voiceNavigator);
        },
      ),
    );
  }

  Widget buildItemCard(
      Item item, BuildContext context, VoiceNavigator navigator) {
    final cartProvider = Provider.of<CartProvider>(context);
    final shoppingItemListProvider = Provider.of<ShoppingListProvider>(context);

    void buyItem() {
      OrderMongoModel order = OrderMongoModel(
          itemName: item.name,
          description: item.description,
          price: item.price,
          userId: "userId");
      context.navigator(context, OrderView(order: order));
    }

    void addToCart() {
      cartProvider.addItemToCart(item);
      _voiceController.speek(message: "Product added to cart");
    }

    void addToShopList() {
      ShoppingListItem shoppingListItem = ShoppingListItem(
          id: shoppingItemListProvider.shoppingList.length + 1,
          name: item.name,
          description: item.description,
          price: item.price);
      shoppingItemListProvider.addItemToShoppingList(shoppingListItem);
      _voiceController.speek(message: "Product added to shopping list");
    }

    void playItemDetails() {
      _voiceController.speek(
          message:
              "${item.name} 's price is ${item.price}. ${item.description}");
    }

    return GestureDetector(
      onTap: () {
        playItemDetails();
      },
      onDoubleTap: () {
        buyItem();
      },
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          addToShopList();
        } else if (details.primaryVelocity! < 0) {
          addToCart();
        }
      },
      onLongPress: () {
        navigator.startVoiceNavigation();
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
              const SizedBox(height: 10),
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

class Item {
  final int id;
  final String name;
  final String description;
  final double price;

  Item({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}
