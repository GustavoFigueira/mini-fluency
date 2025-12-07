import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/data/data.dart';
import 'package:mini_fluency/models/models.dart';
import 'package:mini_fluency/screens/tasks_screen.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PathProvider>().loadPath();
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _navigateToTasks(LessonModel lesson) {
    Navigator.of(context).push(
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
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1a1a3e),
                Color(0xFF2d1b4e),
                Color(0xFF1a1a3e),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Consumer<PathProvider>(
              builder: (context, provider, child) => _buildContent(provider),
            ),
          ),
        ),
      );

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

    return Stack(
      children: [
        _buildBackgroundDecorations(),
        Column(
          children: [
            _buildHeader(path.name, path.description),
            Expanded(
              child: _buildLessonsPath(reversedLessons),
            ),
            _buildBottomIcon(),
          ],
        ),
      ],
    );
  }

  Widget _buildBackgroundDecorations() => Positioned.fill(
        child: CustomPaint(
          painter: StarsPainter(),
        ),
      );

  Widget _buildHeader(String title, String description) => Padding(
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
                  color: AppColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Trilha de Aprendizado',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.primaryLight,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: AppTypography.titleLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildHeaderAction(Icons.settings_outlined),
            const SizedBox(width: 8),
            _buildHeaderAction(Icons.volume_up_outlined),
          ],
        ),
      );

  Widget _buildHeaderAction(IconData icon) => Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4),
          ),
        ),
        child: Icon(
          icon,
          color: AppColors.primaryLight,
          size: 22,
        ),
      );

  Widget _buildLessonsPath(List<LessonModel> reversedLessons) =>
      ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(vertical: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: reversedLessons.length,
        itemBuilder: (context, index) {
          final lesson = reversedLessons[index];
          final isEven = index.isEven;

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
            child: _buildLessonNode(
              lesson: lesson,
              isEven: isEven,
              showConnector: index < reversedLessons.length - 1,
              nextIsEven: (index + 1).isEven,
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
              onTap: () => _navigateToTasks(lesson),
              showConnector: false,
              verticalLayout: true,
            ),
          ),
        ),
        if (showConnector)
          CustomPaint(
            size: const Size(double.infinity, 40),
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
    switch (status) {
      case LessonStatus.completed:
        return AppColors.success.withValues(alpha: 0.6);
      case LessonStatus.current:
        return AppColors.primary.withValues(alpha: 0.6);
      case LessonStatus.locked:
        return Colors.grey.withValues(alpha: 0.3);
    }
  }

  Widget _buildBottomIcon() => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
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

    const nodeRadius = 40.0;
    final startX = fromRight ? size.width - nodeRadius : nodeRadius;
    final endX = toRight ? size.width - nodeRadius : nodeRadius;

    path
      ..moveTo(startX, 0)
      ..quadraticBezierTo(
        size.width / 2,
        size.height / 2,
        endX,
        size.height,
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
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.3);

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

    paint.color = Colors.white.withValues(alpha: 0.15);
    for (var i = 0; i < 20; i++) {
      final x = (size.width * (i * 0.05 + 0.02)) % size.width;
      final y = (size.height * (i * 0.07 + 0.03)) % size.height;
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
