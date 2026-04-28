import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../preferences/app_preferences.dart';
import '../theme/app_palette.dart';

enum AppBackgroundMood { calm, home, prayer, ai, stats }

class AppBackground extends ConsumerStatefulWidget {
  const AppBackground({
    required this.child,
    this.mood = AppBackgroundMood.calm,
    super.key,
  });

  final Widget child;
  final AppBackgroundMood mood;

  @override
  ConsumerState<AppBackground> createState() => _AppBackgroundState();
}

class _AppBackgroundState extends ConsumerState<AppBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final scheme = Theme.of(context).colorScheme;
    final colors = _BackgroundColors.from(context, widget.mood);
    final style = ref.watch(backgroundStyleControllerProvider);

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
                painter: _AnimatedBackgroundPainter(
                  repaint: _controller,
                  style: style,
                  mood: widget.mood,
                  primary: scheme.primary,
                  secondary: scheme.secondary,
                  line: scheme.outlineVariant,
                  surface: palette.background,
                  brightness: scheme.brightness,
                ),
              ),
            ),
            widget.child,
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
        top: blend(palette.emerald, isDark ? 0.22 : 0.12),
        middle: blend(const Color(0xFF4DB6AC), isDark ? 0.12 : 0.08),
        bottom: blend(palette.gold, isDark ? 0.10 : 0.08),
      ),
      AppBackgroundMood.prayer => _BackgroundColors(
        top: blend(palette.gold, isDark ? 0.14 : 0.10),
        middle: blend(palette.emerald, isDark ? 0.14 : 0.07),
        bottom: palette.backgroundAlt,
      ),
      AppBackgroundMood.ai => _BackgroundColors(
        top: blend(const Color(0xFF3DD6C6), isDark ? 0.22 : 0.10),
        middle: blend(const Color(0xFF6F7CFF), isDark ? 0.10 : 0.035),
        bottom: blend(palette.emerald, isDark ? 0.10 : 0.06),
      ),
      AppBackgroundMood.stats => _BackgroundColors(
        top: blend(palette.emerald, isDark ? 0.12 : 0.07),
        middle: palette.background,
        bottom: blend(const Color(0xFF8BDFCD), isDark ? 0.07 : 0.05),
      ),
      AppBackgroundMood.calm => _BackgroundColors(
        top: palette.background,
        middle: blend(const Color(0xFF4DB6AC), isDark ? 0.10 : 0.05),
        bottom: blend(palette.emerald, isDark ? 0.07 : 0.04),
      ),
    };
  }
}

class _AnimatedBackgroundPainter extends CustomPainter {
  _AnimatedBackgroundPainter({
    required Animation<double> repaint,
    required this.style,
    required this.mood,
    required this.primary,
    required this.secondary,
    required this.line,
    required this.surface,
    required this.brightness,
  }) : _progress = repaint,
       super(repaint: repaint);

  final Animation<double> _progress;
  final BackgroundAnimationStyle style;
  final AppBackgroundMood mood;
  final Color primary;
  final Color secondary;
  final Color line;
  final Color surface;
  final Brightness brightness;

  @override
  void paint(Canvas canvas, Size size) {
    final progress = _progress.value;
    _paintAuroraWash(canvas, size, progress);

    switch (style) {
      case BackgroundAnimationStyle.steppe:
        _paintSteppe(canvas, size, progress);
      case BackgroundAnimationStyle.particles:
        _paintParticles(canvas, size, progress);
      case BackgroundAnimationStyle.aurora:
        _paintAuroraBands(canvas, size, progress);
    }

    _paintGeometry(canvas, size);
  }

