import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/core/services/audio_service.dart';
import 'package:mini_fluency/data/data.dart';
import 'package:mini_fluency/models/models.dart';
import 'package:mini_fluency/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TasksScreen extends StatefulWidget {
  final String lessonId;

  const TasksScreen({
    super.key,
    required this.lessonId,
  });

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  bool _showCelebration = false;
  LessonModel? _previousLessonState;
  final _audioService = AudioService();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _checkCompletion(PathProvider provider, LessonModel lesson) {
    final completedCount = provider.getCompletedTasksCount(widget.lessonId);
    final totalCount = provider.getTotalTasksCount(widget.lessonId);
    final isCompleted = completedCount == totalCount && totalCount > 0;

    if (!isCompleted) {
      _showCelebration = false;
      return;
    }

    if (_showCelebration) return;

    final wasCompleted = _previousLessonState?.status == LessonStatus.completed;
    if (wasCompleted) return;

    setState(() => _showCelebration = true);
    _audioService.playLessonCompleted();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: SafeArea(
            child: Consumer<PathProvider>(
              builder: (context, provider, child) {
                final lesson = provider.getLessonById(widget.lessonId);
                if (lesson == null) {
                  return _buildNotFound();
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _checkCompletion(provider, lesson);
                  _previousLessonState = lesson;
                });

                return Stack(
                  children: [
                    _buildContent(provider, lesson),
                    if (_showCelebration)
                      CompletionCelebration(
                        onComplete: () {
                          setState(() => _showCelebration = false);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );

  Widget _buildNotFound() => Center(
        child: Text(
          'Lição não encontrada',
          style:
              AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
        ),
      );

  Widget _buildContent(PathProvider provider, LessonModel lesson) {
    final completedCount = provider.getCompletedTasksCount(widget.lessonId);
    final totalCount = provider.getTotalTasksCount(widget.lessonId);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(lesson)),
          SliverToBoxAdapter(
            child: Padding(
              padding: AppSpacing.horizontalXL,
              child: TaskProgressIndicator(
                completed: completedCount,
                total: totalCount,
              ),
            ),
          ),
          SliverToBoxAdapter(child: AppSpacing.verticalGapLG),
          SliverPadding(
            padding: AppSpacing.horizontalXL,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final task = lesson.tasks[index];
                  final isCurrentlyCompleted = provider.isTaskCompleted(task.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 80)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) => Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 15 * (1 - value)),
                          child: child,
                        ),
                      ),
                      child: TaskCard(
                        task: task,
                        isCompleted: isCurrentlyCompleted,
                        onToggle: () {
                          provider.toggleTaskCompletion(
                            widget.lessonId,
                            task.id,
                          );
                        },
                      ),
                    ),
                  );
                },
                childCount: lesson.tasks.length,
              ),
            ),
          ),
          SliverToBoxAdapter(child: AppSpacing.verticalGapXXL),
        ],
      ),
    );
  }

  Widget _buildHeader(LessonModel lesson) => Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildBackButton(),
                AppSpacing.horizontalGapMD,
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
                      AppSpacing.verticalGapXS,
                      Text(
                        lesson.title,
                        style: AppTypography.headlineMedium,
                      ),
                    ],
                  ),
                ),
                _buildXpBadge(lesson.xp),
              ],
            ),
            AppSpacing.verticalGapLG,
          ],
        ),
      );

  Widget _buildBackButton() => GestureDetector(
        onTap: () => ButtonTapHandler.handleTap(
          () => Navigator.of(context).pop(),
        ),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMD),
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary,
            size: 20,
          ),
        ),
      );

  Widget _buildXpBadge(int xp) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.warning.withValues(alpha: 0.2),
              AppColors.warning.withValues(alpha: 0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusFull),
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.bolt_rounded,
              color: AppColors.warning,
              size: 18,
            ),
            AppSpacing.horizontalGapXS,
            Text(
              '$xp XP',
              style: AppTypography.labelLarge.copyWith(
                color: AppColors.warning,
              ),
            ),
          ],
        ),
      );
}
