import 'package:freezed_annotation/freezed_annotation.dart';
import 'lesson_model.dart';

part 'path_model.freezed.dart';
part 'path_model.g.dart';

/// Represents a learning path containing multiple lessons
@freezed
class PathModel with _$PathModel {
  const PathModel._();

  const factory PathModel({
    required String id,
    required String name,
    required String description,
    required List<LessonModel> lessons,
  }) = _PathModel;

  factory PathModel.fromJson(Map<String, dynamic> json) =>
      _$PathModelFromJson(json);

  int get totalXp => lessons.fold(0, (sum, lesson) => sum + lesson.xp);

  int get completedLessonsCount =>
      lessons.where((lesson) => lesson.status == LessonStatus.completed).length;

  double get progressPercentage {
    if (lessons.isEmpty) return 0;
    return completedLessonsCount / lessons.length;
  }
}
