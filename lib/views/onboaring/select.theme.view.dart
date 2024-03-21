import 'package:flutter/material.dart';

class SelectThemeView extends StatefulWidget {
  const SelectThemeView({Key? key}) : super(key: key);

  @override
  _SelectThemeViewState createState() => _SelectThemeViewState();
}

class _SelectThemeViewState extends State<SelectThemeView> {
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('Select Theme'),
      ),
      body: Padding(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
    );
  }

  Widget buildThemeOption(String label, String value) {
    bool isSelected = _selectedTheme == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTheme = value;
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
              fontSize: 18,
              color:
                  isSelected ? Colors.blue : Colors.black), // Change text color
        ),
      ),
    );
  }
}
