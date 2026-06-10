import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/onfield_bottom_nav.dart';
import '../../../../core/widgets/onfield_drawer.dart';
import '../../../../core/router/routes.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';

class ManagerDashboardScreen extends ConsumerWidget {
  const ManagerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskListProvider).value ?? const <Task>[];
    final team = ref.watch(teamLocationsProvider).value ?? const [];

    final byStatus = <TaskStatus, int>{};
    for (final t in tasks) {
      byStatus[t.status] = (byStatus[t.status] ?? 0) + 1;
    }
    final pending = byStatus[TaskStatus.pending] ?? 0;
    final completed = byStatus[TaskStatus.completed] ?? 0;

    return Scaffold(
      drawer: const OnFieldDrawer(),
      appBar: AppBar(
        title: const Text('OnField'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_outlined,
                color: AppColors.primaryContainer),
          ),
        ],
      ),
      bottomNavigationBar: const OnFieldBottomNav(current: OnFieldTab.reports),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          Text('Overview',
              style: Theme.of(context).textTheme.headlineLarge),
          const SizedBox(height: 4),
          Text('Live operations status.',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          _metric('TOTAL WORKERS', '${team.length}', Icons.people,
              AppColors.primary, Colors.white),
          const SizedBox(height: 12),
          _metric('TASKS PENDING', '$pending', Icons.assignment_outlined,
              AppColors.infoContainer, AppColors.primary),
          const SizedBox(height: 12),
          _metric('COMPLETED', '$completed', Icons.check_circle_outline,
              AppColors.successContainer, AppColors.success),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => context.push(Routes.map),
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.map_outlined,
                        size: 36, color: AppColors.primary),
                    SizedBox(height: 8),
                    Text('View Live Fleet Locations',
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metric(String label, String value, IconData icon, Color iconBg,
      Color iconFg) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: AppColors.onSurfaceVariant,
                    )),
                const SizedBox(height: 6),
                Text(value,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    )),
              ],
            ),
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconFg, size: 22),
          ),
        ],
      ),
    );
  }
}
