import 'package:flutter/foundation.dart';

import '../../models/models.dart';
import '../repositories/repositories.dart';

/// State of the path data loading process
enum PathState { initial, loading, loaded, error }

/// Provider for managing the learning path state
class PathProvider extends ChangeNotifier {
  final PathRepository _repository;

  PathState _state = PathState.initial;
  PathModel? _path;
  String _errorMessage = '';
  final Map<String, bool> _taskCompletionState = {};

  PathProvider({PathRepository? repository})
      : _repository = repository ?? PathRepository();

  PathState get state => _state;
  PathModel? get path => _path;
  String get errorMessage => _errorMessage;

  Future<void> loadPath() async {
    _state = PathState.loading;
    notifyListeners();

    try {
      _path = await _repository.loadPath();
      _initializeTaskCompletionState();
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

  void toggleTaskCompletion(String lessonId, String taskId) {
    final currentState = _taskCompletionState[taskId] ?? false;
    _taskCompletionState[taskId] = !currentState;
    notifyListeners();
  }

  bool isTaskCompleted(String taskId) {
    return _taskCompletionState[taskId] ?? false;
  }

  LessonModel? getLessonById(String lessonId) {
    return _path?.lessons.firstWhere(
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
