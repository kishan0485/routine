import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../widgets/task_card.dart';
import '../widgets/water_widget.dart';
import '../widgets/ai_suggestion_card.dart';
import '../widgets/stat_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _tasks = [
    {'title': 'Morning workout', 'time': '7:00 AM', 'done': true,  'icon': '💪'},
    {'title': 'Read 20 pages',   'time': '9:00 AM', 'done': false, 'icon': '📚'},
    {'title': 'Drink 2L water',  'time': 'All day', 'done': false, 'icon': '💧'},
    {'title': 'Meditate 10 min', 'time': '12:00 PM','done': false, 'icon': '🧘'},
    {'title': 'Evening walk',    'time': '6:00 PM', 'done': false, 'icon': '🚶'},
  ];

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';
    final completed = _tasks.where((t) => t['done'] == true).length;
    final progress  = completed / _tasks.length;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          // ── Hero header ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Mesh gradient blob
                Positioned(
                  top: -40,
                  right: -60,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: -80,
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.10),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top row
                      FadeInDown(
                        duration: const Duration(milliseconds: 500),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    greeting,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Kishan 👋', style: AppTextStyles.displayMedium),
                                ],
                              ),
                            ),
                            // Avatar with glow
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                gradient: AppColors.primaryGradient,
                                shape: BoxShape.circle,
                                boxShadow: [AppColors.primaryGlow(opacity: 0.5, blur: 16)],
                              ),
                              child: Center(
                                child: Text('K',
                                    style: AppTextStyles.headlineMedium
                                        .copyWith(color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Progress card
                      FadeInDown(
                        delay: const Duration(milliseconds: 100),
                        child: GlassCard(
                          glowColor: AppColors.primary,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$completed of ${_tasks.length} tasks done',
                                    style: AppTextStyles.headlineSmall,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${(progress * 100).round()}%',
                                      style: AppTextStyles.labelMedium.copyWith(
                                          color: AppColors.primary),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Stack(
                                children: [
                                  Container(
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: AppColors.borderDark,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 600),
                                    curve: Curves.easeOutCubic,
                                    height: 6,
                                    width: MediaQuery.of(context).size.width *
                                        progress *
                                        0.78,
                                    decoration: BoxDecoration(
                                      gradient: AppColors.primaryGradient,
                                      borderRadius: BorderRadius.circular(3),
                                      boxShadow: [AppColors.primaryGlow(blur: 8, opacity: 0.6)],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                completed == _tasks.length
                                    ? '🎉 All done! Amazing day!'
                                    : '${_tasks.length - completed} tasks remaining — keep going!',
                                style: AppTextStyles.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Body content ──────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stat chips
                FadeInUp(
                  child: Row(
                    children: [
                      Expanded(child: StatChip(icon: '👣', label: 'Steps',   value: '4,230', sub: '/ 8k',   color: AppColors.accent)),
                      const SizedBox(width: 10),
                      Expanded(child: StatChip(icon: '🔥', label: 'Cal',     value: '320',   sub: 'kcal',   color: AppColors.gold)),
                      const SizedBox(width: 10),
                      Expanded(child: StatChip(icon: '😴', label: 'Sleep',   value: '7.2',   sub: 'hrs',    color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Water
                FadeInUp(delay: const Duration(milliseconds: 80),
                    child: const WaterWidget()),
                const SizedBox(height: 14),

                // AI suggestion
                FadeInUp(delay: const Duration(milliseconds: 120),
                    child: const AISuggestionCard()),
                const SizedBox(height: 22),

                // Today's tasks header
                FadeInUp(
                  delay: const Duration(milliseconds: 150),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Tasks", style: AppTextStyles.headlineMedium),
                      GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.25)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.add_rounded,
                                  size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text('Add',
                                  style: AppTextStyles.caption.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Task list
                ..._tasks.asMap().entries.map((entry) => FadeInUp(
                      delay: Duration(milliseconds: 180 + entry.key * 50),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: TaskCard(
                          title: entry.value['title'],
                          time: entry.value['time'],
                          icon: entry.value['icon'],
                          isDone: entry.value['done'],
                          onToggle: () => setState(() {
                            _tasks[entry.key]['done'] =
                                !_tasks[entry.key]['done'];
                          }),
                        ),
                      ),
                    )),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
