import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animate_do/animate_do.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../services/gemini_service.dart';

class HealthScreen extends StatefulWidget {
  const HealthScreen({super.key});

  @override
  State<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends State<HealthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _gemini = GeminiService();
  File? _scannedImage;
  String? _nutritionResult;
  bool _scanning = false;

  final List<Map<String, dynamic>> _meals = [
    {'name': 'Dal Chawal', 'cal': 380, 'protein': 14, 'carbs': 68, 'time': '8:00 AM'},
    {'name': 'Banana', 'cal': 90, 'protein': 1, 'carbs': 23, 'time': '10:30 AM'},
    {'name': 'Paneer Sabzi + Roti', 'cal': 520, 'protein': 22, 'carbs': 55, 'time': '1:00 PM'},
  ];

  int get _totalCal => _meals.fold(0, (s, m) => s + (m['cal'] as int));
  int get _totalProtein => _meals.fold(0, (s, m) => s + (m['protein'] as int));
  int get _totalCarbs => _meals.fold(0, (s, m) => s + (m['carbs'] as int));

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _scanFood() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      _scannedImage = File(picked.path);
      _scanning = true;
      _nutritionResult = null;
    });

    final result = await _gemini.analyzeFood(_scannedImage!);
    if (mounted) {
      setState(() {
        _nutritionResult = result;
        _scanning = false;
      });
    }
  }

  Future<void> _scanFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      _scannedImage = File(picked.path);
      _scanning = true;
      _nutritionResult = null;
    });

    final result = await _gemini.analyzeFood(_scannedImage!);
    if (mounted) {
      setState(() {
        _nutritionResult = result;
        _scanning = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        title: Text('Health', style: AppTextStyles.headlineLarge),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          tabs: const [
            Tab(text: 'Calories'),
            Tab(text: 'Food Scanner'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CalorieTab(
            meals: _meals,
            totalCal: _totalCal,
            totalProtein: _totalProtein,
            totalCarbs: _totalCarbs,
          ),
          _FoodScannerTab(
            scannedImage: _scannedImage,
            nutritionResult: _nutritionResult,
            scanning: _scanning,
            onScanGallery: _scanFood,
            onScanCamera: _scanFromCamera,
          ),
        ],
      ),
    );
  }
}

class _CalorieTab extends StatelessWidget {
  final List<Map<String, dynamic>> meals;
  final int totalCal, totalProtein, totalCarbs;

  const _CalorieTab({
    required this.meals,
    required this.totalCal,
    required this.totalProtein,
    required this.totalCarbs,
  });

  @override
  Widget build(BuildContext context) {
    const goalCal = 2000;
    final progress = (totalCal / goalCal).clamp(0.0, 1.0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        FadeInDown(
          child: GlassCard(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today\'s Calories', style: AppTextStyles.headlineSmall),
                    Text('$totalCal / $goalCal kcal',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.accent)),
                  ],
                ),
                const SizedBox(height: 20),
                CircularPercentIndicator(
                  radius: 70,
                  lineWidth: 10,
                  percent: progress,
                  center: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$totalCal',
                        style: AppTextStyles.headlineLarge.copyWith(fontSize: 28),
                      ),
                      Text('kcal', style: AppTextStyles.caption),
                    ],
                  ),
                  progressColor: AppColors.primary,
                  backgroundColor: AppColors.borderDark,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _MacroChip(label: 'Protein', value: '$totalProtein g', color: AppColors.primary),
                    _MacroChip(label: 'Carbs', value: '$totalCarbs g', color: AppColors.accent),
                    _MacroChip(label: 'Fat', value: '18 g', color: AppColors.warning),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        FadeInUp(
          child: Text('Meals Today', style: AppTextStyles.headlineSmall),
        ),
        const SizedBox(height: 12),
        ...meals.asMap().entries.map(
          (e) => FadeInUp(
            delay: Duration(milliseconds: 100 * e.key),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.value['name'], style: AppTextStyles.headlineSmall.copyWith(fontSize: 14)),
                          const SizedBox(height: 4),
                          Text(e.value['time'], style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${e.value['cal']} kcal',
                          style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
                        ),
                        Text(
                          'P: ${e.value['protein']}g  C: ${e.value['carbs']}g',
                          style: AppTextStyles.caption,
                        ),
                      ],
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

class _MacroChip extends StatelessWidget {
  final String label, value;
  final Color color;

  const _MacroChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTextStyles.headlineSmall.copyWith(color: color)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _FoodScannerTab extends StatelessWidget {
  final File? scannedImage;
  final String? nutritionResult;
  final bool scanning;
  final VoidCallback onScanGallery;
  final VoidCallback onScanCamera;

  const _FoodScannerTab({
    required this.scannedImage,
    required this.nutritionResult,
    required this.scanning,
    required this.onScanGallery,
    required this.onScanCamera,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FadeInDown(
            child: GlassCard(
              gradient: const LinearGradient(
                colors: [Color(0x2206B6D4), Color(0x227C3AED)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              child: Column(
                children: [
                  const Text('📸', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('Food Scanner', style: AppTextStyles.headlineMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Scan any Indian meal to get\ninstant calorie & nutrition info',
                    style: AppTextStyles.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onScanCamera,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.camera_alt_rounded,
                                    color: Colors.white, size: 18),
                                const SizedBox(width: 8),
                                Text('Camera',
                                    style: AppTextStyles.labelLarge
                                        .copyWith(color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: onScanGallery,
                          child: Container(
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: AppColors.borderDark),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.photo_library_rounded,
                                    color: AppColors.accent, size: 18),
                                const SizedBox(width: 8),
                                Text('Gallery',
                                    style: AppTextStyles.labelLarge
                                        .copyWith(color: AppColors.accent)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (scannedImage != null) ...[
            const SizedBox(height: 16),
            FadeInUp(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  scannedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
          if (scanning) ...[
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 12),
            Text('Analyzing your meal...', style: AppTextStyles.bodyMedium),
          ],
          if (nutritionResult != null) ...[
            const SizedBox(height: 16),
            FadeInUp(
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restaurant_menu_rounded,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Text('Nutrition Analysis',
                            style: AppTextStyles.headlineSmall),
                      ],
                    ),
                    const Divider(color: AppColors.borderDark, height: 20),
                    Text(
                      nutritionResult!,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
