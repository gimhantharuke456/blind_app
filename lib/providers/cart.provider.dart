import 'package:blind_app/views/home/item.list.view.dart';
import 'package:flutter/foundation.dart';

class CartProvider with ChangeNotifier {
  List<Item> _cartItems = [];

  List<Item> get cartItems => _cartItems;

  void addItemToCart(Item item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItemFromCart(Item item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  void updateCartItem(Item newItem) {
    final index = _cartItems.indexWhere((item) => item.id == newItem.id);
    if (index != -1) {
      _cartItems[index] = newItem;
      notifyListeners();
    }
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
