import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';

class LessonDetailsSheet extends StatelessWidget {
  final LessonModel lesson;
  final VoidCallback? onStart;

  const LessonDetailsSheet({
    super.key,
    required this.lesson,
    this.onStart,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildInfo(),
                    if (!lesson.isAccessible) ...[
                      const SizedBox(height: 16),
                      _buildLockedMessage(),
                    ],
                    const SizedBox(height: 24),
                    _buildTasksPreview(),
                    const SizedBox(height: 24),
                    _buildStartButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildHandle() => Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildHeader() => Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _getGradient(),
              color: lesson.status == LessonStatus.locked
                  ? Colors.grey.shade200
                  : null,
              boxShadow: [
                BoxShadow(
                  color: _getGlowColor(),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: _getIcon(),
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
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  lesson.title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildInfo() => Row(
        children: [
          _buildInfoChip(
            icon: Icons.bolt_rounded,
            label: '${lesson.xp} XP',
            color: AppColors.warning,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            icon: Icons.schedule_rounded,
            label: '${lesson.estimatedMinutes} min',
            color: AppColors.secondary,
          ),
          const SizedBox(width: 12),
          _buildInfoChip(
            icon: Icons.assignment_rounded,
            label: '${lesson.tasks.length} tarefas',
            color: AppColors.primary,
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

  Widget _buildTasksPreview() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarefas',
            style: AppTypography.titleMedium.copyWith(
              color: Colors.black,
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
                        color: Colors.grey.shade700,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          task.title,
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.black87,
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
                color: Colors.grey.shade600,
              ),
            ),
        ],
      );

  Widget _buildLockedMessage() => Container(
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

  Widget _buildStartButton(BuildContext context) => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: lesson.isAccessible
              ? () => ButtonTapHandler.handleTap(onStart)
              : null,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: lesson.isAccessible
                ? AppColors.primary
                : Colors.grey.shade300,
            foregroundColor: lesson.isAccessible
                ? Colors.white
                : Colors.grey.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            disabledBackgroundColor: Colors.grey.shade300,
            disabledForegroundColor: Colors.grey.shade600,
          ),
          child: Text(
            lesson.isAccessible ? 'Iniciar Lição' : 'Bloqueada',
            style: AppTypography.titleMedium.copyWith(
              color: lesson.isAccessible
                  ? Colors.white
                  : Colors.grey.shade600,
            ),
          ),
        ),
      );

  LinearGradient? _getGradient() {
    switch (lesson.status) {
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
    switch (lesson.status) {
      case LessonStatus.completed:
        return AppColors.completedGlow.withValues(alpha: 0.4);
      case LessonStatus.current:
        return AppColors.currentGlow.withValues(alpha: 0.5);
      case LessonStatus.locked:
        return AppColors.lockedGlow.withValues(alpha: 0.2);
    }
  }

  Widget _getIcon() {
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
          color: Colors.grey.shade500,
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
