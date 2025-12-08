import 'package:flutter/material.dart';
import 'package:mini_fluency/core/core.dart';
import 'package:mini_fluency/models/models.dart';

class PathConnector extends StatelessWidget {
  final bool fromRight;
  final bool toRight;
  final LessonStatus status;
  final double width;
  final double screenWidth;

  const PathConnector({
    super.key,
    required this.fromRight,
    required this.toRight,
    required this.status,
    required this.width,
    required this.screenWidth,
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
          screenWidth: screenWidth,
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
  final double screenWidth;

  _PathConnectorPainter({
    required this.fromRight,
    required this.toRight,
    required this.color,
    required this.screenWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = AppConstants.connectorStrokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    const nodeSize = 64.0;

    // Calculate the actual X position of the top node (fromRight)
    // For right-aligned nodes: screenWidth - listViewPadding - rightPadding - nodeRadius
    // For left-aligned nodes: listViewPadding + leftPadding + nodeRadius
    final topNodeCenterX = fromRight
        ? screenWidth -
            AppConstants.listViewHorizontalPadding -
            AppConstants.lessonNodePaddingRight -
            (nodeSize / 2)
        : AppConstants.listViewHorizontalPadding +
            AppConstants.lessonNodePaddingLeft +
            (nodeSize / 2);

    // Calculate the actual X position of the bottom node (toRight)
    final bottomNodeCenterX = toRight
        ? screenWidth -
            AppConstants.listViewHorizontalPadding -
            AppConstants.lessonNodePaddingRight -
            (nodeSize / 2)
        : AppConstants.listViewHorizontalPadding +
            AppConstants.lessonNodePaddingLeft +
            (nodeSize / 2);

    const connectorLeftOffset = AppConstants.listViewHorizontalPadding;
    final startX = (topNodeCenterX - connectorLeftOffset) +
        (fromRight
            ? AppConstants.connectorMargin
            : -AppConstants.connectorMargin);
    final endX = (bottomNodeCenterX - connectorLeftOffset) +
        (toRight
            ? AppConstants.connectorMargin
            : -AppConstants.connectorMargin);

    // Calculate the center X for the bezier curve
    final centerX = (startX + endX) / 2;

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
      oldDelegate.color != color ||
      oldDelegate.screenWidth != screenWidth;
}
