import 'package:blind_app/models/cart.model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class CartController {
  final DbCollection carts;

  CartController(this.carts);

  Future<void> createCart(Cart cart) async {
    await carts.insertOne(cart.toMap());
  }

  Future<Cart?> getCartByUserId(ObjectId userId) async {
    final cartData = await carts.findOne(where.eq('userId', userId));
    if (cartData != null) {
      return Cart.fromMap(cartData);
    }
    return null;
  }

  Future<void> updateCartItems(
      ObjectId cartId, List<Map<String, dynamic>> items) async {
    await carts.updateOne(where.id(cartId), modify.set('items', items));
  }

  Future<void> deleteCart(ObjectId cartId) async {
    await carts.remove(where.id(cartId));
  }
}
