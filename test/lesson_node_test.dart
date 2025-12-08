import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';
import 'package:mini_fluency/widgets/lesson_node.dart';
import 'package:provider/provider.dart';

void main() {
  group('LessonNode Widget', () {
    final task = TaskModel(
      id: 'task_1',
      title: 'Test Task',
      type: TaskType.listenRepeat,
      estimatedSeconds: 30,
    );

    final currentLesson = LessonModel(
      id: 'lesson_1',
      title: 'Current Lesson',
      position: 1,
      status: LessonStatus.current,
      xp: 10,
      estimatedMinutes: 5,
      tasks: [task],
    );

    final completedLesson = LessonModel(
      id: 'lesson_2',
      title: 'Completed Lesson',
      position: 2,
      status: LessonStatus.completed,
      xp: 15,
      estimatedMinutes: 7,
      tasks: [task],
    );

    final lockedLesson = LessonModel(
      id: 'lesson_3',
      title: 'Locked Lesson',
      position: 3,
      status: LessonStatus.locked,
      xp: 20,
      estimatedMinutes: 10,
      tasks: [task],
    );

    Widget createTestWidget(LessonModel lesson) => MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: Scaffold(
              body: LessonNode(
                lesson: lesson,
                verticalLayout: true,
              ),
            ),
          ),
        );

    testWidgets('should display current lesson correctly', (tester) async {
      await tester.pumpWidget(createTestWidget(currentLesson));
      await tester.pump();

      expect(find.text('Current Lesson'), findsOneWidget);
      expect(find.text('10 XP'), findsOneWidget);
      expect(find.text('5 min'), findsOneWidget);
    });

    testWidgets('should display completed lesson with check icon',
        (tester) async {
      await tester.pumpWidget(createTestWidget(completedLesson));
      await tester.pump();

      expect(find.text('Completed Lesson'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });

    testWidgets('should display locked lesson with lock icon', (tester) async {
      await tester.pumpWidget(createTestWidget(lockedLesson));
      await tester.pump();

      expect(find.text('Locked Lesson'), findsOneWidget);
      expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => ThemeProvider()),
            ],
            child: Scaffold(
              body: GestureDetector(
                onTap: () => tapped = true,
                child: LessonNode(
                  lesson: currentLesson,
                  verticalLayout: true,
                  onTap: () => tapped = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      final lessonNodeFinder = find.byType(LessonNode);
      expect(lessonNodeFinder, findsOneWidget);
      await tester.tap(lessonNodeFinder);
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('should display hat icon for first lesson when current',
        (tester) async {
      final firstLesson = LessonModel(
        id: 'lesson_1',
        title: 'First Lesson',
        position: 1,
        status: LessonStatus.current,
        xp: 10,
        estimatedMinutes: 5,
        tasks: [task],
      );

      await tester.pumpWidget(createTestWidget(firstLesson));
      await tester.pump();

      expect(find.byIcon(Icons.school_rounded), findsOneWidget);
    });

    testWidgets('should not display hat icon for non-first lesson',
        (tester) async {
      final secondLesson = currentLesson.copyWith(position: 2);

      await tester.pumpWidget(createTestWidget(secondLesson));
      await tester.pump();

      expect(find.byIcon(Icons.school_rounded), findsNothing);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
