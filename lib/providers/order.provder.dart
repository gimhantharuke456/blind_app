import 'package:blind_app/models/order.mongo.model.dart';
import 'package:flutter/foundation.dart';

class OrderProvider with ChangeNotifier {
  List<OrderMongoModel> _orders = [];

  List<OrderMongoModel> get orders => _orders;

  set setOrders(List<OrderMongoModel> value) {
    _orders = value;
    notifyListeners();
  }

  void addOrder(OrderMongoModel order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(OrderMongoModel order) {
    _orders.remove(order);
    notifyListeners();
  }

  void updateOrder(OrderMongoModel updatedOrder) {
    final index = _orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      _orders[index] = updatedOrder;
      notifyListeners();
    }
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }
}
