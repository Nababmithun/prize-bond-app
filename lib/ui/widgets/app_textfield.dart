import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  const AppTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.prefixIcon,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscure;
  @override
  void initState() {
    _obscure = widget.obscure;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _obscure,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscure ? IconButton(
          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => _obscure = !_obscure),
        ) : null,
      ),
    );
  }
}
