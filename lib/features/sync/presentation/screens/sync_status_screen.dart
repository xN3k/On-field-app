import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/sync/sync_batch_status.dart';
import '../../../../core/sync/sync_coordinator.dart';
import '../../../../core/sync/sync_status_providers.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../reports/presentation/providers/report_providers.dart';

/// Offline queue + sync batch status overview.
class SyncStatusScreen extends ConsumerWidget {
  const SyncStatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingReports = ref.watch(pendingReportCountProvider);
    final batchesAsync = ref.watch(syncBatchesProvider);
    final batches = batchesAsync.value ?? const <SyncBatchStatus>[];
    final allSynced = pendingReports == 0 && batchesAsync.hasValue;

    return Scaffold(
      appBar: AppBar(title: const Text('Sync Status')),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(syncBatchesProvider.notifier).refresh(),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          label: 'Reports queued',
                          value: '$pendingReports',
                          icon: Icons.description_outlined,
                          color: pendingReports > 0
                              ? AppColors.warning
                              : AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text('Recent Batches',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  if (batchesAsync.isLoading)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ))
                  else if (batches.isEmpty && allSynced)
                    const EmptyState(
                      icon: Icons.check_circle_outline,
                      title: 'All synced',
                      subtitle: 'Nothing waiting to upload.',
                    )
                  else
                    for (final b in batches) ...[
                      _BatchCard(batch: b),
                      const SizedBox(height: 8),
                    ],
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: FilledButton.icon(
                icon: const Icon(Icons.sync),
                label: const Text('Sync Now'),
                onPressed: () async {
                  await ref
                      .read(syncCoordinatorProvider.notifier)
                      .syncNow();
                  ref.read(syncBatchesProvider.notifier).refresh();
                  if (context.mounted) {
                    AppToast.success(context, 'Sync triggered',
                        message: 'Your queued data is being uploaded.');
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BatchCard extends ConsumerWidget {
  const _BatchCard({required this.batch});

  final SyncBatchStatus batch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (bg, fg) = switch (batch.status) {
      'COMPLETED' => (
          context.colors.successContainer,
          context.colors.onSuccessContainer
        ),
      'FAILED' => (context.colors.errorContainer, context.colors.onErrorContainer),
      'PROCESSING' => (context.colors.infoContainer, AppColors.primary),
      _ => (context.colors.surfaceContainerHigh, context.colors.onSurfaceVariant),
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Batch ${batch.id.substring(0, batch.id.length.clamp(0, 8))}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Pill(label: batch.status, background: bg, foreground: fg),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${batch.processedCount}/${batch.itemCount} processed'
              '${batch.failedCount > 0 ? ' • ${batch.failedCount} failed' : ''}'
              '${batch.createdAt != null ? ' • ${DateFormat.MMMd().add_jm().format(batch.createdAt!)}' : ''}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (batch.error != null) ...[
              const SizedBox(height: 4),
              Text(batch.error!,
                  style: const TextStyle(
                      color: AppColors.error, fontSize: 12)),
            ],
            if (batch.status == 'FAILED') ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                onPressed: () async {
                  await ref
                      .read(syncCoordinatorProvider.notifier)
                      .syncNow();
                  ref.read(syncBatchesProvider.notifier).refresh();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
