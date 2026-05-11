import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/streak_badge.dart';

class HabitCard extends StatelessWidget {
  final String name;
  final String icon;
  final int streak;
  final int xp;
  final bool isDone;
  final Color color;
  final VoidCallback onToggle;

  const HabitCard({
    super.key,
    required this.name,
    required this.icon,
    required this.streak,
    required this.xp,
    required this.isDone,
    required this.color,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: isDone
              ? color.withValues(alpha: 0.08)
              : AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDone
                ? color.withValues(alpha: 0.35)
                : AppColors.borderDark,
            width: 1,
          ),
          boxShadow: isDone
              ? [BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 14)]
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontSize: 14,
                      color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      decorationColor: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      StreakBadge(streak: streak, size: 0.85),
                      const SizedBox(width: 7),
                      XpBadge(xp: xp),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDone ? AppColors.greenGradient : null,
                border: isDone
                    ? null
                    : Border.all(color: AppColors.borderDark, width: 1.5),
                boxShadow: isDone
                    ? [BoxShadow(
                        color: AppColors.success.withValues(alpha: 0.4),
                        blurRadius: 10)]
                    : null,
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
