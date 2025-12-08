import 'package:flutter/material.dart';
import 'package:mini_fluency/core/services/audio_service.dart';

class ButtonTapHandler {
  static final _audioService = AudioService();

  static void handleTap(VoidCallback? callback) {
    if (callback == null) return;
    _audioService.playButtonTap().ignore();
    callback();
  }

  static void handleToggle(
    ValueChanged<bool>? onChanged, {
    required bool newValue,
  }) {
    if (onChanged == null) return;
    _audioService.playButtonTap().ignore();
    onChanged(newValue);
  }

  static void handleTapWithValue<T>(ValueChanged<T>? callback, T value) {
    if (callback == null) return;
    _audioService.playButtonTap().ignore();
    callback(value);
  }

  static VoidCallback wrap(VoidCallback? callback) {
    if (callback == null) return () {};
    return () => handleTap(callback);
  }

  static ValueChanged<T> wrapValue<T>(ValueChanged<T>? callback) {
    if (callback == null) return (_) {};
    return (value) => handleTapWithValue(callback, value);
  }
}
