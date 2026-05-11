import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/streak_badge.dart';
import '../widgets/habit_card.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({super.key});

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _habits = [
    {'name': 'Morning Workout', 'icon': '💪', 'streak': 12, 'xp': 120, 'done': false, 'color': AppColors.primary},
    {'name': 'Read 20 Pages', 'icon': '📚', 'streak': 7, 'xp': 70, 'done': true, 'color': AppColors.accent},
    {'name': 'Meditate', 'icon': '🧘', 'streak': 5, 'xp': 50, 'done': false, 'color': AppColors.success},
    {'name': 'No Junk Food', 'icon': '🥗', 'streak': 3, 'xp': 30, 'done': false, 'color': AppColors.warning},
    {'name': 'Cold Shower', 'icon': '🚿', 'streak': 20, 'xp': 200, 'done': true, 'color': AppColors.info},
  ];

  final List<Map<String, dynamic>> _morningRoutine = [
    {'step': 'Wake up at 6 AM', 'icon': '⏰', 'done': true},
    {'step': 'Drink 1 glass of water', 'icon': '💧', 'done': true},
    {'step': '10 min stretching', 'icon': '🤸', 'done': false},
    {'step': 'Cold shower', 'icon': '🚿', 'done': false},
    {'step': 'Healthy breakfast', 'icon': '🥗', 'done': false},
    {'step': 'Set 3 priorities for today', 'icon': '🎯', 'done': false},
  ];

  final List<Map<String, dynamic>> _nightRoutine = [
    {'step': 'No screen after 10 PM', 'icon': '📵', 'done': false},
    {'step': 'Journal 5 mins', 'icon': '📓', 'done': false},
    {'step': 'Plan tomorrow', 'icon': '📅', 'done': false},
    {'step': 'Gratitude (3 things)', 'icon': '🙏', 'done': false},
    {'step': 'Sleep by 11 PM', 'icon': '😴', 'done': false},
  ];

  int get _totalXp => _habits.fold(0, (s, h) => s + (h['xp'] as int));
  int get _completedHabits =>
      _habits.where((h) => h['done'] == true).length;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text('Routine', style: AppTextStyles.headlineLarge),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: XpBadge(xp: _totalXp),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Habits'),
            Tab(text: 'Morning'),
            Tab(text: 'Night'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _HabitsTab(
            habits: _habits,
            completed: _completedHabits,
            total: _habits.length,
            onToggle: (index) => setState(
                () => _habits[index]['done'] = !_habits[index]['done']),
          ),
          _RoutineTab(steps: _morningRoutine, title: '🌅 Morning Routine'),
          _RoutineTab(steps: _nightRoutine, title: '🌙 Night Routine'),
        ],
      ),
    );
  }
}

class _HabitsTab extends StatelessWidget {
  final List<Map<String, dynamic>> habits;
  final int completed, total;
  final void Function(int) onToggle;

  const _HabitsTab({
    required this.habits,
    required this.completed,
    required this.total,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FadeInDown(
          child: GlassCard(
            gradient: const LinearGradient(
              colors: [Color(0x337C3AED), Color(0x1A4F46E5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('$completed/$total habits done today',
                          style: AppTextStyles.headlineSmall),
                      const SizedBox(height: 4),
                      Text('Keep the streak alive! 🔥',
                          style: AppTextStyles.bodyMedium),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: completed / total,
                          backgroundColor: AppColors.borderDark,
                          color: AppColors.primary,
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Text('⚡', style: TextStyle(fontSize: 40)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...habits.asMap().entries.map(
          (e) => FadeInUp(
            delay: Duration(milliseconds: 80 * e.key),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HabitCard(
                name: e.value['name'],
                icon: e.value['icon'],
                streak: e.value['streak'],
                xp: e.value['xp'],
                isDone: e.value['done'],
                color: e.value['color'],
                onToggle: () => onToggle(e.key),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        FadeInUp(
          child: GestureDetector(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.cardDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: AppColors.borderDark, style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add_rounded,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Add new habit',
                      style: AppTextStyles.labelLarge
                          .copyWith(color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RoutineTab extends StatefulWidget {
  final List<Map<String, dynamic>> steps;
  final String title;

  const _RoutineTab({required this.steps, required this.title});

  @override
  State<_RoutineTab> createState() => _RoutineTabState();
}

class _RoutineTabState extends State<_RoutineTab> {
  late List<Map<String, dynamic>> _steps;

  @override
  void initState() {
    super.initState();
    _steps = List.from(widget.steps);
  }

  @override
  Widget build(BuildContext context) {
    final done = _steps.where((s) => s['done'] == true).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FadeInDown(
          child: GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title, style: AppTextStyles.headlineSmall),
                Text('$done/${_steps.length}',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.success)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._steps.asMap().entries.map(
          (e) => FadeInUp(
            delay: Duration(milliseconds: 80 * e.key),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                onTap: () =>
                    setState(() => _steps[e.key]['done'] = !_steps[e.key]['done']),
                child: Row(
                  children: [
                    Text(e.value['icon'],
                        style: const TextStyle(fontSize: 22)),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        e.value['step'],
                        style: AppTextStyles.bodyLarge.copyWith(
                          decoration: e.value['done']
                              ? TextDecoration.lineThrough
                              : null,
                          color: e.value['done']
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: e.value['done']
                            ? AppColors.greenGradient
                            : null,
                        border: e.value['done']
                            ? null
                            : Border.all(color: AppColors.borderDark, width: 2),
                      ),
                      child: e.value['done']
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
