import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/home'))    return 0;
    if (location.startsWith('/ai'))     return 1;
    if (location.startsWith('/health')) return 2;
    if (location.startsWith('/routine'))return 3;
    if (location.startsWith('/focus'))  return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    const routes = ['/home', '/ai', '/health', '/routine', '/focus'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final current = _locationToIndex(location);

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.bgDark,
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.surfaceDark.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.borderDark.withValues(alpha: 0.6),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavItem(icon: Icons.home_rounded,           label: 'Home',    index: 0, current: current, onTap: () => _onTap(context, 0)),
                  _NavItem(icon: Icons.auto_awesome_rounded,   label: 'AI',      index: 1, current: current, onTap: () => _onTap(context, 1)),
                  _NavItem(icon: Icons.favorite_rounded,       label: 'Health',  index: 2, current: current, onTap: () => _onTap(context, 2)),
                  _NavItem(icon: Icons.loop_rounded,           label: 'Routine', index: 3, current: current, onTap: () => _onTap(context, 3)),
                  _NavItem(icon: Icons.timer_rounded,          label: 'Focus',   index: 4, current: current, onTap: () => _onTap(context, 4)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = index == current;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: 40,
              height: 34,
              decoration: isActive
                  ? BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [AppColors.primaryGlow(opacity: 0.4, blur: 12)],
                    )
                  : null,
              child: Icon(
                icon,
                size: 20,
                color: isActive ? Colors.white : AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: AppTextStyles.caption.copyWith(
                color: isActive ? AppColors.primary : AppColors.textMuted,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
