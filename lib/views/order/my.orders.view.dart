import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blind_app/providers/order.provder.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/models/order.model.dart';

class MyOrdersView extends StatefulWidget {
  const MyOrdersView({Key? key}) : super(key: key);

  @override
  _MyOrdersViewState createState() => _MyOrdersViewState();
}

class _MyOrdersViewState extends State<MyOrdersView> {
  late VoiceController _voiceController;

  @override
  void initState() {
    _voiceController = VoiceController();
    _voiceController.speek(
        message:
            'Welcome to My Orders. Swipe left or right to navigate between your orders. Long press on an order to remove it. Tap on an order to hear its details.');
    super.initState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final List<Order> orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: Text('My Orders'),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text('You have no orders yet'),
            )
          : PageView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return buildOrderPage(order, context);
              },
            ),
    );
  }

  Widget buildOrderPage(Order order, BuildContext context) {
    return GestureDetector(
      onTap: () {
        _voiceController.speek(
            message:
                'Order ID: ${order.id}.  Total Amount: \$${order.totalPrice.toStringAsFixed(2)}');
      },
      onLongPress: () {
        Provider.of<OrderProvider>(context, listen: false).removeOrder(order);
        _voiceController.speek(message: 'Order removed successfully');
      },
      child: Container(
        margin: EdgeInsets.all(16.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.grey.shade200,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID: ${order.id}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Amount: \$${order.totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
