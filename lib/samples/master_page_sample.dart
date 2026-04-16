import 'package:flyer/functions/get_app_name.dart';

Future<String> masterPageSample() async {
  String appName = await getAppName();
  return '''
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:$appName/app/bloc/app_bloc.dart';
import 'package:$appName/app/bloc/app_state.dart';
import 'package:$appName/app/data/bottom_nav_data.dart';
import 'package:$appName/app/models/bottom_nav_item_model.dart';
import 'package:$appName/config/app_config.dart';

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<MasterPage> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  late final _bottomNavItems = BottomNavData().data;

  @override
  void initState() {
    super.initState();
    AppBloc.to.init();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      bloc: getIt.get(),
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.currentIndex,
            children: _bottomNavItems.map((e) => e.page).toList(),
          ),
          extendBody: true,
          bottomNavigationBar: _FloatingNavBar(
            items: _bottomNavItems,
            currentIndex: state.currentIndex,
            onTap: (index) {
              HapticFeedback.lightImpact();
              AppBloc.to.changeIndex(index);
            },
          ),
        );
      },
    );
  }
}

class _FloatingNavBar extends StatelessWidget {
  final List<BottomNavItemModel> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _FloatingNavBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        decoration: BoxDecoration(
          color: isDark
              ? scheme.surfaceContainer
              : scheme.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : scheme.primary.withValues(alpha: 0.08),
              blurRadius: 24,
              spreadRadius: 0,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.1)
                  : scheme.shadow.withValues(alpha: 0.04),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            return _NavItem(
              icon: items[index].icon,
              label: items[index].label,
              isActive: currentIndex == index,
              onTap: () => onTap(index),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: ScaleTransition(
          scale: _scaleAnimation.drive(
            Tween<double>(begin: 1.0, end: 1.15),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.isActive
                      ? scheme.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  size: widget.isActive ? 24 : 22,
                  color: widget.isActive
                      ? scheme.primary
                      : scheme.onSurface.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: TextStyle(
                  fontSize: widget.isActive ? 11 : 10,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive
                      ? scheme.primary
                      : scheme.onSurface.withValues(alpha: 0.4),
                ),
                child: Text(
                  widget.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
''';
}
