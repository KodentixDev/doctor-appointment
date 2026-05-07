import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class StepProgressBar extends StatelessWidget {
  final int current;
  final List<String> labels;

  const StepProgressBar({
    super.key,
    required this.current,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: List.generate(labels.length * 2 - 1, (i) {
          if (i.isOdd) {
            final filled = (i ~/ 2) < current;
            return Expanded(
              child: Container(
                height: 1.5,
                color: filled ? AppColors.primaryBorder : AppColors.border,
              ),
            );
          }
          final step = i ~/ 2;
          final Color bg;
          final Color fg;
          if (step < current) {
            bg = AppColors.primaryLight;
            fg = AppColors.primary;
          } else if (step == current) {
            bg = AppColors.primary;
            fg = Colors.white;
          } else {
            bg = AppColors.border;
            fg = AppColors.textDimmed;
          }

          return Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  '${step + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: fg,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                labels[step],
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                  letterSpacing: 0.04,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
