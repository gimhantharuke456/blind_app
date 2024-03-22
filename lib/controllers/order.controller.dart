import 'package:mongo_dart/mongo_dart.dart';

class OrderController {
  final DbCollection _ordersCollection;

  OrderController(Db db) : _ordersCollection = db.collection('orders');

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    await _ordersCollection.insert(orderData);
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    final orders = await _ordersCollection.find().toList();
    return orders.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    final order =
        await _ordersCollection.findOne(where.id(ObjectId.parse(orderId)));
    return order as Map<String, dynamic>?;
  }

  Future<void> updateOrder(
    String orderId,
    Map<String, dynamic> updatedOrderData,
  ) async {
    await _ordersCollection.updateOne(
        where.id(ObjectId.parse(orderId)), updatedOrderData);
  }

  Future<void> deleteOrder(String orderId) async {
    await _ordersCollection.remove(where.id(ObjectId.parse(orderId)));
  }
}
