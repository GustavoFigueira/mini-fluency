import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MobileDevicePreview extends StatelessWidget {
  const MobileDevicePreview({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const isWeb = kIsWeb;
    final isDesktop = MediaQuery.of(context).size.width > 800;

    if (!isWeb || !isDesktop) {
      return child;
    }

    return DevicePreview(
      builder: (context) => child,
      backgroundColor: Colors.black,
    );
  }
}
