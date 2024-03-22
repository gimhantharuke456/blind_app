import 'package:blind_app/controllers/dbconnect.dart';
import 'package:blind_app/controllers/order.controller.dart';
import 'package:blind_app/models/order.mongo.model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blind_app/providers/order.provder.dart';
import 'package:blind_app/controllers/voice.controller.dart';

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
    final List<OrderMongoModel> orders = orderProvider.orders;

    final _dbConnect = DbConnect();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('My Orders'),
      ),
      body: FutureBuilder(
          future: _dbConnect.open(),
          builder: (context, snapshot) {
            final OrderController orderController =
                OrderController(_dbConnect.db);
            return FutureBuilder(
                future: orderController.getAllOrders(),
                builder: (context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.data == null) {
                    return const SizedBox.shrink();
                  }

                  orderProvider.setOrders = snapshot.data!
                      .map((e) => OrderMongoModel.fromMap(e))
                      .toList();
                  if (orderProvider.orders.isEmpty) {
                    return const Center(
                      child: Text('You have no orders yet'),
                    );
                  }
                  return PageView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      final order =
                          OrderMongoModel.fromMap(snapshot.data![index]);
                      return buildOrderPage(
                        order,
                        context,
                        orderController,
                      );
                    },
                  );
                });
          }),
    );
  }

  Widget buildOrderPage(OrderMongoModel order, BuildContext context,
      OrderController controllerl) {
    return GestureDetector(
      onTap: () {
        _voiceController.speek(
            message:
                'Order Product: ${order.itemName}.  Total Amount: \$${order.price!.toStringAsFixed(2)}');
      },
      onLongPress: () async {
        await controllerl.deleteOrder(order.id!.toHexString());
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
              'Order Item: ${order.itemName}',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total Amount: \$${order.price!.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
