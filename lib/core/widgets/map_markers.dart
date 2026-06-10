import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../theme/app_theme.dart';

final _cache = <String, BitmapDescriptor>{};

/// Cobalt circular marker with the worker's initials. Bitmaps are cached
/// per-initials because generation is async and relatively expensive.
Future<BitmapDescriptor> initialsMarker(String initials) async {
  final cached = _cache[initials];
  if (cached != null) return cached;

  const size = 96.0;
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);

  final fill = Paint()..color = AppColors.primary;
  final border = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.stroke
    ..strokeWidth = 6;
  const center = Offset(size / 2, size / 2);
  canvas.drawCircle(center, size / 2 - 4, fill);
  canvas.drawCircle(center, size / 2 - 4, border);

  final text = TextPainter(
    text: TextSpan(
      text: initials,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 34,
        fontWeight: FontWeight.w700,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  text.paint(
    canvas,
    Offset((size - text.width) / 2, (size - text.height) / 2),
  );

  final image = await recorder
      .endRecording()
      .toImage(size.toInt(), size.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  final descriptor = BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  _cache[initials] = descriptor;
  return descriptor;
}
