import 'package:flutter_test/flutter_test.dart';

import 'package:onfield/core/location/geofence_helper.dart';

void main() {
  group('GeofenceHelper', () {
    test('reports a point at the center as inside', () {
      expect(
        GeofenceHelper.isInside(37.7749, -122.4194, 37.7749, -122.4194, 100),
        isTrue,
      );
    });

    test('reports a far point as outside', () {
      // ~1.4km north, radius 100m -> outside.
      expect(
        GeofenceHelper.isInside(37.7875, -122.4194, 37.7749, -122.4194, 100),
        isFalse,
      );
    });

    test('distance between identical points is zero', () {
      expect(
        GeofenceHelper.distanceMeters(10, 10, 10, 10),
        closeTo(0, 0.001),
      );
    });
  });
}
