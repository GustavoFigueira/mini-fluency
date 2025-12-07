import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;

    return DecoratedBox(
        decoration: BoxDecoration(
          gradient: colors.backgroundGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: colors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.4),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: colors.textPrimary,
                      strokeWidth: 3,
                    ),
                  ),
                ),
              ),
              AppSpacing.verticalGapXXL,
              Text(
                'Carregando...',
                style: AppTypography.bodyLarge.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
  }
}
