import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';

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
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontSize: 14,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? AppColors.textMuted : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: isDone ? AppColors.greenGradient : null,
                border: isDone
                    ? null
                    : Border.all(color: AppColors.borderDark, width: 2),
              ),
              child: isDone
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
