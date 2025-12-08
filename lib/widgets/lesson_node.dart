import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';

class LessonNode extends StatefulWidget {
  final LessonModel lesson;
  final VoidCallback? onTap;
  final bool showConnector;
  final bool verticalLayout;

  const LessonNode({
    super.key,
    required this.lesson,
    this.onTap,
    this.showConnector = true,
    this.verticalLayout = false,
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

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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
  Widget build(BuildContext context) {
    if (widget.verticalLayout) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => ButtonTapHandler.handleTap(widget.onTap),
            child: _buildNodeCircle(vertical: true),
          ),
          const SizedBox(height: 12),
          _buildLessonInfo(vertical: true),
          if (widget.showConnector) _buildConnector(),
        ],
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => ButtonTapHandler.handleTap(widget.onTap),
          child: Row(
            children: [
              _buildNodeCircle(vertical: false),
              AppSpacing.horizontalGapLG,
              Expanded(child: _buildLessonInfo(vertical: false)),
            ],
          ),
        ),
        if (widget.showConnector) _buildConnector(),
      ],
    );
  }

  Widget _buildNodeCircle({required bool vertical}) => AnimatedBuilder(
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
        child: Builder(
          builder: (context) {
            final colors = context.themeColors;
            return Container(
              width: vertical ? 64 : 56,
              height: vertical ? 64 : 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _getGradient(),
                boxShadow: colors.isDark
                    ? [
                        BoxShadow(
                          color: _getGlowColor(),
                          blurRadius:
                              widget.lesson.status == LessonStatus.current
                                  ? 20
                                  : 12,
                          spreadRadius:
                              widget.lesson.status == LessonStatus.current
                                  ? 2
                                  : 0,
                        ),
                      ]
                    : null,
                border: Border.all(
                  color: _getBorderColor(),
                  width: 3,
                ),
              ),
              child: Center(
                child: _getNodeContent(vertical: vertical),
              ),
            );
          },
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
    final colors = context.themeColors;
    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return AppColors.successLight;
      case LessonStatus.current:
        return AppColors.primaryLight;
      case LessonStatus.locked:
        return colors.lockedLight;
    }
  }

  Widget _getNodeContent({required bool vertical}) {
    final isFirstLesson = widget.lesson.position == 1;

    switch (widget.lesson.status) {
      case LessonStatus.completed:
        return Icon(
          Icons.check_rounded,
          color: vertical ? Colors.white : AppColors.textPrimary,
          size: vertical ? 36 : 28,
        );
      case LessonStatus.current:
        if (isFirstLesson && vertical) {
          return Icon(
            Icons.school_rounded,
            color: Colors.white,
            size: 40,
          );
        }
        return Text(
          '${widget.lesson.position}',
          style: AppTypography.headlineMedium.copyWith(
            color: vertical ? Colors.white : AppColors.textPrimary,
            fontWeight: vertical ? FontWeight.bold : FontWeight.normal,
          ),
        );
      case LessonStatus.locked:
        return Icon(
          Icons.lock_rounded,
          color: vertical ? Colors.grey.shade500 : AppColors.lockedLight,
          size: vertical ? 36 : 24,
        );
    }
  }

  Widget _buildLessonInfo({required bool vertical}) {
    final isLocked = widget.lesson.status == LessonStatus.locked;
    final colors = context.themeColors;

    return Opacity(
      opacity: isLocked ? 0.5 : 1.0,
      child: Column(
        crossAxisAlignment:
            vertical ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.lesson.title,
            style: AppTypography.titleMedium.copyWith(
              color: isLocked
                  ? colors.textMuted
                  : colors.isDark
                      ? colors.textPrimary
                      : const Color(0xFF4A2C5A),
            ),
            textAlign: vertical ? TextAlign.center : null,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildInfoChip(
                icon: Icons.bolt_rounded,
                label: '${widget.lesson.xp} XP',
                color: colors.warning,
              ),
              const SizedBox(width: 8),
              _buildInfoChip(
                icon: Icons.schedule_rounded,
                label: '${widget.lesson.estimatedMinutes} min',
                color: colors.secondary,
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
