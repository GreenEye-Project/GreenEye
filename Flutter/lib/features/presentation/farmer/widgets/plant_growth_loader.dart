import 'package:flutter/material.dart';
import 'dart:math' as math;

class PlantGrowthLoader extends StatefulWidget {
  final String? message;
  final String? subtitle;
  final double size;
  final bool showContainer;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const PlantGrowthLoader({
    super.key,
    this.message,
    this.subtitle,
    this.size = 120,
    this.showContainer = true,
    this.backgroundColor,
    this.padding,
  });

  /// Inline version without container - for use in tight spaces
  const PlantGrowthLoader.inline({super.key, this.size = 60})
    : message = null,
      subtitle = null,
      showContainer = false,
      backgroundColor = null,
      padding = null;

  /// Show as an overlay dialog
  static void overlay(
    BuildContext context, {
    String? message,
    String? subtitle,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: PlantGrowthLoader(message: message, subtitle: subtitle),
        ),
      ),
    );
  }

  /// Close the overlay
  static void close(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  State<PlantGrowthLoader> createState() => _PlantGrowthLoaderState();
}

class _PlantGrowthLoaderState extends State<PlantGrowthLoader>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _growthAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _growthAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantWidget = SizedBox(
      height: widget.size,
      width: widget.size,
      child: AnimatedBuilder(
        animation: _growthAnimation,
        builder: (context, child) {
          return CustomPaint(
            size: Size(widget.size, widget.size),
            painter: PrettyPlantPainter(_growthAnimation.value),
          );
        },
      ),
    );

    // Inline version - just the animation
    if (!widget.showContainer) {
      return plantWidget;
    }

    // Full version with container and text
    return Container(
      padding: widget.padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          plantWidget,
          if (widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class PrettyPlantPainter extends CustomPainter {
  final double progress;

  PrettyPlantPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.75);

    // Animation stages
    final seedStage = (progress * 4).clamp(0.0, 1.0);
    final stemStage = ((progress * 4) - 1).clamp(0.0, 1.0);
    final leavesStage = ((progress * 4) - 2).clamp(0.0, 1.0);
    final flowerStage = ((progress * 4) - 3).clamp(0.0, 1.0);

    // Draw decorative pot
    _drawPot(canvas, center, size);

    // Draw soil
    _drawSoil(canvas, center, size);

    if (seedStage < 0.3) {
      // Stage 1: Seed with glow
      _drawSeed(canvas, center, seedStage);
    } else {
      // Stage 2: Growing stem with curve
      _drawStem(canvas, center, stemStage, size);

      // Stage 3: Beautiful leaves
      if (leavesStage > 0) {
        _drawLeaves(canvas, center, stemStage, leavesStage, size);
      }

      // Stage 4: Cute flower on top
      if (flowerStage > 0) {
        _drawFlower(canvas, center, stemStage, flowerStage, size);
      }
    }

    // Sparkles around the plant
    if (progress > 0.7) {
      _drawSparkles(canvas, center, progress, size);
    }
  }

  void _drawPot(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xFFD2691E), const Color(0xFF8B4513)],
      ).createShader(Rect.fromLTWH(center.dx - 35, center.dy - 10, 70, 35));

    final potPath = Path();
    potPath.moveTo(center.dx - 30, center.dy - 10);
    potPath.lineTo(center.dx - 35, center.dy + 25);
    potPath.quadraticBezierTo(
      center.dx,
      center.dy + 28,
      center.dx + 35,
      center.dy + 25,
    );
    potPath.lineTo(center.dx + 30, center.dy - 10);
    potPath.close();

    canvas.drawPath(potPath, paint);

    // Pot rim
    paint.shader = null;
    paint.color = const Color(0xFFA0522D);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(center.dx - 32, center.dy - 15, 64, 8),
        const Radius.circular(4),
      ),
      paint,
    );
  }

  void _drawSoil(Canvas canvas, Offset center, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFF3D2817);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - 8),
        width: 56,
        height: 12,
      ),
      paint,
    );
  }

  void _drawSeed(Canvas canvas, Offset center, double stage) {
    final paint = Paint()..style = PaintingStyle.fill;

    // Glow effect
    paint.color = Colors.green.withOpacity(0.2 * stage);
    canvas.drawCircle(center - const Offset(0, 8), 8 * stage, paint);

    // Seed
    paint.color = const Color(0xFF8B7355);
    canvas.drawOval(
      Rect.fromCenter(center: center - const Offset(0, 8), width: 6, height: 8),
      paint,
    );
  }

  void _drawStem(Canvas canvas, Offset center, double stage, Size size) {
    final stemHeight = 60 * stage;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    // Stem gradient
    paint.shader =
        LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [const Color(0xFF2D5016), const Color(0xFF4A7C23)],
        ).createShader(
          Rect.fromLTWH(
            center.dx - 2,
            center.dy - 8 - stemHeight,
            4,
            stemHeight,
          ),
        );

    // Curved stem
    final stemPath = Path();
    stemPath.moveTo(center.dx, center.dy - 8);

    final controlPoint = Offset(
      center.dx + (math.sin(stage * math.pi) * 8),
      center.dy - 8 - stemHeight * 0.5,
    );

    stemPath.quadraticBezierTo(
      controlPoint.dx,
      controlPoint.dy,
      center.dx,
      center.dy - 8 - stemHeight,
    );

    canvas.drawPath(stemPath, paint);
  }

  void _drawLeaves(
    Canvas canvas,
    Offset center,
    double stemStage,
    double leafStage,
    Size size,
  ) {
    final stemHeight = 60 * stemStage;
    // ignore: unused_local_variable
    final paint = Paint()..style = PaintingStyle.fill;

    // Multiple pairs of leaves
    for (int i = 0; i < 3; i++) {
      final leafProgress = ((leafStage * 3) - i).clamp(0.0, 1.0);
      if (leafProgress <= 0) continue;

      final yPos = center.dy - 8 - stemHeight * (0.3 + i * 0.25);

      // Left leaf
      _drawPrettyLeaf(
        canvas,
        Offset(center.dx, yPos),
        -1,
        leafProgress,
        20 + i * 3,
      );

      // Right leaf
      _drawPrettyLeaf(
        canvas,
        Offset(center.dx, yPos + 5),
        1,
        leafProgress,
        18 + i * 3,
      );
    }
  }

  void _drawPrettyLeaf(
    Canvas canvas,
    Offset position,
    double direction,
    double progress,
    double size,
  ) {
    final paint = Paint()..style = PaintingStyle.fill;

    final leafSize = size * progress;

    // Leaf gradient
    paint.shader = RadialGradient(
      colors: [
        const Color(0xFF7CFC00),
        const Color(0xFF32CD32),
        const Color(0xFF228B22),
      ],
      stops: const [0.0, 0.5, 1.0],
    ).createShader(Rect.fromCircle(center: position, radius: leafSize));

    final leafPath = Path();
    leafPath.moveTo(position.dx, position.dy);

    // Curved leaf shape
    leafPath.cubicTo(
      position.dx + (direction * leafSize * 0.3),
      position.dy - leafSize * 0.6,
      position.dx + (direction * leafSize * 0.8),
      position.dy - leafSize * 0.4,
      position.dx + (direction * leafSize),
      position.dy - leafSize * 0.1,
    );

    leafPath.cubicTo(
      position.dx + (direction * leafSize * 0.8),
      position.dy + leafSize * 0.1,
      position.dx + (direction * leafSize * 0.3),
      position.dy + leafSize * 0.3,
      position.dx,
      position.dy,
    );

    canvas.drawPath(leafPath, paint);

    // Leaf vein
    paint.shader = null;
    paint.color = const Color(0xFF1a5f0f).withOpacity(0.5);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 1;

    final veinPath = Path();
    veinPath.moveTo(position.dx, position.dy);
    veinPath.lineTo(
      position.dx + (direction * leafSize * 0.7),
      position.dy - leafSize * 0.05,
    );
    canvas.drawPath(veinPath, paint);
  }

  void _drawFlower(
    Canvas canvas,
    Offset center,
    double stemStage,
    double flowerStage,
    Size size,
  ) {
    final stemHeight = 60 * stemStage;
    final flowerCenter = Offset(center.dx, center.dy - 8 - stemHeight);

    final paint = Paint()..style = PaintingStyle.fill;

    // Flower petals
    final petalCount = 5;
    final petalSize = 10 * flowerStage;

    for (int i = 0; i < petalCount; i++) {
      final angle =
          (i * 2 * math.pi / petalCount) + (flowerStage * math.pi * 0.1);
      final petalTip = Offset(
        flowerCenter.dx + math.cos(angle) * petalSize,
        flowerCenter.dy + math.sin(angle) * petalSize,
      );

      // Petal gradient - pink to light pink
      paint.shader =
          RadialGradient(
            colors: [const Color(0xFFFFB6C1), const Color(0xFFFF69B4)],
          ).createShader(
            Rect.fromCircle(center: petalTip, radius: petalSize * 0.6),
          );

      canvas.drawCircle(petalTip, petalSize * 0.6, paint);
    }

    // Flower center (yellow)
    paint.shader = RadialGradient(
      colors: [const Color(0xFFFFFF00), const Color(0xFFFFD700)],
    ).createShader(Rect.fromCircle(center: flowerCenter, radius: 5));

    canvas.drawCircle(flowerCenter, 5 * flowerStage, paint);

    // Flower center detail
    paint.shader = null;
    paint.color = const Color(0xFFFF8C00).withOpacity(0.6);
    canvas.drawCircle(flowerCenter, 3 * flowerStage, paint);
  }

  void _drawSparkles(Canvas canvas, Offset center, double progress, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.yellow.withOpacity((progress - 0.7) * 2);

    final sparklePositions = [
      Offset(center.dx - 40, center.dy - 60),
      Offset(center.dx + 40, center.dy - 50),
      Offset(center.dx - 30, center.dy - 30),
      Offset(center.dx + 35, center.dy - 70),
    ];

    for (int i = 0; i < sparklePositions.length; i++) {
      final sparkleProgress = ((progress - 0.7) * 4 - i * 0.1).clamp(0.0, 1.0);
      if (sparkleProgress > 0) {
        _drawSparkle(canvas, sparklePositions[i], sparkleProgress * 4, paint);
      }
    }
  }

  void _drawSparkle(Canvas canvas, Offset position, double size, Paint paint) {
    final sparklePath = Path();

    // Four-pointed star
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final x = position.dx + math.cos(angle) * size;
      final y = position.dy + math.sin(angle) * size;

      if (i == 0) {
        sparklePath.moveTo(x, y);
      } else {
        sparklePath.lineTo(x, y);
      }

      // Add inner points
      final innerAngle = angle + math.pi / 4;
      final innerX = position.dx + math.cos(innerAngle) * size * 0.3;
      final innerY = position.dy + math.sin(innerAngle) * size * 0.3;
      sparklePath.lineTo(innerX, innerY);
    }

    sparklePath.close();
    canvas.drawPath(sparklePath, paint);
  }

  @override
  bool shouldRepaint(PrettyPlantPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
