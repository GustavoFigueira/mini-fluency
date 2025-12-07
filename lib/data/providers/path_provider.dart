import 'package:flutter/foundation.dart';
import 'package:mini_fluency/data/repositories/repositories.dart';
import 'package:mini_fluency/models/models.dart';

enum PathState { initial, loading, loaded, error }

class PathProvider extends ChangeNotifier {
  final PathRepository _repository;

  PathState _state = PathState.initial;
  PathModel? _path;
  String _errorMessage = '';
  final Map<String, bool> _taskCompletionState = {};

  PathProvider({PathRepository? repository})
      : _repository = repository ?? PathRepository();

  PathState get state => _state;
  PathModel? get path => _getPathWithUpdatedStatus();
  String get errorMessage => _errorMessage;

  Future<void> loadPath() async {
    _state = PathState.loading;
    notifyListeners();

    try {
      _path = await _repository.loadPath();
      _initializeTaskCompletionState();
      _normalizeInitialStatuses();
      _state = PathState.loaded;
    } catch (e) {
      _state = PathState.error;
      _errorMessage =
          'Não foi possível carregar os dados. Por favor, tente novamente.';
    }

    notifyListeners();
  }

  void _initializeTaskCompletionState() {
    if (_path == null) return;

    for (final lesson in _path!.lessons) {
      for (final task in lesson.tasks) {
        _taskCompletionState[task.id] = task.isCompleted;
      }
    }
  }

  void _normalizeInitialStatuses() {
    if (_path == null) return;

    final updatedLessons = <LessonModel>[];

    for (var i = 0; i < _path!.lessons.length; i++) {
      final lesson = _path!.lessons[i];
      final allTasksCompleted = _areAllTasksCompleted(lesson);

      var updatedLesson = lesson;

      if (allTasksCompleted) {
        updatedLesson = lesson.copyWith(status: LessonStatus.completed);
        updatedLessons.add(updatedLesson);
        continue;
      }

      if (i == 0 ||
          (i > 0 && updatedLessons[i - 1].status == LessonStatus.completed)) {
        if (lesson.status == LessonStatus.locked) {
          updatedLesson = lesson.copyWith(status: LessonStatus.current);
        } else if (lesson.status == LessonStatus.completed) {
          updatedLesson = lesson.copyWith(status: LessonStatus.current);
        }
      }

      updatedLessons.add(updatedLesson);
    }

    _path = _path!.copyWith(lessons: updatedLessons);
  }

  void toggleTaskCompletion(String lessonId, String taskId) {
    final currentState = _taskCompletionState[taskId] ?? false;
    _taskCompletionState[taskId] = !currentState;
    notifyListeners();
  }

  bool _areAllTasksCompleted(LessonModel lesson) {
    if (lesson.tasks.isEmpty) return false;
    return lesson.tasks.every((task) => isTaskCompleted(task.id));
  }

  PathModel? _getPathWithUpdatedStatus() {
    if (_path == null) return null;

    final updatedLessons = <LessonModel>[];

    for (var i = 0; i < _path!.lessons.length; i++) {
      final lesson = _path!.lessons[i];
      final allTasksCompleted = _areAllTasksCompleted(lesson);

      var updatedLesson = lesson;

      if (allTasksCompleted) {
        if (lesson.status != LessonStatus.completed) {
          updatedLesson = lesson.copyWith(status: LessonStatus.completed);
        }
        updatedLessons.add(updatedLesson);
        continue;
      }

      if (lesson.status == LessonStatus.completed) {
        updatedLesson = lesson.copyWith(status: LessonStatus.current);
      }

      if (i > 0) {
        final previousLesson = updatedLessons[i - 1];
        if (previousLesson.status == LessonStatus.completed &&
            updatedLesson.status == LessonStatus.locked) {
          updatedLesson = updatedLesson.copyWith(status: LessonStatus.current);
        }
      }

      updatedLessons.add(updatedLesson);
    }

    return _path!.copyWith(lessons: updatedLessons);
  }

  bool isTaskCompleted(String taskId) => _taskCompletionState[taskId] ?? false;

  LessonModel? getLessonById(String lessonId) {
    final path = _getPathWithUpdatedStatus();
    return path?.lessons.firstWhere(
      (lesson) => lesson.id == lessonId,
      orElse: () => throw Exception('Lesson not found'),
    );
  }

  int getCompletedTasksCount(String lessonId) {
    final lesson = getLessonById(lessonId);
    if (lesson == null) return 0;
    return lesson.tasks.where((task) => isTaskCompleted(task.id)).length;
  }

  int getTotalTasksCount(String lessonId) {
    final lesson = getLessonById(lessonId);
    return lesson?.tasks.length ?? 0;
  }

  List<TaskModel> getTasksForLesson(String lessonId) {
    final lesson = getLessonById(lessonId);
    return lesson?.tasks ?? [];
  }
}
