import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;

  final AudioPlayer _backgroundPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  StreamSubscription<PlayerState>? _stateSubscription;
  bool _isMusicPlaying = false;
  bool _isMusicEnabled = true;
  bool _isSfxEnabled = true;
  bool _isVibrationEnabled = true;
  bool _isInitialized = false;

  AudioService._internal();

  bool get isPlaying => _isMusicPlaying;
  bool get isMusicEnabled => _isMusicEnabled;
  bool get isSfxEnabled => _isSfxEnabled;
  bool get isVibrationEnabled => _isVibrationEnabled;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _backgroundPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _sfxPlayer.setPlayerMode(PlayerMode.lowLatency);
      await _loadPreferences();

      _stateSubscription =
          _backgroundPlayer.onPlayerStateChanged.listen((state) {
        if (state == PlayerState.playing) {
          _isMusicPlaying = true;
        } else if (state == PlayerState.completed ||
            state == PlayerState.stopped) {
          _isMusicPlaying = false;
        }
      });

      if (_isMusicEnabled) {
        await Future.delayed(const Duration(milliseconds: 100));
        await playBackgroundMusic();
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('Error initializing audio service: $e');
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMusicEnabled = prefs.getBool('music_enabled') ?? true;
      _isSfxEnabled = prefs.getBool('sfx_enabled') ?? true;
      _isVibrationEnabled = prefs.getBool('vibration_enabled') ?? true;
    } catch (e) {
      debugPrint('Error loading audio preferences: $e');
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('music_enabled', _isMusicEnabled);
      await prefs.setBool('sfx_enabled', _isSfxEnabled);
      await prefs.setBool('vibration_enabled', _isVibrationEnabled);
    } catch (e) {
      debugPrint('Error saving audio preferences: $e');
    }
  }

  Future<void> setMusicEnabled({required bool enabled}) async {
    _isMusicEnabled = enabled;
    await _savePreferences();

    if (!enabled) {
      await stopBackgroundMusic();
      return;
    }
    await playBackgroundMusic();
  }

  Future<void> setSfxEnabled({required bool enabled}) async {
    _isSfxEnabled = enabled;
    await _savePreferences();
  }

  Future<void> setVibrationEnabled({required bool enabled}) async {
    _isVibrationEnabled = enabled;
    await _savePreferences();
  }

  Future<void> playBackgroundMusic() async {
    if (!_isMusicEnabled) return;
    if (_isMusicPlaying) return;

    try {
      await _backgroundPlayer.setPlayerMode(PlayerMode.mediaPlayer);
      await _backgroundPlayer.setReleaseMode(ReleaseMode.loop);
      await _backgroundPlayer.setVolume(0.35);

      await _backgroundPlayer.play(
        AssetSource('audio/background_music.mp3'),
      );

      await Future.delayed(const Duration(milliseconds: 200));

      final state = _backgroundPlayer.state;
      if (state == PlayerState.playing) {
        _isMusicPlaying = true;
      } else {
        _isMusicPlaying = false;
      }
    } catch (e) {
      debugPrint('Error playing background music: $e');
      _isMusicPlaying = false;
    }
  }

  Future<void> stopBackgroundMusic() async {
    if (!_isMusicPlaying) return;

    try {
      await _backgroundPlayer.stop();
      _isMusicPlaying = false;
    } catch (e) {
      debugPrint('Error stopping background music: $e');
    }
  }

  Future<void> playIntro() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.setVolume(0.5);
      await _sfxPlayer.play(AssetSource('audio/intro.mp3'));
    } catch (e) {
      debugPrint('Error playing intro: $e');
    }
  }

  Future<void> playButtonTap() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.stop();
      await _sfxPlayer.setVolume(0.5);
      await _sfxPlayer.play(AssetSource('audio/button-tap-pop.mp3'));
    } catch (e) {
      debugPrint('Error playing button tap: $e');
    }
  }

  Future<void> playLessonCompleted() async {
    if (!_isSfxEnabled) return;

    try {
      await _sfxPlayer.setVolume(0.5);
      await _sfxPlayer.play(AssetSource('audio/completed.mp3'));
    } catch (e) {
      debugPrint('Error playing lesson completed: $e');
    }
  }

  Future<void> dispose() async {
    await _stateSubscription?.cancel();
    await _backgroundPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
