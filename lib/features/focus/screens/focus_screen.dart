import 'dart:async';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/constants/app_constants.dart';

class FocusScreen extends StatefulWidget {
  const FocusScreen({super.key});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  Timer? _timer;
  bool _running = false;
  bool _isBreak = false;
  int _sessions = 0;
  late int _totalSeconds;
  late int _remaining;

  @override
  void initState() {
    super.initState();
    _totalSeconds = AppConstants.pomodoroWork * 60;
    _remaining = _totalSeconds;
  }

  void _start() {
    setState(() => _running = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining <= 0) {
        t.cancel();
        setState(() {
          _running = false;
          if (!_isBreak) {
            _sessions++;
            _isBreak = true;
            _totalSeconds = (_sessions % 4 == 0
                    ? AppConstants.pomodoroLongBreak
                    : AppConstants.pomodoroShortBreak) *
                60;
          } else {
            _isBreak = false;
            _totalSeconds = AppConstants.pomodoroWork * 60;
          }
          _remaining = _totalSeconds;
        });
      } else {
        setState(() => _remaining--);
      }
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _isBreak = false;
      _totalSeconds = AppConstants.pomodoroWork * 60;
      _remaining = _totalSeconds;
    });
  }

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progress = 1.0 - (_remaining / _totalSeconds);
    final gradient = _isBreak ? AppColors.greenGradient : AppColors.primaryGradient;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text('Focus', style: AppTextStyles.headlineLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderDark),
              ),
              child: Text(
                '$_sessions sessions',
                style: AppTextStyles.caption.copyWith(color: AppColors.accent),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          FadeInDown(
            child: GlassCard(
              gradient: LinearGradient(
                colors: _isBreak
                    ? [const Color(0x2210B981), const Color(0x22059669)]
                    : [const Color(0x227C3AED), const Color(0x224F46E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                children: [
                  Text(
                    _isBreak ? '☕ Break Time' : '🎯 Focus Mode',
                    style: AppTextStyles.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isBreak
                        ? 'Rest your eyes, stretch a bit'
                        : 'Stay focused. No distractions.',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          Center(
            child: FadeInUp(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: _running
                          ? [
                              BoxShadow(
                                color: (_isBreak
                                        ? AppColors.success
                                        : AppColors.primary)
                                    .withValues(alpha: 0.3),
                                blurRadius: 50,
                                spreadRadius: 10,
                              )
                            ]
                          : [],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 105,
                    lineWidth: 12,
                    percent: progress.clamp(0.0, 1.0),
                    backgroundColor: AppColors.borderDark,
                    linearGradient: gradient,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _format(_remaining),
                          style: AppTextStyles.displayLarge.copyWith(
                            fontSize: 44,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _isBreak ? 'Break' : 'Work',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ControlBtn(
                  icon: Icons.refresh_rounded,
                  onTap: _reset,
                  color: AppColors.textMuted,
                  size: 50,
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: _running ? _pause : _start,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: gradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (_isBreak ? AppColors.success : AppColors.primary)
                              .withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                _ControlBtn(
                  icon: Icons.skip_next_rounded,
                  onTap: () {
                    _pause();
                    _reset();
                  },
                  color: AppColors.textMuted,
                  size: 50,
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            delay: const Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Session Settings', style: AppTextStyles.headlineSmall),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SessionChip(
                        label: 'Focus',
                        minutes: AppConstants.pomodoroWork,
                        isActive: !_isBreak,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SessionChip(
                        label: 'Short Break',
                        minutes: AppConstants.pomodoroShortBreak,
                        isActive: _isBreak,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SessionChip(
                        label: 'Long Break',
                        minutes: AppConstants.pomodoroLongBreak,
                        isActive: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_sessions > 0)
            FadeInUp(
              child: GlassCard(
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_sessions Pomodoro${_sessions > 1 ? 's' : ''} done!',
                            style: AppTextStyles.headlineSmall),
                        Text(
                          '${_sessions * AppConstants.pomodoroWork} minutes of deep work',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final double size;

  const _ControlBtn(
      {required this.icon,
      required this.onTap,
      required this.color,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Icon(icon, color: color, size: size * 0.44),
      ),
    );
  }
}

class _SessionChip extends StatelessWidget {
  final String label;
  final int minutes;
  final bool isActive;

  const _SessionChip(
      {required this.label, required this.minutes, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.primaryGradient : null,
        color: isActive ? null : AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isActive ? Colors.transparent : AppColors.borderDark,
        ),
      ),
      child: Column(
        children: [
          Text(
            '$minutes min',
            style: AppTextStyles.labelLarge.copyWith(
              color: isActive ? Colors.white : AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: isActive ? Colors.white70 : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
