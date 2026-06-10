import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cobalt initials circle with optional green online indicator dot.
class AvatarChip extends StatelessWidget {
  const AvatarChip({
    required this.name,
    this.online,
    this.radius = 20,
    super.key,
  });

  final String? name;
  final bool? online;
  final double radius;

  static String initialsOf(String? name) {
    final parts = (name ?? '').trim().split(RegExp(r'\s+'))
      ..removeWhere((p) => p.isEmpty);
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary,
      child: Text(
        initialsOf(name),
        style: TextStyle(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w700,
          fontSize: radius * 0.75,
        ),
      ),
    );
    if (online == null) return avatar;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        avatar,
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: radius * 0.55,
            height: radius * 0.55,
            decoration: BoxDecoration(
              color: online! ? AppColors.success : AppColors.pendingGray,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.surfaceContainerLowest,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
