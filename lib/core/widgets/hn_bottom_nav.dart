import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_language.dart';

class HnBottomNavItem {
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const HnBottomNavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });
}

class HnBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<HnBottomNavItem> items;

  const HnBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = defaultItems,
  });

  static const defaultItems = [
    HnBottomNavItem(
      activeIcon: Icons.home_rounded,
      inactiveIcon: Icons.home_outlined,
      label: 'Ana S\u{0259}hif\u{0259}',
    ),
    HnBottomNavItem(
      activeIcon: Icons.calendar_month_rounded,
      inactiveIcon: Icons.calendar_month_outlined,
      label: 'T\u{0259}qvim',
    ),
    HnBottomNavItem(
      activeIcon: Icons.assignment_rounded,
      inactiveIcon: Icons.assignment_outlined,
      label: 'T\u{0259}l\u{0259}bl\u{0259}r',
    ),
    HnBottomNavItem(
      activeIcon: Icons.menu_rounded,
      inactiveIcon: Icons.menu,
      label: 'Men\u{00FC}',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE8EFF8), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 24,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 68,
          child: Row(
            children: List.generate(items.length, (i) {
              final active = i == currentIndex;
              final item = items[i];
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: active
                            ? const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              )
                            : const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primaryLight
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          active ? item.activeIcon : item.inactiveIcon,
                          color: active
                              ? AppColors.primary
                              : AppColors.textDimmed,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.tr(item.label),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.primary
                              : AppColors.textDimmed,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
