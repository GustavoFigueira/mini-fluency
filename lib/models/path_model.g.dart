// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'path_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PathModelImpl _$$PathModelImplFromJson(Map<String, dynamic> json) =>
    _$PathModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => LessonModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$PathModelImplToJson(_$PathModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'lessons': instance.lessons,
    };
