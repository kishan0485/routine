import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  final String total;
  final Gradient gradient;

  const StatChip({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.total,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 8),
          ShaderMask(
            shaderCallback: (bounds) => gradient.createShader(bounds),
            child: Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            total,
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }
}
