import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/location/geofence_helper.dart';
import '../../../../core/location/location_permission_service.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/map_overlays.dart';
import '../../../../core/widgets/report_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../reports/presentation/providers/report_providers.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../../domain/entities/task.dart';
import '../providers/task_form_provider.dart';
import '../providers/task_list_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({required this.taskId, super.key});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskAsync = ref.watch(taskDetailProvider(taskId));
    final isManager =
        ref.watch(authControllerProvider).value?.user?.role.isManager ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          if (isManager)
            PopupMenuButton<String>(
              onSelected: (action) async {
                switch (action) {
                  case 'edit':
                    context.push(Routes.taskEditPath(taskId));
                  case 'reassign':
                    context.push(Routes.taskReassignPath(taskId));
                  case 'delete':
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Delete task?'),
                        content: const Text(
                            'This permanently removes the task and cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: AppColors.error),
                            onPressed: () => Navigator.pop(ctx, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true &&
                        await ref.read(taskFormProvider.notifier).delete(taskId) &&
                        context.mounted) {
                      context.pop();
                    }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit Task')),
                PopupMenuItem(value: 'reassign', child: Text('Reassign')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
        ],
      ),
      body: taskAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (task) => _TaskBody(task: task),
      ),
      bottomNavigationBar: taskAsync.maybeWhen(
        data: (task) =>
            isManager ? _ManagerActions(task: task) : _WorkerAction(task: task),
        orElse: () => null,
      ),
    );
  }
}

class _WorkerAction extends ConsumerWidget {
  const _WorkerAction({required this.task});

  final Task task;

  static const _nextStatus = {
    TaskStatus.pending: TaskStatus.inProgress,
    TaskStatus.inProgress: TaskStatus.completed,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = _nextStatus[task.status];
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            if (task.status == TaskStatus.inProgress) ...[
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.description_outlined),
                  label: const Text('Add Report'),
                  onPressed: () => context.push(Routes.reportFormPath(task.id)),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: next == null
                  ? OutlinedButton.icon(
                      icon: const Icon(Icons.description_outlined),
                      label: const Text('Add Report'),
                      onPressed: () =>
                          context.push(Routes.reportFormPath(task.id)),
                    )
                  : FilledButton.icon(
                      icon: Icon(next == TaskStatus.completed
                          ? Icons.check_circle_outline
                          : Icons.play_arrow),
                      label: Text(next == TaskStatus.completed
                          ? 'Mark Complete'
                          : 'Start Task'),
                      onPressed: () async {
                        await ref
                            .read(taskListProvider.notifier)
                            .updateStatus(task.id, next);
                        ref.invalidate(taskDetailProvider(task.id));
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ManagerActions extends StatelessWidget {
  const _ManagerActions({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit Task'),
                onPressed: () => context.push(Routes.taskEditPath(task.id)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.swap_horiz),
                label: const Text('Reassign'),
                onPressed: () =>
                    context.push(Routes.taskReassignPath(task.id)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskBody extends ConsumerWidget {
  const _TaskBody({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final directory = ref.watch(userDirectoryProvider).value ?? const {};
    final assignee = directory[task.assignedToId];
    final reportsAsync =
        ref.watch(reportsListProvider(taskId: task.id));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _card(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 22),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AvatarChip(
                    name: assignee?.name ?? assignee?.email,
                    radius: 14,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      assignee?.name ?? assignee?.email ?? 'Assigned worker',
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  StatusBadge(task.status),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        if (task.hasGeofence) ...[
          _GeofenceMap(task: task),
          const SizedBox(height: 16),
        ],

        Row(
          children: [
            Expanded(
              child: _infoTile(
                context,
                icon: Icons.event_outlined,
                label: 'ASSIGNED',
                value:
                    task.createdAt != null ? _fmtDate(task.createdAt!) : '—',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _infoTile(
                context,
                icon: Icons.route_outlined,
                label: 'RADIUS',
                value: task.geofenceRadius != null
                    ? '${task.geofenceRadius} m'
                    : '—',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (task.hasGeofence)
          _infoTile(
            context,
            icon: Icons.location_on_outlined,
            label: 'LOCATION',
            value: '${task.geofenceLat!.toStringAsFixed(5)}, '
                '${task.geofenceLng!.toStringAsFixed(5)}',
          ),
        const SizedBox(height: 16),

        if (task.description != null) ...[
          _card(
            context,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionLabel(context, 'DESCRIPTION'),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 12),
                Text(
                  task.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        _card(
          context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel(context, 'REPORTS'),
              const SizedBox(height: 12),
              ...reportsAsync.when(
                loading: () => const [LinearProgressIndicator()],
                error: (e, _) => [Text('Failed to load reports: $e')],
                data: (reports) => reports.isEmpty
                    ? [
                        Text('No reports submitted for this task yet.',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ]
                    : [
                        for (final r in reports) ...[
                          ReportCard(
                            report: r,
                            taskTitle: task.title,
                            onTap: r.id != null
                                ? () => context
                                    .push(Routes.reportDetailPath(r.id!))
                                : null,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(BuildContext context, String text) => Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: context.colors.onSurfaceVariant,
        ),
      );

  Widget _infoTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Icon(icon, color: context.colors.onSurfaceVariant),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                color: context.colors.onSurfaceVariant,
              )),
          const SizedBox(height: 4),
          Text(value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: context.colors.onSurface,
              )),
        ],
      ),
    );
  }

  Widget _card(BuildContext context, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: context.colors.border),
        boxShadow: AppShadows.card,
      ),
      child: child,
    );
  }

  static String _fmtDate(DateTime d) {
    final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final ampm = d.hour < 12 ? 'AM' : 'PM';
    final m = d.minute.toString().padLeft(2, '0');
    return '${d.month}/${d.day}, $h:$m $ampm';
  }
}

/// Mini-map with the geofence overlay and an inside/outside-zone chip.
class _GeofenceMap extends StatefulWidget {
  const _GeofenceMap({required this.task});

  final Task task;

  @override
  State<_GeofenceMap> createState() => _GeofenceMapState();
}

class _GeofenceMapState extends State<_GeofenceMap> {
  bool? _inside;

  @override
  void initState() {
    super.initState();
    _checkZone();
  }

  Future<void> _checkZone() async {
    try {
      if (!await LocationPermissionService.ensureForeground(context)) return;
      if (!mounted) return;
      final pos = await Geolocator.getLastKnownPosition() ??
          await Geolocator.getCurrentPosition();
      if (!mounted) return;
      setState(() {
        _inside = GeofenceHelper.isInside(
          pos.latitude,
          pos.longitude,
          widget.task.geofenceLat!,
          widget.task.geofenceLng!,
          widget.task.geofenceRadius ?? 100,
        );
      });
    } catch (_) {
      // Location unavailable — leave the chip hidden.
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;
    final center = LatLng(task.geofenceLat!, task.geofenceLng!);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: SizedBox(
        height: 220,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 15,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.none),
              ),
              children: [
                osmTileLayer(),
                CircleLayer(
                  circles: [
                    geofenceCircle(
                      center: center,
                      radiusMeters: (task.geofenceRadius ?? 100).toDouble(),
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: center,
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
            if (_inside != null)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _inside!
                        ? context.colors.successContainer
                        : context.colors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    _inside! ? 'Inside zone ✓' : 'Outside zone',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _inside!
                          ? context.colors.onSuccessContainer
                          : context.colors.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
