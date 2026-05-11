import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
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
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      onTap: onToggle,
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
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
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    StreakBadge(streak: streak, size: 0.85),
                    const SizedBox(width: 8),
                    XpBadge(xp: xp),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
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
                        color: AppColors.success.withOpacity(0.4),
                        blurRadius: 8,
                      )
                    ]
                  : null,
            ),
            child: isDone
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                : null,
          ),
        ],
      ),
    );
  }
}
