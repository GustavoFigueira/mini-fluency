import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/core/services/audio_service.dart';

class SoundPreferencesSheet extends StatefulWidget {
  const SoundPreferencesSheet({super.key});

  @override
  State<SoundPreferencesSheet> createState() => _SoundPreferencesSheetState();
}

class _SoundPreferencesSheetState extends State<SoundPreferencesSheet> {
  final _audioService = AudioService();

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PREFERÊNCIAS DE SONS',
                      style: AppTypography.titleLarge.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSoundOption(
                      icon: Icons.volume_up_rounded,
                      label: 'Efeitos sonoros',
                      value: _audioService.isSfxEnabled,
                      onChanged: _handleSfxToggle,
                    ),
                    const SizedBox(height: 16),
                    _buildSoundOption(
                      icon: Icons.music_note_rounded,
                      label: 'Trilhas sonoras',
                      value: _audioService.isMusicEnabled,
                      onChanged: _handleMusicToggle,
                    ),
                    const SizedBox(height: 16),
                    _buildSoundOption(
                      icon: Icons.vibration_rounded,
                      label: 'Vibrações',
                      value: _audioService.isVibrationEnabled,
                      onChanged: _handleVibrationToggle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  Widget _buildHandle() => Container(
        margin: const EdgeInsets.only(top: 12),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      );

  Widget _buildSoundOption({
    required IconData icon,
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) =>
      Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: AppTypography.titleMedium.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) =>
                ButtonTapHandler.handleToggle(onChanged, newValue: newValue),
            activeThumbColor: AppColors.primary,
          ),
        ],
      );

  Future<void> _handleSfxToggle(bool value) async {
    await _audioService.setSfxEnabled(enabled: value);
    setState(() {});
  }

  Future<void> _handleMusicToggle(bool value) async {
    await _audioService.setMusicEnabled(enabled: value);
    setState(() {});
  }

  Future<void> _handleVibrationToggle(bool value) async {
    await _audioService.setVibrationEnabled(enabled: value);
    setState(() {});
  }
}
