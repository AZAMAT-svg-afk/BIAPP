import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

enum AppBackgroundMood { calm, home, prayer, ai, stats }

class AppBackground extends StatelessWidget {
  const AppBackground({
    required this.child,
    this.mood = AppBackgroundMood.calm,
    super.key,
  });

  final Widget child;
  final AppBackgroundMood mood;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final colors = _BackgroundColors.from(context, mood);

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [colors.top, colors.middle, colors.bottom],
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: CustomPaint(
                painter: _PremiumBackgroundPainter(
                  mood: mood,
                  primary: scheme.primary,
                  secondary: scheme.secondary,
                  line: scheme.outlineVariant,
                  surface: palette.background,
                  brightness: scheme.brightness,
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _BackgroundColors {
  const _BackgroundColors({
    required this.top,
    required this.middle,
    required this.bottom,
  });

  final Color top;
  final Color middle;
  final Color bottom;

  factory _BackgroundColors.from(BuildContext context, AppBackgroundMood mood) {
    final palette = context.palette;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color blend(Color color, double alpha) {
      return Color.alphaBlend(
        color.withValues(alpha: alpha),
        palette.background,
      );
    }

    return switch (mood) {
      AppBackgroundMood.home => _BackgroundColors(
        top: blend(palette.emerald, isDark ? 0.22 : 0.11),
        middle: palette.background,
        bottom: blend(palette.gold, isDark ? 0.12 : 0.09),
      ),
      AppBackgroundMood.prayer => _BackgroundColors(
        top: blend(palette.gold, isDark ? 0.14 : 0.10),
        middle: blend(palette.emerald, isDark ? 0.12 : 0.06),
        bottom: palette.backgroundAlt,
      ),
      AppBackgroundMood.ai => _BackgroundColors(
        top: blend(palette.emerald, isDark ? 0.20 : 0.08),
        middle: blend(const Color(0xFF6F7CFF), isDark ? 0.10 : 0.035),
        bottom: blend(palette.gold, isDark ? 0.08 : 0.05),
      ),
      AppBackgroundMood.stats => _BackgroundColors(
        top: blend(palette.emerald, isDark ? 0.12 : 0.06),
        middle: palette.background,
        bottom: blend(const Color(0xFF8B5CF6), isDark ? 0.07 : 0.025),
      ),
      AppBackgroundMood.calm => _BackgroundColors(
        top: palette.background,
        middle: blend(palette.emerald, isDark ? 0.08 : 0.035),
        bottom: blend(palette.gold, isDark ? 0.07 : 0.035),
      ),
    };
  }
}

class _PremiumBackgroundPainter extends CustomPainter {
  const _PremiumBackgroundPainter({
    required this.mood,
    required this.primary,
    required this.secondary,
    required this.line,
    required this.surface,
    required this.brightness,
  });

  final AppBackgroundMood mood;
  final Color primary;
  final Color secondary;
  final Color line;
  final Color surface;
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    _paintBroadLight(canvas, size);
    _paintGeometry(canvas, size);
  }

  void _paintBroadLight(Canvas canvas, Size size) {
    final primaryAlpha = brightness == Brightness.dark ? 0.18 : 0.10;
    final secondaryAlpha = brightness == Brightness.dark ? 0.12 : 0.08;
    final moodBoost = switch (mood) {
      AppBackgroundMood.home => 1.16,
      AppBackgroundMood.ai => 1.22,
      AppBackgroundMood.prayer => 1.10,
      _ => 1.0,
    };

    final paint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.88, -0.98),
        radius: 1.12,
        colors: [
          primary.withValues(alpha: primaryAlpha * moodBoost),
          primary.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);

    paint.shader = RadialGradient(
      center: const Alignment(1.18, 1.08),
      radius: 1.05,
      colors: [
        secondary.withValues(alpha: secondaryAlpha * moodBoost),
        secondary.withValues(alpha: 0),
      ],
    ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintGeometry(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.85
      ..color = line.withValues(
        alpha: brightness == Brightness.dark ? 0.20 : 0.34,
      );
    final accentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = secondary.withValues(
        alpha: brightness == Brightness.dark ? 0.06 : 0.08,
      );

    final step = switch (mood) {
      AppBackgroundMood.ai => 118.0,
      AppBackgroundMood.prayer => 104.0,
      _ => 132.0,
    };

    for (var y = -step; y < size.height + step; y += step) {
      for (var x = -step; x < size.width + step; x += step) {
        final center = Offset(x + step / 2, y + step / 2);
        _drawDiamond(canvas, center, step * 0.22, paint);
        if (mood == AppBackgroundMood.prayer ||
            mood == AppBackgroundMood.home) {
          canvas.drawCircle(center, step * 0.13, accentPaint);
        }
      }
    }
  }

  void _drawDiamond(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (var i = 0; i < 4; i++) {
      final angle = math.pi / 4 + i * math.pi / 2;
      final point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PremiumBackgroundPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary ||
        oldDelegate.line != line ||
        oldDelegate.surface != surface ||
        oldDelegate.brightness != brightness;
  }
}
