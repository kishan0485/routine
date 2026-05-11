import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class WaterWidget extends StatefulWidget {
  const WaterWidget({super.key});
  @override
  State<WaterWidget> createState() => _WaterWidgetState();
}

class _WaterWidgetState extends State<WaterWidget> {
  int _glasses = 3;
  final int _total =
      AppConstants.dailyWaterGoalMl ~/ AppConstants.waterPerGlassMl;

  @override
  Widget build(BuildContext context) {
    final progress = _glasses / _total;
    final ml = _glasses * AppConstants.waterPerGlassMl;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
                '$ml ml',
                style: AppTextStyles.labelMedium
                    .copyWith(color: AppColors.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Progress track
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: AppColors.borderDark,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                height: 8,
                width: (MediaQuery.of(context).size.width - 80) * progress,
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withValues(alpha: 0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Glass indicators
              Row(
                children: List.generate(
                  _total,
                  (i) => Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i < _glasses
                            ? AppColors.accent
                            : AppColors.borderDark,
                        boxShadow: i < _glasses
                            ? [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.6),
                                  blurRadius: 6,
                                )
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  _Btn(
                    icon: Icons.remove_rounded,
                    color: AppColors.rose,
                    onTap: () {
                      if (_glasses > 0) setState(() => _glasses--);
                    },
                  ),
                  const SizedBox(width: 8),
                  _Btn(
                    icon: Icons.add_rounded,
                    color: AppColors.accent,
                    onTap: () {
                      if (_glasses < _total) setState(() => _glasses++);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Btn({required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          shape: BoxShape.circle,
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}
