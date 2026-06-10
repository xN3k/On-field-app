import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/report_providers.dart';

class ReportFormScreen extends ConsumerStatefulWidget {
  const ReportFormScreen({required this.taskId, super.key});

  final String taskId;

  @override
  ConsumerState<ReportFormScreen> createState() => _ReportFormScreenState();
}

class _ReportFormScreenState extends ConsumerState<ReportFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();
  String _condition = 'OK';

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref.read(reportFormProvider.notifier).submit(
      taskId: widget.taskId,
      payload: {
        'condition': _condition,
        'notes': _notes.text.trim(),
      },
    );
    if (!mounted) return;
    final state = ref.read(reportFormProvider);
    if (!state.hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report queued — will sync when online')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitting = ref.watch(reportFormProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Field Report')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DropdownButtonFormField<String>(
              initialValue: _condition,
              decoration: const InputDecoration(labelText: 'Site condition'),
              items: const [
                DropdownMenuItem(value: 'OK', child: Text('OK')),
                DropdownMenuItem(value: 'NEEDS_ATTENTION', child: Text('Needs attention')),
                DropdownMenuItem(value: 'BLOCKED', child: Text('Blocked')),
              ],
              onChanged: (v) => setState(() => _condition = v ?? 'OK'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Notes',
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Enter some notes' : null,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: submitting ? null : _submit,
              child: Text(submitting ? 'Submitting…' : 'Submit report'),
            ),
          ],
        ),
      ),
    );
  }
}
