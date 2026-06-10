import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../../users/presentation/providers/user_providers.dart';

/// Team roster with online indicators and active task counts.
class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(userListProvider);
    final pings = ref.watch(teamLocationsProvider).value ?? const [];
    final onlineIds = pings.map((p) => p.userId).whereType<String>().toSet();
    final tasks = ref.watch(taskListProvider).value ?? const <Task>[];
    final activeCounts = <String, int>{};
    for (final t in tasks.where((t) => t.status != TaskStatus.completed)) {
      activeCounts[t.assignedToId] = (activeCounts[t.assignedToId] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: usersAsync.maybeWhen(
          data: (users) => Text('Team (${users.length})'),
          orElse: () => const Text('Team'),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(userListProvider.notifier).refresh(),
        child: usersAsync.when(
          loading: () => const SkeletonList(),
          error: (e, _) => ListView(
            children: [
              const SizedBox(height: 120),
              Center(child: Text('Failed to load team: $e')),
            ],
          ),
          data: (users) {
            if (users.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 60),
                  EmptyState(
                    icon: Icons.groups_outlined,
                    title: 'No team members yet',
                  ),
                ],
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final u = users[i];
                final active = activeCounts[u.id] ?? 0;
                return Card(
                  child: ListTile(
                    leading: AvatarChip(
                      name: u.name ?? u.email,
                      online: onlineIds.contains(u.id),
                    ),
                    title: Text(u.name ?? u.email),
                    subtitle: Text(
                      '$active active task${active == 1 ? '' : 's'}',
                    ),
                    trailing: Pill(
                      label: u.role.wire,
                      background: AppColors.surfaceContainerHigh,
                      foreground: AppColors.onSurfaceVariant,
                    ),
                    onTap: () =>
                        context.push(Routes.workerProfilePath(u.id)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
