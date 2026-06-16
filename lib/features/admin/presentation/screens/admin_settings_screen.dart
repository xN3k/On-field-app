import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/di/core_providers.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';

/// Admin shortcuts + system status. Admin only.
class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() =>
      _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  bool? _healthy;
  int? _latencyMs;

  @override
  void initState() {
    super.initState();
    _checkHealth();
  }

  Future<void> _checkHealth() async {
    final dio = ref.read(dioProvider);
    final stopwatch = Stopwatch()..start();
    try {
      await dio.get<dynamic>(ApiConstants.me);
      stopwatch.stop();
      if (mounted) {
        setState(() {
          _healthy = true;
          _latencyMs = stopwatch.elapsedMilliseconds;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _healthy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Panel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: const Text('Users'),
                  subtitle: const Text('Manage roles and accounts'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => GoRouter.of(context).go(Routes.team),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Create Account'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(Routes.register),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.assignment_outlined),
                  title: const Text('All Tasks'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => GoRouter.of(context).go(Routes.tasks),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.assessment_outlined),
                  title: const Text('All Reports'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => GoRouter.of(context).go(Routes.reports),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: Icon(
                _healthy == null
                    ? Icons.cloud_outlined
                    : _healthy!
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                color: _healthy == null
                    ? context.colors.onSurfaceVariant
                    : _healthy!
                        ? AppColors.success
                        : AppColors.error,
              ),
              title: const Text('System status'),
              subtitle: Text(
                _healthy == null
                    ? 'Checking…'
                    : _healthy!
                        ? 'API reachable • ${_latencyMs}ms'
                        : 'API unreachable',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _checkHealth,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
