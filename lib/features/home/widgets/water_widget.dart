import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/constants/app_constants.dart';

class WaterWidget extends StatefulWidget {
  const WaterWidget({super.key});

  @override
  State<WaterWidget> createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  int _glasses = 3;
  final int _totalGlasses =
      AppConstants.dailyWaterGoalMl ~/ AppConstants.waterPerGlassMl;

  void _add() {
    if (_glasses < _totalGlasses) setState(() => _glasses++);
  }

  void _remove() {
    if (_glasses > 0) setState(() => _glasses--);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _glasses / _totalGlasses;
    final ml = _glasses * AppConstants.waterPerGlassMl;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text('💧', style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text('Water Intake', style: AppTextStyles.headlineSmall),
                ],
              ),
              Text(
                '$ml / ${AppConstants.dailyWaterGoalMl} ml',
                style: AppTextStyles.bodySmall
                    .copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.borderDark,
              color: AppColors.accent,
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(
                  _totalGlasses,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      '💧',
                      style: TextStyle(
                        fontSize: 16,
                        color: i < _glasses ? null : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _CircleBtn(
                      icon: Icons.remove, onTap: _remove, color: AppColors.error),
                  const SizedBox(width: 8),
                  _CircleBtn(
                      icon: Icons.add, onTap: _add, color: AppColors.accent),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _CircleBtn(
      {required this.icon, required this.onTap, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
