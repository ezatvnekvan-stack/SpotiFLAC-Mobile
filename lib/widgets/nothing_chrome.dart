import 'package:flutter/material.dart';
import 'package:spotiflac_android/theme/nothing_theme.dart';

/// Keeps the existing app identity while drawing this edition's disc mark.
class NothingBrandImage extends StatelessWidget {
  const NothingBrandImage(this.asset, {super.key, this.width, this.height,
    this.color, this.fit, this.errorBuilder});
  final String asset;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (!context.isNothing) {
      return Image.asset(asset, width: width, height: height, color: color,
        fit: fit, errorBuilder: errorBuilder);
    }
    final c = Theme.of(context).colorScheme;
    return Semantics(label: 'SpotiFLAC', image: true,
      child: SizedBox(width: width, height: height,
        child: CustomPaint(painter: _DiscPainter(color ?? c.onSurface, c.primary))));
  }
}

class _DiscPainter extends CustomPainter {
  const _DiscPainter(this.ink, this.accent);
  final Color ink;
  final Color accent;
  @override
  void paint(Canvas canvas, Size size) {
    final side = size.shortestSide;
    final center = size.center(Offset.zero);
    final paint = Paint()..color = ink..style = PaintingStyle.stroke..strokeWidth = side * 0.035;
    canvas.drawCircle(center, side * 0.38, paint);
    canvas.drawCircle(center, side * 0.32, paint..strokeWidth = side * 0.012);
    paint.style = PaintingStyle.fill;
    const pattern = ['01111', '10000', '10000', '01110', '00001', '00001', '11110'];
    for (var row = 0; row < 7; row++) {
      for (var col = 0; col < 5; col++) {
        if (pattern[row][col] == '1') {
          canvas.drawCircle(center + Offset((col - 2) * side * 0.055, (row - 3) * side * 0.055), side * 0.018, paint);
        }
      }
    }
    canvas.drawCircle(center + Offset(side * 0.29, -side * 0.29), side * 0.055, paint..color = accent);
  }
  @override
  bool shouldRepaint(_DiscPainter oldDelegate) => oldDelegate.ink != ink || oldDelegate.accent != accent;
}

/// A static dot grid: never runs a ticker while the app is idle.
class NothingDotGrid extends StatelessWidget {
  const NothingDotGrid({super.key, this.child, this.opacity = 0.12});
  final Widget? child;
  final double opacity;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DotPainter(Theme.of(context).colorScheme.onSurface.withValues(alpha: opacity)),
    child: child,
  );
}

class _DotPainter extends CustomPainter {
  const _DotPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (double x = 8; x < size.width; x += 12) {
      for (double y = 8; y < size.height; y += 12) {
        canvas.drawCircle(Offset(x, y), 0.7, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPainter oldDelegate) => oldDelegate.color != color;
}