  void _paintAuroraWash(Canvas canvas, Size size, double progress) {
    final alpha = brightness == Brightness.dark ? 0.18 : 0.10;
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment(-1 + math.sin(progress * math.pi * 2) * 0.18, -1),
        end: Alignment(1, 1 + math.cos(progress * math.pi * 2) * 0.16),
        colors: [
          primary.withValues(alpha: alpha),
          const Color(0xFF4DB6AC).withValues(alpha: alpha * 0.72),
          secondary.withValues(alpha: alpha * 0.46),
          Colors.transparent,
        ],
        stops: const [0, 0.36, 0.68, 1],
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, paint);
  }

  void _paintAuroraBands(Canvas canvas, Size size, double progress) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 26
      ..strokeCap = StrokeCap.round
      ..color = primary.withValues(
        alpha: brightness == Brightness.dark ? 0.14 : 0.08,
      );

    for (var band = 0; band < 3; band++) {
      final path = Path();
      final baseY = size.height * (0.18 + band * 0.16);
      path.moveTo(-40, baseY);
      for (var x = -40.0; x <= size.width + 60; x += 60) {
        final wave =
            math.sin(
              (x / size.width * math.pi * 2) + progress * math.pi * 2 + band,
            ) *
            18;
        path.lineTo(x, baseY + wave);
      }
      paint.color = Color.lerp(
        primary,
        secondary,
        band / 3,
      )!.withValues(alpha: brightness == Brightness.dark ? 0.13 : 0.075);
      canvas.drawPath(path, paint);
    }
  }

  void _paintSteppe(Canvas canvas, Size size, double progress) {
    final horizon = size.height * 0.72;
    final steppePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          primary.withValues(
            alpha: brightness == Brightness.dark ? 0.10 : 0.07,
          ),
          const Color(
            0xFF7FB069,
          ).withValues(alpha: brightness == Brightness.dark ? 0.18 : 0.12),
        ],
      ).createShader(Rect.fromLTWH(0, horizon, size.width, size.height));

    final path = Path()
      ..moveTo(0, horizon)
      ..quadraticBezierTo(
        size.width * 0.28,
        horizon - 22,
        size.width * 0.55,
        horizon - 8,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        horizon + 4,
        size.width,
        horizon - 18,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, steppePaint);

    final cloudPaint = Paint()
      ..color = Colors.white.withValues(
        alpha: brightness == Brightness.dark ? 0.09 : 0.18,
      );
    for (var i = 0; i < 4; i++) {
      final x = ((size.width + 160) * ((progress + i * 0.27) % 1)) - 120;
      final y = size.height * (0.18 + i * 0.09);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, 92, 18),
          const Radius.circular(999),
        ),
        cloudPaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x + 24, y - 10, 56, 22),
          const Radius.circular(999),
        ),
        cloudPaint,
      );
    }
  }

  void _paintParticles(Canvas canvas, Size size, double progress) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = secondary.withValues(
        alpha: brightness == Brightness.dark ? 0.20 : 0.15,
      );

    for (var i = 0; i < 24; i++) {
      final seed = i * 37.0;
      final x = (math.sin(seed) * 0.5 + 0.5) * size.width;
      final drift = math.sin(progress * math.pi * 2 + i) * 14;
      final y =
          ((math.cos(seed * 1.7) * 0.5 + 0.5) * size.height +
              progress * 42 +
              i * 6) %
          size.height;
      final radius = 1.6 + (i % 3) * 0.9;
      canvas.drawCircle(Offset(x + drift, y), radius, paint);
    }
  }

  void _paintGeometry(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.85
      ..color = line.withValues(
        alpha: brightness == Brightness.dark ? 0.16 : 0.26,
      );

    final step = switch (mood) {
      AppBackgroundMood.ai => 120.0,
      AppBackgroundMood.prayer => 106.0,
      _ => 136.0,
    };

    for (var y = -step; y < size.height + step; y += step) {
      for (var x = -step; x < size.width + step; x += step) {
        _drawDiamond(
          canvas,
          Offset(x + step / 2, y + step / 2),
          step * 0.20,
          paint,
        );
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
  bool shouldRepaint(covariant _AnimatedBackgroundPainter oldDelegate) {
    return oldDelegate.style != style ||
        oldDelegate.mood != mood ||
        oldDelegate.primary != primary ||
        oldDelegate.secondary != secondary ||
        oldDelegate.line != line ||
        oldDelegate.surface != surface ||
        oldDelegate.brightness != brightness;
  }
}
