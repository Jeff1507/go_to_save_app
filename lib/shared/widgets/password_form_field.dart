import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final InputBorder? border;
  final String? Function(String?)? validator;
  final bool enabled;

  const PasswordFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.border,
    this.validator,
    this.enabled = true,
  });

  @override
  State<StatefulWidget> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      enabled: widget.enabled,
      validator: widget.validator,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: widget.border,
        suffixIcon: IconButton(
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          icon: Icon(
            _obscurePassword ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
    );
  }
}
