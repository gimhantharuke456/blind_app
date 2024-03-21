import 'package:blind_app/views/home/item.list.view.dart';

class Order {
  final int id;
  final List<Item> items;
  final double totalPrice;
  final DateTime dateTime;

  Order({
    required this.id,
    required this.items,
    required this.totalPrice,
    required this.dateTime,
  });
}
