import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/gradient_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final TextEditingController _nameController = TextEditingController();

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      emoji: '🎯',
      title: 'Build Better Habits',
      subtitle: 'Track daily habits, earn streaks,\nand level up your discipline.',
      gradient: AppColors.primaryGradient,
    ),
    _OnboardingData(
      emoji: '🤖',
      title: 'Your AI Life Coach',
      subtitle: 'Ask anything — diet, workouts,\nstudy tips, motivation. Instantly.',
      gradient: AppColors.accentGradient,
    ),
    _OnboardingData(
      emoji: '🌱',
      title: "Let's Get Started",
      subtitle: 'What should we call you?',
      gradient: AppColors.greenGradient,
      showNameInput: true,
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) =>
                _OnboardingPage(data: _pages[index], nameController: _nameController),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == i ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == i
                              ? AppColors.primary
                              : AppColors.borderDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),
                  GradientButton(
                    label: _currentPage == _pages.length - 1
                        ? 'Get Started 🚀'
                        : 'Next',
                    onTap: _next,
                    gradient: _pages[_currentPage].gradient,
                  ),
                  if (_currentPage < _pages.length - 1) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => context.go('/login'),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingData {
  final String emoji;
  final String title;
  final String subtitle;
  final Gradient gradient;
  final bool showNameInput;

  const _OnboardingData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.showNameInput = false,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final TextEditingController nameController;

  const _OnboardingPage({required this.data, required this.nameController});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 80),
          FadeInDown(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: data.gradient,
                borderRadius: BorderRadius.circular(36),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Center(
                child: Text(data.emoji, style: const TextStyle(fontSize: 52)),
              ),
            ),
          ),
          const SizedBox(height: 40),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Text(
              data.title,
              style: AppTextStyles.displayMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          FadeInUp(
            delay: const Duration(milliseconds: 350),
            child: Text(
              data.subtitle,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (data.showNameInput) ...[
            const SizedBox(height: 32),
            FadeInUp(
              delay: const Duration(milliseconds: 500),
              child: TextField(
                controller: nameController,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: 'Your name',
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      color: AppColors.primary),
                ),
                textCapitalization: TextCapitalization.words,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
