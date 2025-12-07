import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';

class LessonNode extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback? onTap;
  final bool showConnector;

  const LessonNode({
    super.key,
    required this.lesson,
    this.onTap,
    this.showConnector = true,
  });

  @override
  State<LessonNode> createState() => _LessonNodeState();
}

class _LessonNodeState extends State<LessonNode>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.lesson.status == LessonStatus.current) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(LessonNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.lesson.status == LessonStatus.current &&
        !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (widget.lesson.status != LessonStatus.current &&
        _pulseController.isAnimating) {
      _pulseController
        ..stop()
        ..reset();
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          GestureDetector(
            onTap: widget.lesson.isAccessible ? widget.onTap : null,
            child: Row(
              children: [
                _buildNodeCircle(),
                AppSpacing.horizontalGapLG,
                Expanded(child: _buildLessonInfo()),
              ],
            ),
          ),
          if (widget.showConnector) _buildConnector(),
        ],
      );

  Widget _buildNodeCircle() => AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          final scale = widget.lesson.status == LessonStatus.current
              ? _pulseAnimation.value
              : 1.0;

          return Transform.scale(
            scale: scale,
            child: child,
          );
        },
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: _getGradient(),
            boxShadow: [
              BoxShadow(
                color: _getGlowColor(),
                blurRadius:
                    widget.lesson.status == LessonStatus.current ? 20 : 12,
                spreadRadius:
                    widget.lesson.status == LessonStatus.current ? 2 : 0,
              ),
            ],
            border: Border.all(
              color: _getBorderColor(),
              width: 3,
            ),
          ),
          child: Center(
            child: _getNodeContent(),
          ),
        ),
      );

  LinearGradient? _getGradient() {
    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return const LinearGradient(
          colors: [AppColors.success, AppColors.successDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LessonStatus.current:
        return AppColors.primaryGradient;
      case LessonStatus.locked:
        return null;
    }
  }

  Color _getGlowColor() {
    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return AppColors.completedGlow.withValues(alpha: 0.4);
      case LessonStatus.current:
        return AppColors.currentGlow.withValues(alpha: 0.5);
      case LessonStatus.locked:
        return AppColors.lockedGlow.withValues(alpha: 0.2);
    }
  }

  Color _getBorderColor() {
    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return AppColors.successLight;
      case LessonStatus.current:
        return AppColors.primaryLight;
      case LessonStatus.locked:
        return AppColors.locked;
    }
  }

  Widget _getNodeContent() {
    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return const Icon(
          Icons.check_rounded,
          color: AppColors.textPrimary,
          size: 28,
        );
      case LessonStatus.current:
        return Text(
          '${widget.lesson.position}',
          style: AppTypography.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        );
      case LessonStatus.locked:
        return const Icon(
          Icons.lock_rounded,
          color: AppColors.lockedLight,
          size: 24,
        );
    }
  }

  Widget _buildLessonInfo() {
    final isLocked = widget.lesson.status == LessonStatus.locked;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.lesson.title,
            style: AppTypography.titleLarge.copyWith(
              color: isLocked ? AppColors.textMuted : AppColors.textPrimary,
            ),
          ),
          AppSpacing.verticalGapXS,
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.bolt_rounded,
                label: '${widget.lesson.xp} XP',
                color: AppColors.warning,
              ),
              AppSpacing.horizontalGapSM,
              _buildInfoChip(
                icon: Icons.schedule_rounded,
                label: '${widget.lesson.estimatedMinutes} min',
                color: AppColors.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSM),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            AppSpacing.horizontalGapXS,
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(color: color),
            ),
          ],
        ),
      );

  Widget _buildConnector() => Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Container(
          width: 4,
          height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getConnectorColor(),
                _getConnectorColor().withValues(alpha: 0.3),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );

  Color _getConnectorColor() {
    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return AppColors.success;
      case LessonStatus.current:
        return AppColors.primary;
      case LessonStatus.locked:
        return AppColors.locked;
    }
  }
}
