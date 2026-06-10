import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/location_providers.dart';

/// Timeline of a worker's location pings with a path trace map.
class LocationHistoryScreen extends ConsumerWidget {
  const LocationHistoryScreen({required this.userId, super.key});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(locationHistoryProvider(userId));
    final notifier = ref.read(locationHistoryProvider(userId).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Location History')),
      body: historyAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Failed to load history: $e')),
        data: (pings) {
          if (pings.isEmpty) {
            return const EmptyState(
              icon: Icons.timeline,
              title: 'No location history',
              subtitle: 'Pings will appear once this worker is tracked.',
            );
          }
          final points = [
            for (final p in pings) LatLng(p.latitude, p.longitude),
          ];
          return Column(
            children: [
              SizedBox(
                height: 200,
                child: GoogleMap(
                  initialCameraPosition:
                      CameraPosition(target: points.first, zoom: 13),
                  polylines: {
                    Polyline(
                      polylineId: PolylineId('trace_$userId'),
                      points: points,
                      color: AppColors.primary,
                      width: 3,
                    ),
                  },
                  markers: {
                    Marker(
                      markerId: const MarkerId('latest'),
                      position: points.first,
                    ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: pings.length + 1,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    if (i == pings.length) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: TextButton(
                            onPressed: notifier.loadMore,
                            child: const Text('Load more'),
                          ),
                        ),
                      );
                    }
                    final p = pings[i];
                    return ListTile(
                      dense: true,
                      leading: const Icon(Icons.location_on_outlined,
                          color: AppColors.primary),
                      title: Text(
                        '${p.latitude.toStringAsFixed(5)}, '
                        '${p.longitude.toStringAsFixed(5)}',
                      ),
                      subtitle: Text(
                        p.timestamp != null
                            ? DateFormat.yMMMd().add_jms().format(p.timestamp!)
                            : 'Unknown time',
                      ),
                      trailing: p.accuracy != null
                          ? Text('±${p.accuracy!.round()}m',
                              style: Theme.of(context).textTheme.bodyMedium)
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
