import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class AppCard extends StatefulWidget {
  const AppCard({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.color,
    this.gradient,
    this.borderRadius = 22,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Gradient? gradient;
  final double borderRadius;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final palette = context.palette;
    final radius = BorderRadius.circular(widget.borderRadius);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.985, end: 1),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 10 * (1 - value)),
          child: Opacity(opacity: value.clamp(0, 1), child: child),
        );
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.985 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: RepaintBoundary(
          child: Material(
            color: Colors.transparent,
            borderRadius: radius,
            child: InkWell(
              onTap: widget.onTap,
              onTapDown: widget.onTap == null
                  ? null
                  : (_) => setState(() => _isPressed = true),
              onTapCancel: widget.onTap == null
                  ? null
                  : () => setState(() => _isPressed = false),
              onTapUp: widget.onTap == null
                  ? null
                  : (_) => setState(() => _isPressed = false),
              borderRadius: radius,
              child: Ink(
                width: double.infinity,
                padding: widget.padding,
                decoration: BoxDecoration(
                  color: widget.gradient == null
                      ? widget.color ?? palette.card.withValues(alpha: 0.94)
                      : null,
                  gradient: widget.gradient,
                  borderRadius: radius,
                  border: Border.all(
                    color: scheme.outlineVariant.withValues(alpha: 0.72),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.shadow,
                      blurRadius: 28,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
