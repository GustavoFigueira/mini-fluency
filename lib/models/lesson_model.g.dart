// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LessonModelImpl _$$LessonModelImplFromJson(Map<String, dynamic> json) =>
    _$LessonModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      position: (json['position'] as num).toInt(),
      status: $enumDecode(_$LessonStatusEnumMap, json['status']),
      xp: (json['xp'] as num).toInt(),
      estimatedMinutes: (json['estimatedMinutes'] as num).toInt(),
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => TaskModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LessonModelImplToJson(_$LessonModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'position': instance.position,
      'status': _$LessonStatusEnumMap[instance.status]!,
      'xp': instance.xp,
      'estimatedMinutes': instance.estimatedMinutes,
      'tasks': instance.tasks,
    };

const _$LessonStatusEnumMap = {
  LessonStatus.completed: 'completed',
  LessonStatus.current: 'current',
  LessonStatus.locked: 'locked',
};
