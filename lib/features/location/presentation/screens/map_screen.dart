import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/onfield_bottom_nav.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../providers/location_providers.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  static const _initial = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 12,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isManager =
        ref.watch(authControllerProvider).value?.user?.role.isManager ??
            false;

    final markers = <Marker>{};
    final circles = <Circle>{};

    final tasks = ref.watch(taskListProvider).value ?? const [];
    for (final t in tasks) {
      if (t.hasGeofence) {
        circles.add(
          Circle(
            circleId: CircleId('geo_${t.id}'),
            center: LatLng(t.geofenceLat!, t.geofenceLng!),
            radius: (t.geofenceRadius ?? 100).toDouble(),
            fillColor: AppColors.primary.withValues(alpha: 0.12),
            strokeColor: AppColors.primary,
            strokeWidth: 1,
          ),
        );
      }
    }

    final team = isManager
        ? (ref.watch(teamLocationsProvider).value ?? const [])
        : const [];
    for (final p in team) {
      markers.add(
        Marker(
          markerId: MarkerId('worker_${p.userId}'),
          position: LatLng(p.latitude, p.longitude),
          infoWindow: InfoWindow(title: p.name ?? p.email ?? p.userId),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, color: AppColors.onSurface),
        title: const Text('OnField'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.notifications_outlined,
                color: AppColors.primaryContainer),
          ),
        ],
      ),
      bottomNavigationBar: const OnFieldBottomNav(current: OnFieldTab.map),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initial,
            markers: markers,
            circles: circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            padding: const EdgeInsets.only(bottom: 280),
          ),
          // Floating map controls (glassmorphism feel via white tiles).
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                _mapButton(Icons.layers_outlined),
                const SizedBox(height: 16),
                _mapButtonGroup(),
                const SizedBox(height: 16),
                _mapButton(Icons.my_location, color: AppColors.primary),
              ],
            ),
          ),
          // Active workers bottom sheet.
          if (isManager)
            DraggableScrollableSheet(
              initialChildSize: 0.38,
              minChildSize: 0.18,
              maxChildSize: 0.85,
              builder: (context, controller) => _WorkersSheet(
                controller: controller,
                workers: team,
              ),
            ),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon, {Color color = AppColors.onSurface}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
        boxShadow: AppShadows.card,
      ),
      child: Icon(icon, color: color),
    );
  }

  Widget _mapButtonGroup() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.base),
        boxShadow: AppShadows.card,
      ),
      child: const Column(
        children: [
          SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.add, color: AppColors.onSurface)),
          Divider(height: 1),
          SizedBox(
              width: 48,
              height: 48,
              child: Icon(Icons.remove, color: AppColors.onSurface)),
        ],
      ),
    );
  }
}

class _WorkersSheet extends StatelessWidget {
  const _WorkersSheet({required this.controller, required this.workers});

  final ScrollController controller;
  final List<dynamic> workers;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
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
          Row(
            children: [
              Text('Active Workers (${workers.length})',
                  style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              const Icon(Icons.tune, color: AppColors.onSurfaceVariant),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          for (final p in workers) _workerCard(context, p),
          if (workers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(child: Text('No active workers.')),
            ),
        ],
      ),
    );
  }

  Widget _workerCard(BuildContext context, dynamic p) {
    final name = (p.name ?? p.email ?? p.userId).toString();
    final initials = _initials(name);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary,
            child: Text(initials,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Row(
                  children: const [
                    Icon(Icons.history, size: 14,
                        color: AppColors.onSurfaceVariant),
                    SizedBox(width: 4),
                    Text('Live position', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const Text('DETAILS',
              style: TextStyle(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ],
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.take(2).toString().toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }
}
