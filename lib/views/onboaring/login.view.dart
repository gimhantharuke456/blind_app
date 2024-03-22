import 'package:blind_app/controllers/auth.controller.dart';
import 'package:blind_app/controllers/dbconnect.dart';
import 'package:blind_app/controllers/openai.controller.dart';
import 'package:blind_app/controllers/speech.controller.dart';
import 'package:blind_app/controllers/user.controller.dart';
import 'package:blind_app/controllers/voice.controller.dart';
import 'package:blind_app/utils/index.dart';
import 'package:blind_app/views/home/item.list.view.dart';
import 'package:blind_app/views/onboaring/registation.view.dart';
import 'package:blind_app/widgets/custom_button.dart';
import 'package:blind_app/widgets/input_field.dart';
import 'package:blind_app/widgets/page_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final username = TextEditingController();
  final password = TextEditingController();
  final _voiceController = VoiceController();
  final _openAiController = OpenAiController();
  DbConnect dbConnect = DbConnect();

  late final SpeechController _speechController;

  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _speechController = SpeechController();

    try {
      _speechController.initialize().then((value) {});
    } catch (e) {
      debugPrint('Speech initializing failed $e');
    }

    super.initState();
  }

  void _startListeningForNavigationCommands() {
    _speechController.startListening(onResult: (result) async {
      if (result.contains('register')) {
        _speechController.stopListening();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RegistrationView()),
        );
      } else if (result.contains('login')) {
        _speechController.stopListening();
        _handleLogin();
      } else if (result.contains('face id')) {
        _speechController.stopListening();
        _authenticateWithBiometrics(context);
      } else if (result.contains("username")) {
        String? uname = await _openAiController.extractInformation(result);
        setState(() {
          username.text = uname ?? result;
        });
      } else if (result.contains("password")) {
        setState(() {
          password.text = result;
        });
      }
    });
  }

  void _handleLogin() async {
    if (username.text.isEmpty) {
      await _voiceController.speek(message: "Please , enter username!");
      return;
    }
    if (password.text.isEmpty) {
      await _voiceController.speek(message: "Please , enter password!");
      return;
    }

    await dbConnect.open();
    var userCollection = await dbConnect.getUsersCollection();
    final UserController controller = UserController(userCollection);
    try {
      await controller.login(username.text, password.text).then((value) async {
        if (value == null) {
          _voiceController.speek(message: "Login failed please try again");
          setState(() {
            username.clear();
            password.clear();
          });
        } else {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString("uid", value.email);
          context.navigator(context, ItemListView());
        }
      });
    } catch (e) {
      _voiceController.speek(message: "Login failed please try again");
      setState(() {
        username.clear();
        password.clear();
      });
    }
  }

  void _handleVoiceInput(TextEditingController controller) {
    _speechController.startListening(onResult: (text) {
      setState(() {
        controller.text = text;
      });
    });
  }

  @override
  void dispose() {
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _startListeningForNavigationCommands();
        },
        child: SingleChildScrollView(
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
                  focusNode: _usernameFocusNode,
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
                  focusNode: _passwordFocusNode,
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
                      _handleLogin();
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
                  label: "Login with Finger print",
                ),
              ],
            ),
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
