import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String icon;
  final bool isDone;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.isDone,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      decoration: BoxDecoration(
        color: isDone
            ? AppColors.success.withValues(alpha: 0.06)
            : AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDone
              ? AppColors.success.withValues(alpha: 0.25)
              : AppColors.borderDark,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    decoration:
                        isDone ? TextDecoration.lineThrough : null,
                    decorationColor: AppColors.textMuted,
                    color: isDone
                        ? AppColors.textMuted
                        : AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
          // Checkbox
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutBack,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDone ? AppColors.greenGradient : null,
                border: isDone
                    ? null
                    : Border.all(color: AppColors.borderDark, width: 2),
                boxShadow: isDone
                    ? [
                        BoxShadow(
                          color: AppColors.success.withValues(alpha: 0.4),
                          blurRadius: 10,
                        )
                      ]
                    : null,
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 15)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
