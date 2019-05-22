import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapOverlayWidgetContainer {
  final Offset offset;
  final LatLng position;
  final Widget child;

  MapOverlayWidgetContainer({
    @required this.child,
    @required this.position,
    @required this.offset,
  });

  Widget build(
    BuildContext context,
    LatLngBounds bounds,
    CameraPosition cameraPosition,
  ) {
    var targetNorthEast = bounds.northeast;
    var targetSouthWest = bounds.southwest;

    var diference = LatLng(targetSouthWest.latitude - targetNorthEast.latitude,
        targetSouthWest.longitude - targetNorthEast.longitude);
    var mediaQueryData = MediaQuery.of(context);
    var size = Size(
      mediaQueryData.size.width -
          (mediaQueryData.viewInsets.left + mediaQueryData.viewInsets.right),
      mediaQueryData.size.height -
          (mediaQueryData.viewInsets.top + mediaQueryData.viewInsets.bottom),
    );

    var calculatedPosition = Point(
        ((targetNorthEast.longitude - position.longitude) /
            diference.longitude),
        ((targetNorthEast.latitude - position.latitude) / -diference.latitude));
    var displayPosition = Point(
        (calculatedPosition.x * size.width + size.width) - offset.dx,
        calculatedPosition.y * size.height - offset.dy);
    if (displayPosition.y < -10 ||
        displayPosition.x < -10 ||
        displayPosition.y > size.height + 10 ||
        displayPosition.x > size.width + 10) return null;
    return Positioned(
      child: child,
      top: displayPosition.y,
      left: displayPosition.x,
    );
  }
}
