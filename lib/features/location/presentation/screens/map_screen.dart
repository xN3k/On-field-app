import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/location/location_permission_service.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/map_markers.dart';
import '../../../../core/widgets/map_overlays.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../../domain/entities/location_ping.dart';
import '../providers/location_providers.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const _initialCenter = LatLng(37.7749, -122.4194);

  final _mapController = MapController();

  @override
  void initState() {
    super.initState();
    // Request foreground location up front so the recenter button works and
    // the team seed can use the device position.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) LocationPermissionService.ensureForeground(context);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _recenter() async {
    if (!await LocationPermissionService.ensureForeground(context)) return;
    try {
      final pos = await Geolocator.getCurrentPosition();
      _mapController.move(LatLng(pos.latitude, pos.longitude), 15);
    } catch (_) {
      // Position unavailable — leave the camera where it is.
    }
  }

  void _showWorkerSheet(LocationPing ping) {
    final tasks = ref.read(taskListProvider).value ?? const <Task>[];
    final currentTask = tasks
        .where((t) =>
            t.assignedToId == ping.userId &&
            t.status != TaskStatus.completed)
        .firstOrNull;
    final name = ping.name ?? ping.email ?? ping.userId ?? 'Worker';

    showAppSheet<void>(
      context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarChip(name: name, online: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: Theme.of(ctx).textTheme.titleMedium),
                      Text(
                        ping.timestamp != null
                            ? 'Last seen ${DateFormat.jm().format(ping.timestamp!)}'
                            : 'Live position',
                        style: Theme.of(ctx).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (currentTask != null)
              Card(
                child: ListTile(
                  dense: true,
                  title: Text(currentTask.title,
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: StatusBadge(currentTask.status),
                  onTap: () {
                    Navigator.pop(ctx);
                    context.push(Routes.taskDetailPath(currentTask.id));
                  },
                ),
              )
            else
              Text('No active task.',
                  style: Theme.of(ctx).textTheme.bodyMedium),
            const SizedBox(height: 16),
            if (ping.userId != null)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context
                            .push(Routes.workerProfilePath(ping.userId!));
                      },
                      child: const Text('View Profile'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        context.push(
                            Routes.locationHistoryPath(ping.userId!));
                      },
                      child: const Text('History'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isManager =
        ref.watch(authControllerProvider).value?.user?.role.isManager ?? false;
    final radiusFilter = ref.watch(mapRadiusFilterProvider);
    final directory = ref.watch(userDirectoryProvider).value ?? const {};

    final markers = <Marker>[];
    final circles = <CircleMarker>[];

    final tasks = ref.watch(taskListProvider).value ?? const <Task>[];
    for (final t in tasks.where((t) => t.hasGeofence)) {
      final center = LatLng(t.geofenceLat!, t.geofenceLng!);
      final radius = (t.geofenceRadius ?? 100).toDouble();
      circles.add(geofenceCircle(center: center, radiusMeters: radius));
    }

    final team = isManager
        ? (ref.watch(teamLocationsProvider).value ?? const <LocationPing>[])
        : const <LocationPing>[];
    for (final p in team) {
      final userId = p.userId;
      if (userId == null) continue;
      final name =
          p.name ?? directory[userId]?.name ?? p.email ?? userId;
      markers.add(
        Marker(
          point: LatLng(p.latitude, p.longitude),
          width: 44,
          height: 44,
          child: GestureDetector(
            onTap: () => _showWorkerSheet(p),
            child: initialsMarkerWidget(AvatarChip.initialsOf(name)),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Map'),
        actions: [
          IconButton(
            tooltip: 'Refresh locations',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(teamLocationsProvider),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'map_recenter',
        onPressed: _recenter,
        child: const Icon(Icons.my_location),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _initialCenter,
              initialZoom: 12,
            ),
            children: [
              osmTileLayer(),
              CircleLayer(circles: circles),
              MarkerLayer(markers: markers),
              osmAttribution(),
            ],
          ),
          if (isManager)
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final (label, meters) in const [
                      ('Within 1km', 1000.0),
                      ('Within 5km', 5000.0),
                      ('All', null),
                    ])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(label),
                          selected: radiusFilter == meters,
                          showCheckmark: false,
                          backgroundColor: AppColors.surfaceContainerLowest,
                          selectedColor: AppColors.primary,
                          labelStyle: TextStyle(
                            color: radiusFilter == meters
                                ? Colors.white
                                : AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                          onSelected: (_) => ref
                              .read(mapRadiusFilterProvider.notifier)
                              .set(meters),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          if (isManager)
            DraggableScrollableSheet(
              initialChildSize: 0.3,
              minChildSize: 0.12,
              maxChildSize: 0.85,
              builder: (context, controller) => _WorkersSheet(
                controller: controller,
                workers: team,
                onTapWorker: _showWorkerSheet,
              ),
            ),
        ],
      ),
    );
  }
}

class _WorkersSheet extends StatelessWidget {
  const _WorkersSheet({
    required this.controller,
    required this.workers,
    required this.onTapWorker,
  });

  final ScrollController controller;
  final List<LocationPing> workers;
  final ValueChanged<LocationPing> onTapWorker;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        boxShadow: AppShadows.elevated,
      ),
      child: ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.outlineVariant,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Active Workers (${workers.length})',
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          for (final p in workers)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: AvatarChip(
                    name: p.name ?? p.email ?? p.userId, online: true),
                title: Text(p.name ?? p.email ?? p.userId ?? 'Worker'),
                subtitle: Text(
                  p.timestamp != null
                      ? 'Last seen ${DateFormat.jm().format(p.timestamp!)}'
                      : 'Live position',
                ),
                trailing: const Text(
                  'DETAILS',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                onTap: () => onTapWorker(p),
              ),
            ),
          if (workers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('No active workers.')),
            ),
        ],
      ),
    );
  }
}
