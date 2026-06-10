import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/routes.dart';
import '../theme/app_theme.dart';

enum OnFieldTab { tasks, map, reports, sync }

/// Persistent bottom navigation (DESIGN.md → Bottom Navigation).
class OnFieldBottomNav extends StatelessWidget {
  const OnFieldBottomNav({required this.current, super.key});

  final OnFieldTab current;

  void _go(BuildContext context, OnFieldTab tab) {
    if (tab == current) return;
    switch (tab) {
      case OnFieldTab.tasks:
        context.go(Routes.tasks);
      case OnFieldTab.map:
        context.go(Routes.map);
      case OnFieldTab.reports:
        context.go(Routes.dashboard);
      case OnFieldTab.sync:
        // Sync has no dedicated route yet; stay put.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _item(context, OnFieldTab.tasks, Icons.assignment_outlined,
                  'Tasks'),
              _item(context, OnFieldTab.map, Icons.map_outlined, 'Map'),
              _item(context, OnFieldTab.reports, Icons.assessment_outlined,
                  'Reports'),
              _item(context, OnFieldTab.sync, Icons.sync, 'Sync'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
      BuildContext context, OnFieldTab tab, IconData icon, String label) {
    final selected = tab == current;
    return Expanded(
      child: InkWell(
        onTap: () => _go(context, tab),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.base),
              ),
              child: Icon(
                icon,
                size: 24,
                color:
                    selected ? Colors.white : AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
