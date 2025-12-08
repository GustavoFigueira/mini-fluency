import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/core/services/audio_service.dart';
import 'package:mini_fluency/data/data.dart';
import 'package:mini_fluency/models/models.dart';
import 'package:mini_fluency/screens/settings_screen.dart';
import 'package:mini_fluency/screens/tasks_screen.dart';
import 'package:mini_fluency/widgets/lesson_transition.dart';
import 'package:mini_fluency/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PathScreen extends StatefulWidget {
  const PathScreen({super.key});

  @override
  State<PathScreen> createState() => _PathScreenState();
}

class _PathScreenState extends State<PathScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late ScrollController _scrollController;
  final _audioService = AudioService();
  Map<String, LessonStatus> _previousLessonStatuses = {};
  bool _hasPlayedIntro = false;

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
    _scrollController = ScrollController();
    _audioService.initialize();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PathProvider>().loadPath();
      if (!_hasPlayedIntro) {
        _audioService.playIntro();
        _hasPlayedIntro = true;
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _showLessonDetails(LessonModel lesson) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LessonDetailsSheet(
        lesson: lesson,
        onStart: lesson.isAccessible
            ? () {
                Navigator.of(context).pop();
                _navigateToTasks(lesson);
              }
            : null,
      ),
    );
  }

  void _showSoundPreferences() {
    ButtonTapHandler.handleTap(() {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const SoundPreferencesSheet(),
      );
    });
  }

  void _navigateToSettings() {
    ButtonTapHandler.handleTap(() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        ),
      );
    });
  }

  void _navigateToTasks(LessonModel lesson) {
    Navigator.of(context)
        .push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            TasksScreen(lessonId: lesson.id),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    )
        .then((_) {
      _updatePreviousStatuses();
    });
  }

  void _updatePreviousStatuses() {
    final provider = context.read<PathProvider>();
    final path = provider.path;
    if (path == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _previousLessonStatuses = {
          for (final lesson in path.lessons) lesson.id: lesson.status,
        };
      });
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.backgroundGradient,
        ),
        child: SafeArea(
          child: Consumer<PathProvider>(
            builder: (context, provider, child) => _buildContent(provider),
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
    final lessons = path.lessons;
    final reversedLessons = lessons.reversed.toList();

    if (_previousLessonStatuses.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final currentPath = context.read<PathProvider>().path;
        if (currentPath == null) return;
        setState(() {
          _previousLessonStatuses = {
            for (final lesson in currentPath.lessons) lesson.id: lesson.status,
          };
        });
        _scrollToBottom();
      });
    }

    return Stack(
      children: [
        _buildBackgroundDecorations(),
        _buildLessonsPath(reversedLessons, provider),
        _buildHeader(path.name, path.description),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Center(
            child: _buildBottomIcon(),
          ),
        ),
      ],
    );
  }

  Widget _buildBackgroundDecorations() {
    final colors = context.themeColors;

    return Positioned.fill(
      child: CustomPaint(
        painter: StarsPainter(isDark: colors.isDark),
      ),
    );
  }

  Widget _buildHeader(String title, String description) {
    final colors = context.themeColors;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.backgroundGradient.colors.first,
                colors.backgroundGradient.colors.first.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colors.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Trilha de Aprendizado',
                          style: AppTypography.labelSmall.copyWith(
                            color: colors.primaryLight,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title,
                          style: AppTypography.titleLarge.copyWith(
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildHeaderAction(
                  Icons.settings_outlined,
                  _navigateToSettings,
                ),
                const SizedBox(width: 8),
                _buildHeaderAction(
                  Icons.volume_up_outlined,
                  _showSoundPreferences,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderAction(IconData icon, VoidCallback onTap) {
    final colors = context.themeColors;

    return GestureDetector(
      onTap: () => ButtonTapHandler.handleTap(onTap),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: colors.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.primary.withValues(alpha: 0.4),
          ),
        ),
        child: Icon(
          icon,
          color: colors.primaryLight,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildLessonsPath(
    List<LessonModel> reversedLessons,
    PathProvider provider,
  ) =>
      ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(
          top: 100,
          bottom: 120,
          left: 20,
          right: 20,
        ),
        physics: const BouncingScrollPhysics(),
        itemCount: reversedLessons.length,
        itemBuilder: (context, index) {
          final lesson = reversedLessons[index];
          final isEven = index.isEven;
          final previousStatus = _previousLessonStatuses[lesson.id];

          return TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 400 + (index * 50)),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            ),
            child: LessonTransition(
              previousLesson: LessonModel(
                id: lesson.id,
                title: lesson.title,
                position: lesson.position,
                status: previousStatus ?? lesson.status,
                xp: lesson.xp,
                estimatedMinutes: lesson.estimatedMinutes,
                tasks: lesson.tasks,
              ),
              currentLesson: lesson,
              child: _buildLessonNode(
                lesson: lesson,
                isEven: isEven,
                showConnector: index < reversedLessons.length - 1,
                nextIsEven: (index + 1).isEven,
              ),
            ),
          );
        },
      );

  Widget _buildLessonNode({
    required LessonModel lesson,
    required bool isEven,
    required bool showConnector,
    required bool nextIsEven,
  }) {
    final alignment = isEven ? Alignment.centerRight : Alignment.centerLeft;
    final horizontalPadding = isEven
        ? const EdgeInsets.only(right: 40, left: 100)
        : const EdgeInsets.only(left: 40, right: 100);

    return Column(
      children: [
        Padding(
          padding: horizontalPadding,
          child: Align(
            alignment: alignment,
            child: LessonNode(
              lesson: lesson,
              onTap: () => ButtonTapHandler.handleTap(
                () => _showLessonDetails(lesson),
              ),
              showConnector: false,
              verticalLayout: true,
            ),
          ),
        ),
        if (showConnector)
          CustomPaint(
            size: const Size(double.infinity, 60),
            painter: PathConnectorPainter(
              fromRight: isEven,
              toRight: nextIsEven,
              color: _getConnectorColor(lesson.status),
            ),
          ),
      ],
    );
  }

  Color _getConnectorColor(LessonStatus status) {
    final colors = context.themeColors;

    switch (status) {
      case LessonStatus.completed:
        return colors.success.withValues(alpha: 0.6);
      case LessonStatus.current:
        return colors.primary.withValues(alpha: 0.6);
      case LessonStatus.locked:
        return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Widget _buildBottomIcon() {
    final colors = context.themeColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: colors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.school_rounded,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class PathConnectorPainter extends CustomPainter {
  final bool fromRight;
  final bool toRight;
  final Color color;

  PathConnectorPainter({
    required this.fromRight,
    required this.toRight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    const nodeWidth = 80.0;
    const margin = 14.0;
    final centerX = size.width / 2;

    final startX = fromRight
        ? centerX + (nodeWidth / 2) + margin
        : centerX - (nodeWidth / 2) - margin;
    final endX = toRight
        ? centerX + (nodeWidth / 2) + margin
        : centerX - (nodeWidth / 2) - margin;

    path
      ..moveTo(startX, margin)
      ..quadraticBezierTo(
        centerX,
        size.height / 2,
        endX,
        size.height - margin,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant PathConnectorPainter oldDelegate) =>
      oldDelegate.fromRight != fromRight ||
      oldDelegate.toRight != toRight ||
      oldDelegate.color != color;
}

class StarsPainter extends CustomPainter {
  final bool isDark;

  StarsPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final starColor = isDark
        ? Colors.white.withValues(alpha: 0.3)
        : const Color(0xFF6366F1).withValues(alpha: 0.4);

    final paint = Paint()..color = starColor;

    final stars = [
      Offset(size.width * 0.1, size.height * 0.15),
      Offset(size.width * 0.85, size.height * 0.1),
      Offset(size.width * 0.2, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.3),
      Offset(size.width * 0.15, size.height * 0.55),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width * 0.1, size.height * 0.75),
      Offset(size.width * 0.95, size.height * 0.7),
      Offset(size.width * 0.25, size.height * 0.9),
      Offset(size.width * 0.75, size.height * 0.85),
    ];

    for (final star in stars) {
      canvas.drawCircle(star, 2, paint);
    }

    paint.color = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : const Color(0xFF6366F1).withValues(alpha: 0.25);
    for (var i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.05 + 0.02)) % size.width;
      final y = (size.height * (i * 0.07 + 0.03)) % size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant StarsPainter oldDelegate) =>
      oldDelegate.isDark != isDark;
}
