import 'package:flutter/material.dart';

class PasswordFormField extends StatefulWidget {
  const PasswordFormField(
      {Key? key,
      required this.initialValue,
      required this.enabled,
      required this.onChanged})
      : super(key: key);

  final String? initialValue;
  final bool enabled;
  final void Function(String) onChanged;

  @override
  State<PasswordFormField> createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final widgetEnabled = widget.enabled;
    var canShowText = widgetEnabled && !_obscureText;

    return TextFormField(
      readOnly: !widget.enabled,
      enabled: widget.enabled,
      obscureText: !canShowText,
      decoration: InputDecoration(
        labelText: 'Password',
        contentPadding: const EdgeInsets.all(10.0),
        suffixIcon: IconButton(
          onPressed: () => setState(() {
            _obscureText = !_obscureText;
          }),
          icon: Icon(
            canShowText ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      initialValue: widget.initialValue,
      onChanged: widget.onChanged,
    );
  }
}
