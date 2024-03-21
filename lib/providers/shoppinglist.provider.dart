import 'package:flutter/foundation.dart';

class ShoppingListProvider with ChangeNotifier {
  List<ShoppingListItem> _shoppingList = [];

  List<ShoppingListItem> get shoppingList => _shoppingList;

  void addItemToShoppingList(ShoppingListItem item) {
    _shoppingList.add(item);
    notifyListeners();
  }

  void removeItemFromShoppingList(ShoppingListItem item) {
    _shoppingList.remove(item);
    notifyListeners();
  }

  void updateItemInShoppingList(ShoppingListItem updatedItem) {
    final index = _shoppingList.indexWhere((item) => item.id == updatedItem.id);
    if (index != -1) {
      _shoppingList[index] = updatedItem;
      notifyListeners();
    }
  }

  void clearShoppingList() {
    _shoppingList.clear();
    notifyListeners();
  }
}

class ShoppingListItem {
  final int id;
  final String name;
  final String description;
  final double price;

  ShoppingListItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}
