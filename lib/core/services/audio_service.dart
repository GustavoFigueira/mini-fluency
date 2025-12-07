import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isEnabled = true;

  bool get isPlaying => _isPlaying;
  bool get isEnabled => _isEnabled;

  Future<void> playBackgroundMusic() async {
    if (!_isEnabled) return;
    if (_isPlaying) return;

    try {
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.play(
        AssetSource('audio/background_music.mp3'),
      );
      _isPlaying = true;
    } catch (e) {
      debugPrint('Error playing background music: $e');
      debugPrint('Note: Add background_music.mp3 to assets/audio/ folder');
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (!_isPlaying) return;

    try {
      await _backgroundPlayer.stop();
      _isPlaying = false;
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }

  Future<void> toggleBackgroundMusic() async {
    if (_isPlaying) {
      await stopBackgroundMusic();
      return;
    }
    await playBackgroundMusic();
  }

  Future<void> setEnabled({required bool enabled}) async {
    _isEnabled = enabled;
    if (!enabled) {
      await stopBackgroundMusic();
      return;
    }
    await playBackgroundMusic();
  }

  Future<void> dispose() async {
    await _backgroundPlayer.dispose();
  }
}
