import 'package:flutter_test/flutter_test.dart';
import 'package:mini_fluency/data/providers/path_provider.dart';
import 'package:mini_fluency/data/repositories/path_repository.dart';
import 'package:mini_fluency/models/models.dart';

class MockPathRepository extends PathRepository {
  final PathModel mockPath;

  MockPathRepository(this.mockPath);

  @override
  Future<PathModel> loadPath() async => mockPath;
}

void main() {
  group('PathProvider', () {
    late PathProvider provider;
    late MockPathRepository mockRepository;

    final task1 = TaskModel(
      id: 'task_1',
      title: 'Task 1',
      type: TaskType.listenRepeat,
      estimatedSeconds: 30,
    );

    final task2 = TaskModel(
      id: 'task_2',
      title: 'Task 2',
      type: TaskType.multipleChoice,
      estimatedSeconds: 45,
    );

    final lesson1 = LessonModel(
      id: 'lesson_1',
      title: 'Lesson 1',
      position: 1,
      status: LessonStatus.current,
      xp: 10,
      estimatedMinutes: 5,
      tasks: [task1, task2],
    );

    final lesson2 = LessonModel(
      id: 'lesson_2',
      title: 'Lesson 2',
      position: 2,
      status: LessonStatus.locked,
      xp: 15,
      estimatedMinutes: 7,
      tasks: [
        TaskModel(
          id: 'task_3',
          title: 'Task 3',
          type: TaskType.fillInTheBlanks,
          estimatedSeconds: 60,
        ),
      ],
    );

    final mockPath = PathModel(
      id: 'path_1',
      name: 'Test Path',
      description: 'Test Description',
      lessons: [lesson1, lesson2],
    );

    setUp(() {
      mockRepository = MockPathRepository(mockPath);
      provider = PathProvider(repository: mockRepository);
    });

    test('should load path successfully', () async {
      await provider.loadPath();

      expect(provider.state, PathState.loaded);
      expect(provider.path, isNotNull);
      expect(provider.path!.lessons.length, 2);
    });

    group('Lesson accessibility', () {
      test('current lesson should be accessible', () async {
        await provider.loadPath();

        final lesson = provider.getLessonById('lesson_1');
        expect(lesson, isNotNull);
        expect(lesson!.isAccessible, isTrue);
        expect(lesson.status, LessonStatus.current);
      });

      test('locked lesson should not be accessible', () async {
        await provider.loadPath();

        final lesson = provider.getLessonById('lesson_2');
        expect(lesson, isNotNull);
        expect(lesson!.isAccessible, isFalse);
        expect(lesson.status, LessonStatus.locked);
      });
    });

    group('Task completion', () {
      test('should toggle task completion', () async {
        await provider.loadPath();

        expect(provider.isTaskCompleted('task_1'), isFalse);

        provider.toggleTaskCompletion('lesson_1', 'task_1');
        expect(provider.isTaskCompleted('task_1'), isTrue);

        provider.toggleTaskCompletion('lesson_1', 'task_1');
        expect(provider.isTaskCompleted('task_1'), isFalse);
      });

      test('should update completed tasks count', () async {
        await provider.loadPath();

        expect(provider.getCompletedTasksCount('lesson_1'), 0);
        expect(provider.getTotalTasksCount('lesson_1'), 2);

        provider.toggleTaskCompletion('lesson_1', 'task_1');
        expect(provider.getCompletedTasksCount('lesson_1'), 1);

        provider.toggleTaskCompletion('lesson_1', 'task_2');
        expect(provider.getCompletedTasksCount('lesson_1'), 2);
      });
    });

    group('Lesson completion', () {
      test('should mark lesson as completed when all tasks are done', () async {
        await provider.loadPath();

        final initialLesson = provider.getLessonById('lesson_1');
        expect(initialLesson!.status, LessonStatus.current);

        provider
          ..toggleTaskCompletion('lesson_1', 'task_1')
          ..toggleTaskCompletion('lesson_1', 'task_2');

        final updatedPath = provider.path;
        final completedLesson =
            updatedPath!.lessons.firstWhere((l) => l.id == 'lesson_1');

        expect(completedLesson.status, LessonStatus.completed);
        expect(provider.getCompletedTasksCount('lesson_1'), 2);
        expect(provider.getTotalTasksCount('lesson_1'), 2);
      });

      test('should unlock next lesson when previous is completed', () async {
        await provider.loadPath();

        final initialLesson2 = provider.getLessonById('lesson_2');
        expect(initialLesson2!.status, LessonStatus.locked);

        provider
          ..toggleTaskCompletion('lesson_1', 'task_1')
          ..toggleTaskCompletion('lesson_1', 'task_2');

        final updatedPath = provider.path;
        final unlockedLesson2 =
            updatedPath!.lessons.firstWhere((l) => l.id == 'lesson_2');

        expect(unlockedLesson2.status, LessonStatus.current);
        expect(unlockedLesson2.isAccessible, isTrue);
      });

      test('should not mark lesson as completed if tasks are incomplete',
          () async {
        await provider.loadPath();

        provider.toggleTaskCompletion('lesson_1', 'task_1');

        final updatedPath = provider.path;
        final lesson =
            updatedPath!.lessons.firstWhere((l) => l.id == 'lesson_1');

        expect(lesson.status, isNot(LessonStatus.completed));
        expect(provider.getCompletedTasksCount('lesson_1'), 1);
        expect(provider.getTotalTasksCount('lesson_1'), 2);
      });
    });
  });
}
