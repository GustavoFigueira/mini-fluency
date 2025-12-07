// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$TaskTypeEnumMap, json['type']),
      estimatedSeconds: (json['estimatedSeconds'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': _$TaskTypeEnumMap[instance.type]!,
      'estimatedSeconds': instance.estimatedSeconds,
      'isCompleted': instance.isCompleted,
    };

const _$TaskTypeEnumMap = {
  TaskType.listenRepeat: 'listen_repeat',
  TaskType.multipleChoice: 'multiple_choice',
  TaskType.fillInTheBlanks: 'fill_in_the_blanks',
  TaskType.ordering: 'ordering',
  TaskType.rolePlay: 'role_play',
};
