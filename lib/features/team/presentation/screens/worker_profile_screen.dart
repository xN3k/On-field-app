import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/widgets/map_overlays.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/report_card.dart';
import '../../../../core/widgets/section_header.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/task_card.dart';
import '../../../location/presentation/providers/location_providers.dart';
import '../../../reports/presentation/providers/report_providers.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../../users/presentation/providers/user_providers.dart';

/// Manager view of a single worker: latest position, tasks, reports.
class WorkerProfileScreen extends ConsumerWidget {
  const WorkerProfileScreen({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDetailProvider(userId));
    final latestAsync = ref.watch(latestLocationProvider(userId));
    final tasks = (ref.watch(taskListProvider).value ?? const <Task>[])
        .where((t) => t.assignedToId == userId)
        .toList();
    final activeTasks =
        tasks.where((t) => t.status != TaskStatus.completed).toList();
    final reports =
        ref.watch(reportsListProvider(userId: userId)).value ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Worker Profile')),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load worker: $e')),
        data: (user) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Column(
                children: [
                  AvatarChip(name: user.name ?? user.email, radius: 36),
                  const SizedBox(height: 12),
                  Text(user.name ?? user.email,
                      style: Theme.of(context).textTheme.titleLarge),
                  Text(user.email,
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 8),
                  Pill(
                    label: user.role.wire,
                    background: context.colors.infoContainer,
                    foreground: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionHeader(
              'Current Location',
              actionLabel: 'History',
              onAction: () =>
                  context.push(Routes.locationHistoryPath(userId)),
            ),
            latestAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('Location unavailable: $e'),
              data: (ping) {
                if (ping == null) {
                  return Text('No location pings yet.',
                      style: Theme.of(context).textTheme.bodyMedium);
                }
                final pos = LatLng(ping.latitude, ping.longitude);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      child: SizedBox(
                        height: 160,
                        child: FlutterMap(
                          options: MapOptions(
                            initialCenter: pos,
                            initialZoom: 14,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.none,
                            ),
                          ),
                          children: [
                            osmTileLayer(),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: pos,
                                  width: 40,
                                  height: 40,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                            osmAttribution(),
                          ],
                        ),
                      ),
                    ),
                    if (ping.timestamp != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          'Last updated ${DateFormat.yMMMd().add_jm().format(ping.timestamp!)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            const SectionHeader('Active Tasks'),
            if (activeTasks.isEmpty)
              Text('No active tasks.',
                  style: Theme.of(context).textTheme.bodyMedium),
            for (final t in activeTasks) ...[
              TaskCard(
                task: t,
                onTap: () => context.push(Routes.taskDetailPath(t.id)),
              ),
              const SizedBox(height: 8),
            ],
            const SizedBox(height: 8),
            const SectionHeader('Recent Reports'),
            if (reports.isEmpty)
              Text('No reports yet.',
                  style: Theme.of(context).textTheme.bodyMedium),
            for (final r in reports.take(5)) ...[
              ReportCard(
                report: r,
                onTap: r.id != null
                    ? () => context.push(Routes.reportDetailPath(r.id!))
                    : null,
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}
