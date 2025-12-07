import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

/// Represents a single task within a lesson
@freezed
class TaskModel with _$TaskModel {
  const TaskModel._();

  const factory TaskModel({
    required String id,
    required String title,
    required TaskType type,
    required int estimatedSeconds,
    @Default(false) bool isCompleted,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
}

/// Types of tasks available in the learning path
@JsonEnum(valueField: 'value')
enum TaskType {
  @JsonValue('listen_repeat')
  listenRepeat('listen_repeat'),
  @JsonValue('multiple_choice')
  multipleChoice('multiple_choice'),
  @JsonValue('fill_in_the_blanks')
  fillInTheBlanks('fill_in_the_blanks'),
  @JsonValue('ordering')
  ordering('ordering'),
  @JsonValue('role_play')
  rolePlay('role_play');

  final String value;
  const TaskType(this.value);

  String get displayName {
    switch (this) {
      case TaskType.listenRepeat:
        return 'Ouvir e Repetir';
      case TaskType.multipleChoice:
        return 'Múltipla Escolha';
      case TaskType.fillInTheBlanks:
        return 'Completar';
      case TaskType.ordering:
        return 'Ordenar';
      case TaskType.rolePlay:
        return 'Role-Play';
    }
  }

  String get iconName {
    switch (this) {
      case TaskType.listenRepeat:
        return 'headphones';
      case TaskType.multipleChoice:
        return 'list';
      case TaskType.fillInTheBlanks:
        return 'edit';
      case TaskType.ordering:
        return 'sort';
      case TaskType.rolePlay:
        return 'chat';
    }
  }
}
