import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';

class LessonTransition extends StatefulWidget {
  final LessonModel previousLesson;
  final LessonModel currentLesson;
  final Widget child;

  const LessonTransition({
    super.key,
    required this.previousLesson,
    required this.currentLesson,
    required this.child,
  });

  @override
  State<LessonTransition> createState() => _LessonTransitionState();
}

class _LessonTransitionState extends State<LessonTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  bool _hasCompleted = false;

  @override
  void initState() {
    super.initState();

    final wasCompleted = widget.previousLesson.status == LessonStatus.completed;
    final isNowCompleted = widget.currentLesson.status == LessonStatus.completed;

    if (!wasCompleted && isNowCompleted) {
      _hasCompleted = true;
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (_hasCompleted) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCompleted) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          if (_glowAnimation.value > 0)
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.success.withValues(
                      alpha: _glowAnimation.value * 0.5,
                    ),
                    blurRadius: 30 * _glowAnimation.value,
                    spreadRadius: 10 * _glowAnimation.value,
                  ),
                ],
              ),
            ),
          Transform.scale(
            scale: _scaleAnimation.value,
            child: Opacity(
              opacity: _glowAnimation.value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success,
                      AppColors.successLight,
                    ],
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
