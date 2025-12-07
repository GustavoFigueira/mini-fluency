import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';

class CompletionCelebration extends StatefulWidget {
  final VoidCallback onComplete;

  const CompletionCelebration({
    super.key,
    required this.onComplete,
  });

  @override
  State<CompletionCelebration> createState() => _CompletionCelebrationState();
}

class _CompletionCelebrationState extends State<CompletionCelebration>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _particlesController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _particlesAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    _particlesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _particlesController,
        curve: Curves.easeOut,
      ),
    );

    _startAnimation();
  }

  void _startAnimation() {
    _scaleController.forward();
    _particlesController.forward();

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _particlesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: Colors.black.withValues(alpha: 0.7),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _buildParticles(),
              _buildCelebrationContent(),
            ],
          ),
        ),
      );

  Widget _buildParticles() => AnimatedBuilder(
        animation: _particlesAnimation,
        builder: (context, child) => CustomPaint(
          size: MediaQuery.of(context).size,
          painter: ParticlesPainter(_particlesAnimation.value),
        ),
      );

  Widget _buildCelebrationContent() => AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.6),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 80,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Missão Concluída!',
                style: AppTypography.displaySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Parabéns! Você completou todas as tarefas.',
                style: AppTypography.bodyLarge.copyWith(
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
}

class ParticlesPainter extends CustomPainter {
  final double progress;

  ParticlesPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    const particleCount = 20;

    for (var i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi;
      final distance = 100 * progress;
      final x = center.dx + distance * math.cos(angle);
      final y = center.dy + distance * math.sin(angle);

      final alpha = (1 - progress).clamp(0.0, 1.0);
      paint.color = AppColors.success.withValues(alpha: alpha);

      canvas.drawCircle(
        Offset(x, y),
        8 * (1 - progress),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ParticlesPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
