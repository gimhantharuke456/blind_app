import 'package:flutter/material.dart';

class InputFieldCustom extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final bool isTextArea; // New property to indicate textarea
  final TextEditingController? controller;
  final void Function(String)? onVoiceInput;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  const InputFieldCustom({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    this.isTextArea = false, // Default to single-line text input
    this.controller,
    this.onVoiceInput,
    this.focusNode,
    this.onTap,
  }) : super(key: key);

  @override
  State<InputFieldCustom> createState() => _InputFieldCustomState();
}

class _InputFieldCustomState extends State<InputFieldCustom> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () {
        widget.onTap?.call();
      },

      controller: _controller,
      focusNode: widget.focusNode,
      obscureText: widget.isPassword,
      maxLines: widget.isTextArea
          ? null
          : 1, // Allow multiple lines if it's a textarea
      minLines: widget.isTextArea ? 3 : null, // Set minimum lines for textarea
      decoration: InputDecoration(
        hintText: widget.hintText,
        filled: true,
        fillColor: Colors.grey.shade300,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
