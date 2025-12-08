import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mini_fluency/core/core.dart';

class PathBottomIcon extends StatelessWidget {
  final VoidCallback onTap;

  const PathBottomIcon({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;
    final backgroundColor =
        colors.isDark ? const Color(0xFF65BDE9) : colors.primaryLightMode;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.bottomIconPadding),
      child: GestureDetector(
        onTap: () => ButtonTapHandler.handleTap(onTap),
        child: Container(
          width: AppConstants.bottomIconSize,
          height: AppConstants.bottomIconSize,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(
              AppConstants.bottomIconBorderRadius,
            ),
            boxShadow: colors.isDark
                ? [
                    BoxShadow(
                      color: backgroundColor.withValues(
                        alpha: AppConstants.boxShadowAlpha,
                      ),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.bottomIconPadding),
            child: SvgPicture.asset(
              AppConstants.fluencyIconPath,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
