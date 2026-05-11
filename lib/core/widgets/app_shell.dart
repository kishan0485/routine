import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class AppShell extends StatelessWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/ai')) return 1;
    if (location.startsWith('/health')) return 2;
    if (location.startsWith('/routine')) return 3;
    if (location.startsWith('/focus')) return 4;
    return 0;
  }

  void _onTabTap(BuildContext context, int index) {
    const routes = ['/home', '/ai', '/health', '/routine', '/focus'];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          border: Border(
            top: BorderSide(color: AppColors.borderDark, width: 0.5),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_rounded,
                  label: 'Home',
                  isActive: currentIndex == 0,
                  onTap: () => _onTabTap(context, 0),
                ),
                _NavItem(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI',
                  isActive: currentIndex == 1,
                  onTap: () => _onTabTap(context, 1),
                ),
                _NavItem(
                  icon: Icons.favorite_rounded,
                  label: 'Health',
                  isActive: currentIndex == 2,
                  onTap: () => _onTabTap(context, 2),
                ),
                _NavItem(
                  icon: Icons.loop_rounded,
                  label: 'Routine',
                  isActive: currentIndex == 3,
                  onTap: () => _onTabTap(context, 3),
                ),
                _NavItem(
                  icon: Icons.timer_rounded,
                  label: 'Focus',
                  isActive: currentIndex == 4,
                  onTap: () => _onTabTap(context, 4),
                ),
              ],
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
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: isActive
            ? BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: isActive ? AppColors.primary : AppColors.textMuted,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
