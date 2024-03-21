import 'package:blind_app/controllers/auth.controller.dart';
import 'package:blind_app/controllers/dbconnect.dart';
import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/views/onboaring/registation.view.dart';
import 'package:blind_app/widgets/custom_button.dart';
import 'package:blind_app/widgets/input_field.dart';
import 'package:blind_app/widgets/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final username = TextEditingController();
  final password = TextEditingController();
  final _voiceController = VoiceController();

  late final SpeechController _speechController;

  @override
  void initState() {
    _speechController = SpeechController();
    _speechController.initialize();
    DbConnect dbConnect =
        DbConnect("mongodb+srv://root:root@blindapp.rkpesgt.mongodb.net");

    dbConnect.open().then((value) => dbConnect.getUsersCollection());
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
              const PageTitle(title: "Login"),
              const SizedBox(
                height: 32,
              ),
              InputFieldCustom(
                hintText: "Username",
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
                isPassword: true,
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
                        message: "You are going to press Login Button");
                  },
                  onDoubleTap: () async {
                    if (username.text.isEmpty) {
                      await _voiceController.speek(
                          message: "Please , enter username!");
                      return;
                    }
                    if (password.text.isEmpty) {
                      await _voiceController.speek(
                          message: "Please , enter password!");
                      return;
                    }
                    //  await _userController.login(username.text, password.text);
                    context.navigator(context, ItemListView());
                  },
                  label: "Login"),
              const SizedBox(
                height: 32,
              ),
              CustomButton(
                onSingleTap: () async {
                  await _voiceController.speek(
                      message: "You are going to navigate register view");
                },
                onDoubleTap: () {
                  context.navigator(context, const RegistrationView());
                },
                label: "Don't have an account? Sign up now",
              ),
              const SizedBox(height: 32),
              CustomButton(
                onSingleTap: () async {
                  await _voiceController.speek(
                      message: "You are going to press face i.d button");
                },
                onDoubleTap: () {
                  _authenticateWithBiometrics(context);
                },
                label: "Login with Face ID",
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
        context.navigator(context, ItemListView(), shouldAuthenticate: false);
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
