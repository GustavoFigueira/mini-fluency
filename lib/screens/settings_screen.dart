import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/core/services/audio_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '';

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _appVersion =
            'Mini Fluency v${packageInfo.version} (${packageInfo.buildNumber})';
      });
    } catch (e) {
      setState(() {
        _appVersion = 'Mini Fluency v1.0.0 (1)';
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'CONFIGURAÇÕES',
            style: AppTypography.titleLarge.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildAccountSection(),
              _buildSoundPreferencesSection(),
              _buildInformationSection(),
              _buildAccountDeletionSection(),
              const SizedBox(height: 24),
              Text(
                _appVersion,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      );

  Widget _buildAccountSection() => _buildSectionCard(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conta não vinculada',
                style: AppTypography.titleMedium.copyWith(
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Acesse sua conta em qualquer dispositivo',
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.person_add_rounded,
            label: 'Criar Conta',
            onTap: _handleHapticFeedback,
          ),
          _buildSettingsItem(
            icon: Icons.login_rounded,
            label: 'Fazer Login',
            onTap: _handleHapticFeedback,
          ),
        ],
      );

  Widget _buildSoundPreferencesSection() => _buildSectionCard(
        children: [
          Text(
            'PREFERÊNCIAS DE SONS',
            style: AppTypography.titleLarge.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSoundOption(
            icon: Icons.volume_up_rounded,
            label: 'Efeitos sonoros',
            value: AudioService().isSfxEnabled,
            onChanged: _handleSfxToggle,
          ),
          const SizedBox(height: 16),
          _buildSoundOption(
            icon: Icons.music_note_rounded,
            label: 'Trilhas sonoras',
            value: AudioService().isMusicEnabled,
            onChanged: _handleMusicToggle,
          ),
          const SizedBox(height: 16),
          _buildSoundOption(
            icon: Icons.vibration_rounded,
            label: 'Vibrações',
            value: AudioService().isVibrationEnabled,
            onChanged: _handleVibrationToggle,
          ),
        ],
      );

  Widget _buildInformationSection() => _buildSectionCard(
        children: [
          _buildSettingsItem(
            icon: Icons.feedback_rounded,
            label: 'Enviar feedback',
            onTap: _handleHapticFeedback,
          ),
          _buildSettingsItem(
            icon: Icons.help_outline_rounded,
            label: 'FAQ',
            onTap: _handleHapticFeedback,
          ),
          _buildSettingsItem(
            icon: Icons.description_outlined,
            label: 'Termos de uso',
            onTap: _handleHapticFeedback,
          ),
          _buildSettingsItem(
            icon: Icons.privacy_tip_outlined,
            label: 'Política de Privacidade',
            onTap: _handleHapticFeedback,
          ),
        ],
      );

  Widget _buildAccountDeletionSection() => _buildSectionCard(
        children: [
          _buildSettingsItem(
            icon: Icons.delete_outline_rounded,
            label: 'Excluir minha conta',
            textColor: Colors.red,
            iconColor: Colors.red,
            onTap: _handleHapticFeedback,
          ),
        ],
      );

  Widget _buildSectionCard({required List<Widget> children}) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      );

  Widget _buildSettingsItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? Colors.grey.shade700,
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyLarge.copyWith(
                    color: textColor ?? Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
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
              style: AppTypography.bodyLarge.copyWith(
                color: Colors.black,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      );

  void _handleHapticFeedback() {
    HapticFeedback.lightImpact();
  }

  Future<void> _handleSfxToggle(bool value) async {
    HapticFeedback.lightImpact();
    await AudioService().setSfxEnabled(enabled: value);
    setState(() {});
  }

  Future<void> _handleMusicToggle(bool value) async {
    HapticFeedback.lightImpact();
    await AudioService().setMusicEnabled(enabled: value);
    setState(() {});
  }

  Future<void> _handleVibrationToggle(bool value) async {
    HapticFeedback.lightImpact();
    await AudioService().setVibrationEnabled(enabled: value);
    setState(() {});
  }
}
