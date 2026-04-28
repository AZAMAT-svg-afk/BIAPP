import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_palette.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  final List<AppBottomNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(10, 0, 10, 8),
      child: SizedBox(
        height: 70,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
              bottom: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: palette.shadow,
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
              bottom: Radius.circular(24),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: palette.glass.withValues(alpha: 0.38),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      for (var index = 0; index < items.length; index++)
                        Expanded(
                          child: _BottomNavButton(
                            item: items[index],
                            selected: index == selectedIndex,
                            onTap: () => onSelected(index),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = selected ? scheme.onPrimary : scheme.onSurfaceVariant;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                width: selected ? 34 : 30,
                height: selected ? 34 : 30,
                decoration: BoxDecoration(
                  color: selected ? scheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                  boxShadow: selected
                      ? [
                          BoxShadow(
                            color: scheme.primary.withValues(alpha: 0.30),
                            blurRadius: 18,
                            offset: const Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  selected ? item.selectedIcon : item.icon,
                  color: color,
                  size: selected ? 20 : 22,
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                child: selected
                    ? Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: scheme.primary,
                                fontWeight: FontWeight.w900,
                                fontSize: 10.5,
                              ),
                        ),
                      )
                    : const SizedBox(height: 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
