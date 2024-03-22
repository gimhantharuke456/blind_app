import 'package:blind_app/controllers/dbconnect.dart';
import 'package:blind_app/controllers/order.controller.dart';
import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/models/order.model.dart';
import 'package:blind_app/providers/order.provder.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/home/item.list.view.dart';

import 'package:blind_app/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderView extends StatefulWidget {
  final Order order;
  const OrderView({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderView> createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  final VoiceController _voiceController = VoiceController();
  final TextEditingController _deliveryDetailsController =
      TextEditingController();
  final SpeechController speechController = SpeechController();
  late DbConnect _dbConnect;

  @override
  void initState() {
    _dbConnect = DbConnect();
    _dbConnect.open();
    super.initState();

    _voiceController.speek(
        message:
            "You are going to buy items now,Please enter your details. Tap on the screen and say your name, address, phone number and email. We will do the rest. After entering details long press for place order. Double tap to confirm details");
  }

  @override
  void dispose() {
    _deliveryDetailsController.dispose();
    super.dispose();
  }

  void _handleVoiceInput() {
    speechController.startListening(onResult: (text) {
      setState(() {
        _deliveryDetailsController.text = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Delivery Details'),
      ),
      body: GestureDetector(
        onTap: () {
          _handleVoiceInput();
        },
        onDoubleTap: () async {
          await _voiceController.speek(
              message: _deliveryDetailsController.text);
        },
        onLongPress: () async {
          final OrderController _orderController =
              OrderController(_dbConnect.db);

          for (var item in widget.order.items) {
            await _orderController.createOrder({
              "itemName": item.name,
              "description": item.description,
              "price": item.price,
              "userId": "userId"
            });
          }
          if (_deliveryDetailsController.text.isNotEmpty) {
            orderProvider.addOrder(widget.order);
            await _voiceController
                .speek(
                    message:
                        'Order placed successfully. Navigating back to item list')
                .then((value) => Future.delayed(const Duration(seconds: 1))
                    .then((value) => context.navigator(context, ItemListView(),
                        shouldBack: false)));
          } else {
            await _voiceController.speek(
                message: 'Please add delivery details');
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputFieldCustom(
                isTextArea: true,
                hintText: 'Enter your delivery details here...',
                controller: _deliveryDetailsController,
              ),
              Expanded(
                  child: Container(
                color: Colors.transparent,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
