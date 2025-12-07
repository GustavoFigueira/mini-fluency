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
  Widget build(BuildContext context) => DecoratedBox(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
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
                    color: AppColors.error.withValues(alpha: 0.15),
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 40,
                  ),
                ),
                AppSpacing.verticalGapXXL,
                Text(
                  'Ops! Algo deu errado',
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalGapMD,
                Text(
                  message,
                  style: AppTypography.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                AppSpacing.verticalGapXXL,
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
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
