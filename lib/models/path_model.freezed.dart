// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'path_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PathModel _$PathModelFromJson(Map<String, dynamic> json) {
  return _PathModel.fromJson(json);
}

/// @nodoc
mixin _$PathModel {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  List<LessonModel> get lessons => throw _privateConstructorUsedError;

  /// Serializes this PathModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PathModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PathModelCopyWith<PathModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PathModelCopyWith<$Res> {
  factory $PathModelCopyWith(PathModel value, $Res Function(PathModel) then) =
      _$PathModelCopyWithImpl<$Res, PathModel>;
  @useResult
  $Res call(
      {String id, String name, String description, List<LessonModel> lessons});
}

/// @nodoc
class _$PathModelCopyWithImpl<$Res, $Val extends PathModel>
    implements $PathModelCopyWith<$Res> {
  _$PathModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PathModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? lessons = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lessons: null == lessons
          ? _value.lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PathModelImplCopyWith<$Res>
    implements $PathModelCopyWith<$Res> {
  factory _$$PathModelImplCopyWith(
          _$PathModelImpl value, $Res Function(_$PathModelImpl) then) =
      __$$PathModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id, String name, String description, List<LessonModel> lessons});
}

/// @nodoc
class __$$PathModelImplCopyWithImpl<$Res>
    extends _$PathModelCopyWithImpl<$Res, _$PathModelImpl>
    implements _$$PathModelImplCopyWith<$Res> {
  __$$PathModelImplCopyWithImpl(
      _$PathModelImpl _value, $Res Function(_$PathModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of PathModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? lessons = null,
  }) {
    return _then(_$PathModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      lessons: null == lessons
          ? _value._lessons
          : lessons // ignore: cast_nullable_to_non_nullable
              as List<LessonModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PathModelImpl extends _PathModel {
  const _$PathModelImpl(
      {required this.id,
      required this.name,
      required this.description,
      required final List<LessonModel> lessons})
      : _lessons = lessons,
        super._();

  factory _$PathModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PathModelImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  final List<LessonModel> _lessons;
  @override
  List<LessonModel> get lessons {
    if (_lessons is EqualUnmodifiableListView) return _lessons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_lessons);
  }

  @override
  String toString() {
    return 'PathModel(id: $id, name: $name, description: $description, lessons: $lessons)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PathModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._lessons, _lessons));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description,
      const DeepCollectionEquality().hash(_lessons));

  /// Create a copy of PathModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PathModelImplCopyWith<_$PathModelImpl> get copyWith =>
      __$$PathModelImplCopyWithImpl<_$PathModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PathModelImplToJson(
      this,
    );
  }
}

abstract class _PathModel extends PathModel {
  const factory _PathModel(
      {required final String id,
      required final String name,
      required final String description,
      required final List<LessonModel> lessons}) = _$PathModelImpl;
  const _PathModel._() : super._();

  factory _PathModel.fromJson(Map<String, dynamic> json) =
      _$PathModelImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  List<LessonModel> get lessons;

  /// Create a copy of PathModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PathModelImplCopyWith<_$PathModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
