import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HnDarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color? bgColor;
  const HnDarkAppBar({super.key, this.bgColor});

  @override
  Size get preferredSize => const Size.fromHeight(0);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: const SizedBox.shrink(),
    );
  }
}

class HnLightAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HnLightAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(0);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: const SizedBox.shrink(),
    );
  }
}
