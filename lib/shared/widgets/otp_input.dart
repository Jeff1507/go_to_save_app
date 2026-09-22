import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpInput extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final String? Function(String?)? validator;
  final ValueChanged<String> onCompleted;

  const OtpInput({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onCompleted,
    this.validator,
    this.enabled = true,
  });

  @override
  State<StatefulWidget> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  String? _errorText;

  void _handleCompleted(String pin) {
    final error = widget.validator?.call(pin);
    setState(() => _errorText = error);

    if (error == null) {
      widget.onCompleted(pin);
    }
  }

  void _handleChanged(String _) {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultPinTheme = PinTheme(
      width: 64,
      height: 64,
      textStyle: theme.textTheme.bodyLarge,
      decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 300,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Pinput(
            length: 6,
            controller: widget.controller,
            focusNode: widget.focusNode,
            enabled: widget.enabled,
            onCompleted: _handleCompleted,
            onChanged: _handleChanged,
            separatorBuilder: (index) => SizedBox(height: 64, width: 2),
            defaultPinTheme: defaultPinTheme,
            showCursor: true,
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
        ),

        if (_errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 12),
            child: Text(
              _errorText!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }
}
