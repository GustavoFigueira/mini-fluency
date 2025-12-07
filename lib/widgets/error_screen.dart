import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';

class ErrorScreen extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorScreen({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;

    return DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.backgroundGradient,
        ),
        child: Center(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.error.withValues(alpha: 0.15),
                    border: Border.all(
                      color: colors.error.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: colors.error,
                    size: 40,
                  ),
                ),
                AppSpacing.verticalGapXXL,
                Text(
                  'Ops! Algo deu errado',
                  style: AppTypography.headlineMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalGapMD,
                Text(
                  message,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalGapXXL,
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => ButtonTapHandler.handleTap(onRetry),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.textPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.borderRadiusMD),
                      ),
                    ),
                    child: Text(
                      'Tentar Novamente',
                      style: AppTypography.button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
