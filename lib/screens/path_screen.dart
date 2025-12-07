import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/core.dart';
import '../data/data.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';
import 'tasks_screen.dart';

/// Main screen displaying the learning path with all lessons
class PathScreen extends StatefulWidget {
  const PathScreen({super.key});

  @override
  State<PathScreen> createState() => _PathScreenState();
}

class _PathScreenState extends State<PathScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PathProvider>().loadPath();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToTasks(LessonModel lesson) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TasksScreen(lessonId: lesson.id),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Consumer<PathProvider>(
            builder: (context, provider, child) {
              return _buildContent(provider);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PathProvider provider) {
    switch (provider.state) {
      case PathState.initial:
      case PathState.loading:
        return const LoadingScreen();
      case PathState.error:
        return ErrorScreen(
          message: provider.errorMessage,
          onRetry: () => provider.loadPath(),
        );
      case PathState.loaded:
        if (!_fadeController.isCompleted) {
          _fadeController.forward();
        }
        return FadeTransition(
          opacity: _fadeAnimation,
          child: _buildPathContent(provider),
        );
    }
  }

  Widget _buildPathContent(PathProvider provider) {
    final path = provider.path!;

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(path.name, path.description)),
        SliverToBoxAdapter(child: AppSpacing.verticalGapLG),
        SliverPadding(
          padding: AppSpacing.horizontalXL,
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final lesson = path.lessons[index];
                final isLast = index == path.lessons.length - 1;

                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: Duration(milliseconds: 400 + (index * 100)),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: LessonNode(
                    lesson: lesson,
                    showConnector: !isLast,
                    onTap: () => _navigateToTasks(lesson),
                  ),
                );
              },
              childCount: path.lessons.length,
            ),
          ),
        ),
        SliverToBoxAdapter(child: AppSpacing.verticalGapXXL),
      ],
    );
  }

  Widget _buildHeader(String title, String description) {
    return Padding(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius:
                      BorderRadius.circular(AppSpacing.borderRadiusMD),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.route_rounded,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
              ),
              AppSpacing.horizontalGapLG,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trilha de Aprendizado',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                    AppSpacing.verticalGapXS,
                    Text(
                      title,
                      style: AppTypography.headlineMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.verticalGapLG,
          Container(
            padding: AppSpacing.paddingLG,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.borderRadiusMD),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.secondary,
                  size: 20,
                ),
                AppSpacing.horizontalGapMD,
                Expanded(
                  child: Text(
                    description,
                    style: AppTypography.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
