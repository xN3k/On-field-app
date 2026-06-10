import 'package:flutter/material.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../domain/entities/task.dart';

export '../../../../core/widgets/status_badge.dart' show Pill;

/// Legacy alias — prefer [StatusBadge] from core/widgets.
class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});

  final TaskStatus status;

  @override
  Widget build(BuildContext context) => StatusBadge(status);
}
