import 'package:blind_app/providers/cart.provider.dart';
import 'package:blind_app/providers/order.provder.dart';
import 'package:blind_app/providers/shoppinglist.provider.dart';
import 'package:blind_app/views/onboaring/login.view.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var db = await Db.create(
      "mongodb+srv://root:root@blindapp.rkpesgt.mongodb.net/test");
  await db.open();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(primaryColor: Colors.grey),
        home: const LoginView(),
      ),
    );
  }
}
