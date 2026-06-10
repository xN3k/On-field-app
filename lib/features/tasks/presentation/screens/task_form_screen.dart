import 'package:flutter/foundation.dart' show Factory;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_bottom_sheet.dart';
import '../../../../core/widgets/avatar_chip.dart';
import '../../../../core/widgets/map_overlays.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../users/presentation/providers/user_providers.dart';
import '../providers/task_form_provider.dart';
import '../providers/task_list_provider.dart';

/// Create (taskId == null) or edit an existing task. Manager/admin only.
class TaskFormScreen extends ConsumerStatefulWidget {
  const TaskFormScreen({this.taskId, super.key});

  final String? taskId;

  @override
  ConsumerState<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends ConsumerState<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  User? _assignee;
  LatLng? _pin;
  double _radius = 100;
  bool _seeded = false;

  bool get _isEdit => widget.taskId != null;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickWorker() async {
    final workers =
        await ref.read(workerOptionsProvider.future).catchError((_) => <User>[]);
    if (!mounted) return;
    final selected = await showAppSheet<User>(
      context,
      builder: (ctx) => _WorkerPicker(workers: workers),
    );
    if (selected != null) setState(() => _assignee = selected);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_assignee == null || _pin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_assignee == null
              ? 'Select a worker to assign this task to.'
              : 'Tap the map to set the geofence location.'),
        ),
      );
      return;
    }
    final body = {
      'title': _titleController.text.trim(),
      if (_descriptionController.text.trim().isNotEmpty)
        'description': _descriptionController.text.trim(),
      'assignedToId': _assignee!.id,
      'geofenceLat': _pin!.latitude,
      'geofenceLng': _pin!.longitude,
      'geofenceRadius': _radius.round(),
    };
    final notifier = ref.read(taskFormProvider.notifier);
    final ok = _isEdit
        ? await notifier.update(widget.taskId!, body)
        : await notifier.create(body);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEdit ? 'Task updated' : 'Task created')),
      );
      if (_isEdit) ref.invalidate(taskDetailProvider(widget.taskId!));
      context.pop();
    } else {
      final err = ref.read(taskFormProvider).error;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Save failed: $err')));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Seed fields from the existing task when editing.
    if (_isEdit && !_seeded) {
      final task = ref.watch(taskDetailProvider(widget.taskId!)).value;
      final directory = ref.watch(userDirectoryProvider).value;
      if (task != null) {
        _seeded = true;
        _titleController.text = task.title;
        _descriptionController.text = task.description ?? '';
        _assignee = directory?[task.assignedToId];
        if (task.hasGeofence) {
          _pin = LatLng(task.geofenceLat!, task.geofenceLng!);
          _radius = (task.geofenceRadius ?? 100).toDouble();
        }
      }
    }
    final saving = ref.watch(taskFormProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(_isEdit ? 'Edit Task' : 'New Task')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Task Title *'),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Text('Assign To *',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickWorker,
              borderRadius: BorderRadius.circular(AppRadius.base),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(AppRadius.base),
                  border: Border.all(color: AppColors.outlineVariant),
                ),
                child: Row(
                  children: [
                    if (_assignee != null) ...[
                      AvatarChip(
                          name: _assignee!.name ?? _assignee!.email,
                          radius: 14),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: Text(
                        _assignee?.name ??
                            _assignee?.email ??
                            'Select a worker…',
                        style: TextStyle(
                          color: _assignee == null
                              ? AppColors.outline
                              : AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Icon(Icons.expand_more,
                        color: AppColors.onSurfaceVariant),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Geofence Location *',
                style: Theme.of(context).textTheme.labelMedium),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                height: 240,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _pin ?? const LatLng(37.7749, -122.4194),
                    zoom: _pin != null ? 15 : 11,
                  ),
                  onTap: (latLng) => setState(() => _pin = latLng),
                  markers: {
                    if (_pin != null)
                      Marker(
                        markerId: const MarkerId('pin'),
                        position: _pin!,
                        draggable: true,
                        onDragEnd: (latLng) => setState(() => _pin = latLng),
                      ),
                  },
                  circles: {
                    if (_pin != null)
                      geofenceCircle(
                        id: 'pin',
                        center: _pin!,
                        radiusMeters: _radius,
                      ),
                  },
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  gestureRecognizers: {
                    Factory<OneSequenceGestureRecognizer>(
                        EagerGestureRecognizer.new),
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _pin == null
                  ? 'Tap the map to drop the geofence pin.'
                  : 'Lat ${_pin!.latitude.toStringAsFixed(5)}, '
                      'Lng ${_pin!.longitude.toStringAsFixed(5)}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text('Geofence Radius: ${_radius.round()} m',
                style: Theme.of(context).textTheme.labelMedium),
            Slider(
              value: _radius,
              min: 0,
              max: 500,
              divisions: 50,
              label: '${_radius.round()} m',
              onChanged: (v) => setState(() => _radius = v),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: saving ? null : _submit,
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(_isEdit ? 'Save Changes' : 'Create Task'),
            ),
          ],
        ),
      ),
    );
  }
}

class _WorkerPicker extends StatefulWidget {
  const _WorkerPicker({required this.workers});

  final List<User> workers;

  @override
  State<_WorkerPicker> createState() => _WorkerPickerState();
}

class _WorkerPickerState extends State<_WorkerPicker> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.workers
        .where((w) =>
            (w.name ?? w.email).toLowerCase().contains(_query.toLowerCase()))
        .toList();
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            autofocus: false,
            onChanged: (v) => setState(() => _query = v),
            decoration: const InputDecoration(
              hintText: 'Search workers…',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('No workers found.'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final w = filtered[i];
                      return ListTile(
                        leading: AvatarChip(name: w.name ?? w.email),
                        title: Text(w.name ?? w.email),
                        subtitle: Text(w.email),
                        onTap: () => Navigator.pop(context, w),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
