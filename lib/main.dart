import 'package:blind_app/providers/cart.provider.dart';
import 'package:blind_app/providers/order.provder.dart';
import 'package:blind_app/providers/shoppinglist.provider.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/views/onboaring/login.view.dart';
import 'package:blind_app/views/order/my.orders.view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? selectedTheme = prefs.getString('selectedTheme');
  runApp(MyApp(
    selectedTheme: selectedTheme,
    uid: prefs.getString("uid"),
  ));
}

class MyApp extends StatelessWidget {
  final String? selectedTheme;
  final String? uid;
  const MyApp({super.key, this.selectedTheme, this.uid});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartProvider()),
        ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
        ChangeNotifierProvider(create: (context) => OrderProvider()),
      ],
      child: MaterialApp(
        theme: _buildThemeData(selectedTheme),
        home: uid != null ? ItemListView() : const LoginView(),
      ),
    );
  }

  ThemeData _buildThemeData(String? selectedTheme) {
    switch (selectedTheme) {
      case 'colorBlind':
        return ThemeData(
            primaryColor: Colors.red,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.red,
            ));
      case 'farSightedness':
        return ThemeData(
            primaryColor: Colors.green,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.green,
            ));
      case 'fullyBlind':
        return ThemeData(
            primaryColor: Colors.blue,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blue,
            ));
      default:
        return ThemeData(
            primaryColor: Colors.grey,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.grey,
            ));
    }
  }
}
