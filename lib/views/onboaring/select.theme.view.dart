import 'package:blind_app/controllers/dbconnect.dart';
import 'package:blind_app/controllers/user.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/models/user.model.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectThemeView extends StatefulWidget {
  final User user;
  const SelectThemeView({Key? key, required this.user}) : super(key: key);

  @override
  _SelectThemeViewState createState() => _SelectThemeViewState();
}

class _SelectThemeViewState extends State<SelectThemeView> {
  String? _selectedTheme;
  late SharedPreferences _prefs;
  final _voiceController = VoiceController();
  @override
  void initState() {
    _voiceController.speek(
        message: "After selcting the theme, long press to continue");
    super.initState();
    _loadThemeFromPreferences();
  }

  Future<void> _loadThemeFromPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedTheme = _prefs.getString('selectedTheme');
    });
  }

  Future<void> _saveThemeToPreferences(String theme) async {
    await _prefs.setString('selectedTheme', theme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Select Theme'),
      ),
      body: GestureDetector(
        onLongPress: () {
          DbConnect _db = DbConnect();
          _db.open().then((value) async {
            var userCollection = await _db.getUsersCollection();
            final _userController = UserController(userCollection);

            await _userController.createUser(widget.user).then((value) async {
              _voiceController.speek(
                  message: "You have successfully signed up to app");
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("uid", widget.user.username);
              Future.delayed(const Duration(seconds: 3))
                  .then((value) => context.navigator(context, ItemListView()));
            });
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[50],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Visual Impairment:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              buildThemeOption('Color Blind', 'colorBlind'),
              SizedBox(height: 16),
              buildThemeOption('Far-sightedness', 'farSightedness'),
              SizedBox(height: 16),
              buildThemeOption('Fully Blind', 'fullyBlind'),
              if (_selectedTheme == 'colorBlind')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'Color Blind Options:',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    buildThemeOption(
                        'Red-Green Color Blindness', 'redGreenColorBlindness'),
                    SizedBox(height: 16),
                    buildThemeOption('Yellow-Blue Color Blindness',
                        'yellowBlueColorBlindness'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildThemeOption(String label, String value) {
    bool isSelected = _selectedTheme == value;
    return GestureDetector(
      onTap: () {
        _voiceController.speek(message: 'You are going to tap $label');
      },
      onDoubleTap: () {
        setState(() {
          _selectedTheme = value;
          _saveThemeToPreferences(value);
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected
                  ? Colors.blue
                  : Colors.grey), // Change border color
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
              fontSize: 18, color: isSelected ? Colors.blue : Colors.black),
        ),
      ),
    );
  }
}
