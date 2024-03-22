import 'package:blind_app/controllers/auth.controller.dart';
import 'package:blind_app/controllers/dbconnect.dart';
import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/user.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/models/user.model.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/views/onboaring/login.view.dart';
import 'package:blind_app/views/onboaring/select.theme.view.dart';
import 'package:blind_app/widgets/custom_button.dart';
import 'package:blind_app/widgets/input_field.dart';
import 'package:blind_app/widgets/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationView extends StatefulWidget {
  const RegistrationView({super.key});

  @override
  State<RegistrationView> createState() => _LoginViewState();
}

class _LoginViewState extends State<RegistrationView> {
  final username = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phoneNumber = TextEditingController();
  final address = TextEditingController();
  final city = TextEditingController();
  final _voiceController = VoiceController();

  late final SpeechController _speechController;

  @override
  void initState() {
    _speechController = SpeechController();
    _speechController.initialize();

    super.initState();
  }

  void _handleVoiceInput(TextEditingController controller) {
    _speechController.startListening(onResult: (text) {
      setState(() {
        controller.text = text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: kToolbarHeight,
              ),
              const PageTitle(title: "Register"),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "Name",
                controller: name,
                onTap: () {
                  _handleVoiceInput(name);
                },
              ),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "Phone no",
                controller: phoneNumber,
                onTap: () {
                  _handleVoiceInput(phoneNumber);
                },
              ),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "Address",
                controller: address,
                onTap: () {
                  _handleVoiceInput(address);
                },
              ),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "City",
                controller: city,
                onTap: () {
                  _handleVoiceInput(city);
                },
              ),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "User name",
                controller: username,
                onTap: () {
                  _handleVoiceInput(username);
                },
              ),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "Password",
                controller: password,
                onTap: () {
                  _handleVoiceInput(password);
                },
              ),
              const SizedBox(
                height: 32,
              ),
              CustomButton(
                onSingleTap: () async {
                  await _voiceController.speek(
                    message: "You are going to press Register Button",
                  );
                },
                onDoubleTap: () async {
                  if (username.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a username!",
                    );
                    return;
                  }
                  if (password.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a password!",
                    );
                    return;
                  }
                  if (city.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a city!",
                    );
                    return;
                  }
                  if (name.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a name!",
                    );
                    return;
                  }
                  if (phoneNumber.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a phone number!",
                    );
                    return;
                  }
                  if (address.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter an address!",
                    );
                    return;
                  }
                  User user = User(
                    id: null,
                    username: username.text,
                    email: username.text,
                    password: password.text,
                    billingAddress: address.text,
                    phone: phoneNumber.text,
                    shippingAddress: city.text,
                  );
                  // context.navigator(context, ItemListView());
                  DbConnect _db = DbConnect();
                  _db.open().then((value) async {
                    var userCollection = await _db.getUsersCollection();
                    final _userController = UserController(userCollection);

                    await _userController.createUser(user).then((value) async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("uid", username.text);
                      _voiceController.speek(
                          message: "You have succesfully logged in");
                      Future.delayed(const Duration(seconds: 2)).then((value) =>
                          context.navigator(context, ItemListView()));
                    });
                  });
                },
                label: "Register",
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onSingleTap: () async {
                  await _voiceController.speek(
                    message: "Create face id button",
                  );
                },
                onDoubleTap: () {
                  _authenticateWithBiometrics(context);
                },
                label: "Create Face ID",
              ),
              const SizedBox(
                height: 32,
              ),
              CustomButton(
                onSingleTap: () async {
                  await _voiceController.speek(
                    message: "Add theme button",
                  );
                },
                onDoubleTap: () async {
                  if (username.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a username!",
                    );
                    return;
                  }
                  if (password.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a password!",
                    );
                    return;
                  }
                  if (city.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a city!",
                    );
                    return;
                  }
                  if (name.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a name!",
                    );
                    return;
                  }
                  if (phoneNumber.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter a phone number!",
                    );
                    return;
                  }
                  if (address.text.isEmpty) {
                    await _voiceController.speek(
                      message: "Please enter an address!",
                    );
                    return;
                  }
                  User user = User(
                    id: null,
                    username: username.text,
                    email: username.text,
                    password: password.text,
                    billingAddress: address.text,
                    phone: phoneNumber.text,
                    shippingAddress: city.text,
                  );
                  context.navigator(
                      context,
                      SelectThemeView(
                        user: user,
                      ));
                },
                label: "Add Theme",
              ),
              const SizedBox(
                height: 16,
              ),
              CustomButton(
                onSingleTap: () async {
                  await _voiceController.speek(
                    message: "You are going to navigate login view",
                  );
                },
                onDoubleTap: () {
                  context.navigator(context, const LoginView());
                },
                label: "Already have an account? Login now",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authenticateWithBiometrics(BuildContext context) async {
    try {
      final isAuthenticated = await Authentication.authentication();
      if (isAuthenticated) {
        context.navigator(
          context,
          ItemListView(),
          shouldAuthenticate: false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }
}
