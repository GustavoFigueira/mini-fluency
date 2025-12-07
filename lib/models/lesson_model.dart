import 'package:freezed_annotation/freezed_annotation.dart';
import 'task_model.dart';

part 'lesson_model.freezed.dart';
part 'lesson_model.g.dart';

/// Represents a lesson in the learning path
@freezed
class LessonModel with _$LessonModel {
  const LessonModel._();

  const factory LessonModel({
    required String id,
    required String title,
    required int position,
    required LessonStatus status,
    required int xp,
    required int estimatedMinutes,
    required List<TaskModel> tasks,
  }) = _LessonModel;

  factory LessonModel.fromJson(Map<String, dynamic> json) =>
      _$LessonModelFromJson(json);

  int get completedTasksCount => tasks.where((task) => task.isCompleted).length;

  bool get isAccessible => status != LessonStatus.locked;
}

/// Status of a lesson in the learning path
@JsonEnum(valueField: 'value')
enum LessonStatus {
  @JsonValue('completed')
  completed('completed'),
  @JsonValue('current')
  current('current'),
  @JsonValue('locked')
  locked('locked');

  final String value;
  const LessonStatus(this.value);
}
