import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/hero_material.dart';

class LoginFormField extends StatelessWidget {
  const LoginFormField(
    this.name, {
    this.padding = const EdgeInsets.symmetric(vertical: 8),
    this.validator,
    this.onSaved,
    this.optional = false,
    this.obscureText = false,
    this.initialValue,
    this.enabled = true,
    this.heroTag,
    Key? key,
  }) : super(key: key);

  final EdgeInsetsGeometry padding;
  final String name;
  final String? Function(String)? validator;
  final void Function(String?)? onSaved;
  final bool optional;
  final bool obscureText;
  final String? initialValue;
  final bool enabled;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget widget = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          TextFormField(
            enabled: enabled,
            initialValue: initialValue,
            obscureText: obscureText,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: name,
                contentPadding: const EdgeInsets.all(16)),
            validator: (value) {
              value = value ?? '';
              if (!optional && value.isEmpty) {
                return 'Required';
              }
              return validator?.call(value);
            },
            onSaved: onSaved,
          ),
        ],
      ),
    );

    if (heroTag != null) {
      widget = HeroMaterial(tag: heroTag!, child: widget);
    }
    return widget;
  }
}
