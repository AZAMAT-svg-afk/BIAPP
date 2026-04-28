import 'package:flutter/material.dart';

class GradientActionButton extends StatefulWidget {
  const GradientActionButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool compact;

  @override
  State<GradientActionButton> createState() => _GradientActionButtonState();
}

class _GradientActionButtonState extends State<GradientActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = widget.onPressed != null;
    final radius = BorderRadius.circular(widget.compact ? 18 : 999);

    return Opacity(
      opacity: enabled ? 1 : 0.55,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2E7D52), Color(0xFF4CAF50)],
            ),
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: scheme.primary.withValues(alpha: 0.30),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: widget.onPressed,
              onTapDown: enabled
                  ? (_) => setState(() => _pressed = true)
                  : null,
              onTapCancel: enabled
                  ? () => setState(() => _pressed = false)
                  : null,
              onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
              borderRadius: radius,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: widget.compact ? 14 : 20,
                  vertical: widget.compact ? 11 : 15,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: scheme.onPrimary, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Flexible(
                      child: Text(
                        widget.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
