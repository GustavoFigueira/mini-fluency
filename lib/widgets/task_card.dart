import 'package:flutter/material.dart';

import '../core/core.dart';
import '../models/models.dart';

/// Card widget displaying a single task with completion toggle
class TaskCard extends StatefulWidget {
  final TaskModel task;
  final bool isCompleted;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.task,
    required this.isCompleted,
    required this.onToggle,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _checkController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    if (widget.isCompleted) {
      _checkController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TaskCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted != oldWidget.isCompleted) {
      if (widget.isCompleted) {
        _checkController.forward();
      } else {
        _checkController.reverse();
      }
    }
  }

  void _handleTap() {
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: AppSpacing.paddingLG,
          decoration: BoxDecoration(
            gradient: widget.isCompleted
                ? LinearGradient(
                    colors: [
                      AppColors.success.withValues(alpha: 0.15),
                      AppColors.success.withValues(alpha: 0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : AppColors.cardGradient,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMD),
            border: Border.all(
              color: widget.isCompleted
                  ? AppColors.success.withValues(alpha: 0.4)
                  : AppColors.border,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              _buildCheckbox(),
              AppSpacing.horizontalGapLG,
              Expanded(child: _buildTaskInfo()),
              _buildTypeIcon(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return AnimatedBuilder(
      animation: _checkAnimation,
      builder: (context, child) {
        return Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isCompleted ? AppColors.success : Colors.transparent,
            border: Border.all(
              color: widget.isCompleted ? AppColors.success : AppColors.border,
              width: 2,
            ),
            boxShadow: widget.isCompleted
                ? [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: widget.isCompleted
              ? Transform.scale(
                  scale: _checkAnimation.value,
                  child: const Icon(
                    Icons.check_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildTaskInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.task.title,
          style: AppTypography.bodyLarge.copyWith(
            color: widget.isCompleted
                ? AppColors.textSecondary
                : AppColors.textPrimary,
            decoration: widget.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: AppColors.textMuted,
          ),
        ),
        AppSpacing.verticalGapXS,
        Row(
          children: [
            _buildMetaChip(
              icon: Icons.schedule_rounded,
              label: TimeFormatter.formatSeconds(widget.task.estimatedSeconds),
            ),
            AppSpacing.horizontalGapSM,
            _buildMetaChip(
              icon: _getTypeIcon(widget.task.type),
              label: widget.task.type.displayName,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetaChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: AppColors.textMuted,
        ),
        AppSpacing.horizontalGapXS,
        Text(
          label,
          style: AppTypography.caption,
        ),
      ],
    );
  }

  IconData _getTypeIcon(TaskType type) {
    switch (type) {
      case TaskType.listenRepeat:
        return Icons.headphones_rounded;
      case TaskType.multipleChoice:
        return Icons.list_rounded;
      case TaskType.fillInTheBlanks:
        return Icons.edit_rounded;
      case TaskType.ordering:
        return Icons.swap_vert_rounded;
      case TaskType.rolePlay:
        return Icons.chat_rounded;
    }
  }

  Widget _buildTypeIcon() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSM),
      ),
      child: Icon(
        _getTypeIcon(widget.task.type),
        size: 20,
        color: AppColors.primary,
      ),
    );
  }
}
