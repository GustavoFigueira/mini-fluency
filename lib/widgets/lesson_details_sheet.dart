import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/data/data.dart';
import 'package:mini_fluency/models/models.dart';
import 'package:provider/provider.dart';

class LessonDetailsSheet extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback? onStart;

  const LessonDetailsSheet({
    super.key,
    required this.lesson,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;
    final modalColors = AppThemeColors(
      colors.isDark ? AppThemeMode.light : AppThemeMode.dark,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: modalColors.modalBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(modalColors),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(colors, modalColors),
                  const SizedBox(height: 24),
                  _buildInfo(colors),
                  if (!lesson.isAccessible) ...[
                    const SizedBox(height: 16),
                    _buildLockedMessage(modalColors),
                  ],
                  const SizedBox(height: 24),
                  _buildTasksPreview(modalColors),
                  const SizedBox(height: 24),
                  _buildStartButton(context, colors, modalColors),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(AppThemeColors modalColors) => Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: modalColors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildHeader(AppThemeColors colors, AppThemeColors modalColors) => Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _getGradient(colors),
              color: lesson.status == LessonStatus.locked
                  ? modalColors.modalBackground.withValues(alpha: 0.2)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: _getGlowColor(colors),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: _getIcon(modalColors),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lição ${lesson.position}',
                  style: AppTypography.labelMedium.copyWith(
                    color: colors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: modalColors.modalTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildInfo(AppThemeColors colors) => Row(
        children: [
          _buildInfoChip(
            icon: Icons.bolt_rounded,
            label: '${lesson.xp} XP',
            color: colors.warning,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            icon: Icons.schedule_rounded,
            label: '${lesson.estimatedMinutes} min',
            color: colors.secondary,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            icon: Icons.assignment_rounded,
            label: '${lesson.tasks.length} tarefas',
            color: colors.primary,
          ),
        ],
      );

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelMedium.copyWith(color: color),
            ),
          ],
        ),
      );

  Widget _buildLockedMessage(AppThemeColors modalColors) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.orange.shade200,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.lock_rounded,
              color: Colors.orange.shade700,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Finalize a atividade anterior para desbloquear esta lição.',
                style: AppTypography.bodyMedium.copyWith(
                  color: Colors.orange.shade900,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildTasksPreview(AppThemeColors modalColors) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarefas',
            style: AppTypography.titleMedium.copyWith(
              color: modalColors.modalTextPrimary,
            ),
          ),
          const SizedBox(height: 12),
          ...lesson.tasks.take(3).map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(
                        _getTaskIcon(task.type),
                        size: 20,
                        color: modalColors.modalTextSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: AppTypography.bodyMedium.copyWith(
                            color: modalColors.modalTextPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          if (lesson.tasks.length > 3)
            Text(
              'e mais ${lesson.tasks.length - 3} tarefa(s)...',
              style: AppTypography.bodySmall.copyWith(
                color: modalColors.modalTextSecondary,
              ),
            ),
        ],
      );

  Widget _buildStartButton(
    BuildContext context,
    AppThemeColors colors,
    AppThemeColors modalColors,
  ) {
    final provider = context.read<PathProvider>();
    final completedCount = provider.getCompletedTasksCount(lesson.id);
    final hasStarted = completedCount > 0;
    final buttonText = lesson.isAccessible
        ? (hasStarted ? 'Retomar Lição' : 'Iniciar Lição')
        : 'Bloqueada';

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: lesson.isAccessible
            ? () => ButtonTapHandler.handleTap(onStart)
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: lesson.isAccessible
              ? colors.primary
              : modalColors.isDark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
          foregroundColor: lesson.isAccessible
              ? Colors.white
              : modalColors.isDark
                  ? Colors.grey.shade900
                  : Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor:
              modalColors.isDark ? Colors.grey.shade300 : Colors.grey.shade700,
          disabledForegroundColor:
              modalColors.isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        ),
        child: Text(
          buttonText,
          style: AppTypography.titleMedium.copyWith(
            color: lesson.isAccessible
                ? Colors.white
                : modalColors.isDark
                    ? Colors.grey.shade900
                    : Colors.grey.shade200,
          ),
        ),
      ),
    );
  }

  LinearGradient? _getGradient(AppThemeColors colors) {
    switch (lesson.status) {
      case LessonStatus.completed:
        return LinearGradient(
          colors: [colors.success, colors.successDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case LessonStatus.current:
        return colors.primaryGradient;
      case LessonStatus.locked:
        return null;
    }
  }

  Color _getGlowColor(AppThemeColors colors) {
    switch (lesson.status) {
      case LessonStatus.completed:
        return colors.completedGlow.withValues(alpha: 0.4);
      case LessonStatus.current:
        return colors.currentGlow.withValues(alpha: 0.5);
      case LessonStatus.locked:
        return colors.lockedGlow.withValues(alpha: 0.2);
    }
  }

  Widget _getIcon(AppThemeColors modalColors) {
    switch (lesson.status) {
      case LessonStatus.completed:
        return const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 32,
        );
      case LessonStatus.current:
        return Text(
          '${lesson.position}',
          style: AppTypography.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        );
      case LessonStatus.locked:
        return Icon(
          Icons.lock_rounded,
          color: modalColors.modalTextPrimary,
          size: 32,
        );
    }
  }

  IconData _getTaskIcon(TaskType type) {
    switch (type) {
      case TaskType.listenRepeat:
        return Icons.headphones_rounded;
      case TaskType.multipleChoice:
        return Icons.quiz_rounded;
      case TaskType.fillInTheBlanks:
        return Icons.edit_rounded;
      case TaskType.ordering:
        return Icons.sort_rounded;
      case TaskType.rolePlay:
        return Icons.people_rounded;
    }
  }
}
