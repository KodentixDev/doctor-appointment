import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../localization/app_language.dart';

class HnBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const HnBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Ana Səhifə'),
    (Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Təqvim'),
    (Icons.assignment_rounded, Icons.assignment_outlined, 'Tələblər'),
    (Icons.menu_rounded, Icons.menu, 'Menü'),
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
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
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
                          active ? _items[i].$1 : _items[i].$2,
                          color: active
                              ? AppColors.primary
                              : AppColors.textDimmed,
                          size: 26,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        context.tr(_items[i].$3),
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
