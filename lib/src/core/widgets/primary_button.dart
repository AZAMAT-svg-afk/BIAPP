import 'package:flutter/material.dart';

import 'gradient_action_button.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: GradientActionButton(
        label: label,
        icon: icon,
        onPressed: onPressed,
      ),
    );
  }
}
