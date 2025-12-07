import 'package:flutter/material.dart';

import '../core/core.dart';

/// Custom progress indicator showing completed tasks count
class TaskProgressIndicator extends StatelessWidget {
  final int completed;
  final int total;

  const TaskProgressIndicator({
    super.key,
    required this.completed,
    required this.total,
  });

  double get _progress => total > 0 ? completed / total : 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Progresso',
                style: AppTypography.labelMedium,
              ),
              Text(
                '$completed de $total tarefas',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapSM,
          _buildProgressBar(),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Container(
              height: 8,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              height: 8,
              width: constraints.maxWidth * _progress,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(4),
                boxShadow: _progress > 0
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }
}
