import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';

class PathHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSettingsTap;
  final VoidCallback onSoundPreferencesTap;

  const PathHeader({
    super.key,
    required this.title,
    required this.onSettingsTap,
    required this.onSoundPreferencesTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.backgroundGradient.colors.first,
                colors.backgroundGradient.colors.first.withValues(alpha: 0.0),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(child: _buildTitleCard(colors)),
                const SizedBox(width: 12),
                _HeaderActionButton(
                  icon: Icons.settings_outlined,
                  onTap: onSettingsTap,
                ),
                const SizedBox(width: 8),
                _HeaderActionButton(
                  icon: Icons.volume_up_outlined,
                  onTap: onSoundPreferencesTap,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleCard(AppThemeColors colors) => Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: colors.primary.withValues(
            alpha: AppConstants.headerBackgroundAlpha,
          ),
          borderRadius: BorderRadius.circular(AppConstants.headerBorderRadius),
          border: Border.all(
            color: colors.isLight
                ? colors.primaryLightMode.withValues(
                    alpha: AppConstants.headerBorderAlpha,
                  )
                : colors.primary.withValues(
                    alpha: AppConstants.headerBorderAlpha,
                  ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Trilha de Aprendizado',
              style: AppTypography.labelSmall.copyWith(
                color: colors.isLight
                    ? colors.primaryLightMode
                    : colors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: AppTypography.titleLarge.copyWith(
                color: colors.isLight
                    ? colors.primaryLightMode
                    : colors.textPrimary,
              ),
            ),
          ],
        ),
      );
}

class _HeaderActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderActionButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;

    return GestureDetector(
      onTap: () => ButtonTapHandler.handleTap(onTap),
      child: Container(
        width: AppConstants.headerActionSize,
        height: AppConstants.headerActionSize,
        decoration: BoxDecoration(
          color: colors.primary.withValues(
            alpha: AppConstants.headerActionBackgroundAlpha,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: colors.isLight
                ? colors.primaryLightMode.withValues(
                    alpha: AppConstants.headerBorderAlpha,
                  )
                : colors.primary.withValues(
                    alpha: AppConstants.headerBorderAlpha,
                  ),
          ),
        ),
        child: Icon(
          icon,
          color: colors.primaryLight,
          size: AppConstants.headerActionIconSize,
        ),
      ),
    );
  }
}
