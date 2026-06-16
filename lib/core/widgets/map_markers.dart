import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Cobalt circular marker with the worker's initials, rendered as a plain
/// widget for a flutter_map [MarkerLayer]. Unlike the old google_maps
/// BitmapDescriptor, this needs no async canvas work or caching.
Widget initialsMarkerWidget(String initials) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.primary,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: AppShadows.card,
    ),
    alignment: Alignment.center,
    child: Text(
      initials,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
