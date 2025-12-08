import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';

class PathConnector extends StatelessWidget {
  final bool fromRight;
  final bool toRight;
  final LessonStatus status;
  final double width;

  const PathConnector({
    super.key,
    required this.fromRight,
    required this.toRight,
    required this.status,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.themeColors;
    return SizedBox(
      width: width,
      height: AppConstants.connectorHeight,
      child: CustomPaint(
        painter: _PathConnectorPainter(
          fromRight: fromRight,
          toRight: toRight,
          color: _getConnectorColor(colors, status),
        ),
      ),
    );
  }

  Color _getConnectorColor(AppThemeColors colors, LessonStatus status) {
    switch (status) {
      case LessonStatus.completed:
        return colors.success.withValues(
          alpha: AppConstants.connectorColorAlpha,
        );
      case LessonStatus.current:
        return colors.primary.withValues(
          alpha: AppConstants.connectorColorAlpha,
        );
      case LessonStatus.locked:
        return Colors.grey.withValues(alpha: 0.3);
    }
  }
}

class _PathConnectorPainter extends CustomPainter {
  final bool fromRight;
  final bool toRight;
  final Color color;

  _PathConnectorPainter({
    required this.fromRight,
    required this.toRight,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppConstants.connectorStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerX = size.width / 2;

    final startX = fromRight
        ? centerX + (AppConstants.nodeWidth / 2) + AppConstants.connectorMargin
        : centerX - (AppConstants.nodeWidth / 2) - AppConstants.connectorMargin;
    final endX = toRight
        ? centerX + (AppConstants.nodeWidth / 2) + AppConstants.connectorMargin
        : centerX - (AppConstants.nodeWidth / 2) - AppConstants.connectorMargin;

    const topVerticalEnd =
        AppConstants.connectorMargin + AppConstants.connectorVerticalLineLength;
    final bottomVerticalStart = size.height -
        AppConstants.connectorMargin -
        AppConstants.connectorVerticalLineLength;

    path
      ..moveTo(startX, AppConstants.connectorMargin)
      ..lineTo(startX, topVerticalEnd)
      ..quadraticBezierTo(
        centerX,
        size.height / 2,
        endX,
        bottomVerticalStart,
      )
      ..lineTo(endX, size.height - AppConstants.connectorMargin);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _PathConnectorPainter oldDelegate) =>
      oldDelegate.fromRight != fromRight ||
      oldDelegate.toRight != toRight ||
      oldDelegate.color != color;
}
