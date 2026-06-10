import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Pulsing placeholder block (no shimmer dependency).
class Skeleton extends StatefulWidget {
  const Skeleton({
    this.height = 16,
    this.width = double.infinity,
    this.radius = AppRadius.base,
    super.key,
  });

  final double height;
  final double width;
  final double radius;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
    lowerBound: 0.35,
    upperBound: 0.9,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}

/// Card-shaped skeleton used by list screens while loading.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({this.lines = 2, super.key});

  final int lines;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Skeleton(height: 18, width: 180),
            for (var i = 0; i < lines; i++) ...[
              const SizedBox(height: 10),
              Skeleton(width: i.isEven ? double.infinity : 220),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full-width column of skeleton cards.
class SkeletonList extends StatelessWidget {
  const SkeletonList({this.count = 4, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) => const SkeletonCard(),
    );
  }
}
