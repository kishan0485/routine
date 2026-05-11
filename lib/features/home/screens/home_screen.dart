import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
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
    {'title': 'Morning workout', 'time': '7:00 AM', 'done': true, 'icon': '💪'},
    {'title': 'Read 20 pages', 'time': '9:00 AM', 'done': false, 'icon': '📚'},
    {'title': 'Drink 2L water', 'time': 'All day', 'done': false, 'icon': '💧'},
    {'title': 'Meditate 10 min', 'time': '12:00 PM', 'done': false, 'icon': '🧘'},
    {'title': 'Evening walk', 'time': '6:00 PM', 'done': false, 'icon': '🚶'},
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';

    final completed = _tasks.where((t) => t['done'] == true).length;
    final progress = completed / _tasks.length;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.bgDark,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A0A3E), AppColors.bgDark],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 64, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FadeInDown(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$greeting, Kishan 👋',
                                    style: AppTextStyles.headlineMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '$completed of ${_tasks.length} tasks done',
                                    style: AppTextStyles.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: 22,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                'K',
                                style: AppTextStyles.headlineSmall
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      FadeInUp(
                        delay: const Duration(milliseconds: 150),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.borderDark,
                            color: AppColors.primary,
                            minHeight: 6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Stats row
                FadeInUp(
                  child: Row(
                    children: [
                      Expanded(
                        child: StatChip(
                          icon: '👣',
                          label: 'Steps',
                          value: '4,230',
                          total: '8,000',
                          gradient: AppColors.accentGradient,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatChip(
                          icon: '🔥',
                          label: 'Calories',
                          value: '320',
                          total: 'kcal',
                          gradient: AppColors.orangeGradient,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatChip(
                          icon: '😴',
                          label: 'Sleep',
                          value: '7.2',
                          total: 'hrs',
                          gradient: AppColors.primaryGradient,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Water tracker
                FadeInUp(
                  delay: const Duration(milliseconds: 100),
                  child: const WaterWidget(),
                ),
                const SizedBox(height: 16),

                // AI suggestion
                FadeInUp(
                  delay: const Duration(milliseconds: 150),
                  child: const AISuggestionCard(),
                ),
                const SizedBox(height: 20),

                // Today's tasks
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Today's Tasks", style: AppTextStyles.headlineSmall),
                      Text('+ Add task',
                          style: AppTextStyles.bodySmall
                              .copyWith(color: AppColors.primary)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ..._tasks.asMap().entries.map(
                      (entry) => FadeInUp(
                        delay: Duration(
                            milliseconds: 250 + entry.key * 60),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: TaskCard(
                            title: entry.value['title'],
                            time: entry.value['time'],
                            icon: entry.value['icon'],
                            isDone: entry.value['done'],
                            onToggle: () {
                              setState(() {
                                _tasks[entry.key]['done'] =
                                    !_tasks[entry.key]['done'];
                              });
                            },
                          ),
                        ),
                      ),
                    ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
