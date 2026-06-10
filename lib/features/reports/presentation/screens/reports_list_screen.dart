import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/report_card.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../tasks/presentation/providers/task_list_provider.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../providers/report_providers.dart';

/// Reports list: workers see their own; managers see all with a worker filter.
class ReportsListScreen extends ConsumerStatefulWidget {
  const ReportsListScreen({super.key});

  @override
  ConsumerState<ReportsListScreen> createState() => _ReportsListScreenState();
}

class _ReportsListScreenState extends ConsumerState<ReportsListScreen> {
  String? _workerFilter;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value?.user;
    final isManager = user?.role.isManager ?? false;
    final userId = isManager ? _workerFilter : user?.id;
    final reportsAsync = ref.watch(reportsListProvider(userId: userId));
    final tasks = ref.watch(taskListProvider).value ?? const [];
    final taskTitles = {for (final t in tasks) t.id: t.title};
    final directory =
        isManager ? ref.watch(userDirectoryProvider).value : null;
    final workers = isManager ? ref.watch(workerOptionsProvider).value : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Column(
        children: [
          const OfflineBanner(),
          if (isManager && (workers?.isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: DropdownButtonFormField<String?>(
                initialValue: _workerFilter,
                decoration: const InputDecoration(
                  labelText: 'Worker',
                  isDense: true,
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All workers'),
                  ),
                  for (final User w in workers!)
                    DropdownMenuItem<String?>(
                      value: w.id,
                      child: Text(w.name ?? w.email),
                    ),
                ],
                onChanged: (v) => setState(() => _workerFilter = v),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => ref
                  .read(reportsListProvider(userId: userId).notifier)
                  .refresh(),
              child: reportsAsync.when(
                loading: () => const SkeletonList(),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(child: Text('Failed to load reports: $e')),
                  ],
                ),
                data: (reports) {
                  if (reports.isEmpty) {
                    return ListView(
                      children: const [
                        SizedBox(height: 60),
                        EmptyState(
                          icon: Icons.assessment_outlined,
                          title: 'No reports yet',
                          subtitle:
                              'Submitted task reports will appear here.',
                        ),
                      ],
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: reports.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final r = reports[i];
                      return ReportCard(
                        report: r,
                        taskTitle: taskTitles[r.taskId],
                        workerName: directory?[r.userId]?.name,
                        onTap: () => context.push(
                          Routes.reportDetailPath(r.id ?? r.idempotencyKey),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
