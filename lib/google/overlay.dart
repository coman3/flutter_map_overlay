import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_overlay/map_overlay.dart';

import 'options.dart';

class _MapUpdate {
  _MapUpdate(
    this.position,
    this.bounds,
  );

  final CameraPosition position;
  final LatLngBounds bounds;
}

class GoogleMapOverlay extends StatefulWidget {
  GoogleMapOverlay(
      {Key key, this.mapOptions, this.overlays, this.delayMilliseconds})
      : super(key: key);
  final GoogleMapOptions mapOptions;
  final List<MapOverlayWidgetContainer> overlays;

  final int delayMilliseconds;

  @override
  _GoogleMapOverlayState createState() => _GoogleMapOverlayState();
}

class _GoogleMapOverlayState extends State<GoogleMapOverlay> {
  GoogleMapController _controller;
  StreamController<_MapUpdate> _streamController =
      new StreamController<_MapUpdate>();

  Widget buildOverlay(BuildContext context, _MapUpdate update) {
    if (update == null || update.bounds == null || update.position == null)
      return Container();

    return Stack(
      children: widget.overlays
          .map((element) =>
              element.build(context, update.bounds, update.position))
          .where((item) => item != null)
          .toList(),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (widget.mapOptions.onMapCreated != null)
      widget.mapOptions.onMapCreated(controller);
  }

  void onCameraMove(CameraPosition position) async {
    var visibleRegion = await _controller.getVisibleRegion();
    Future.delayed(Duration(milliseconds: widget.delayMilliseconds)).then(
        (_) => _streamController.add(_MapUpdate(position, visibleRegion)));

    if (widget.mapOptions.onCameraMove != null)
      widget.mapOptions.onCameraMove(position);
  }

  Widget buildUpdater(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (_, update) => buildOverlay(context, update.data),
    );
  }

  Widget buildMap(BuildContext context) {
    return GoogleMap(
      onMapCreated: this.onMapCreated,
      compassEnabled: widget.mapOptions.compassEnabled,
      cameraTargetBounds: widget.mapOptions.cameraTargetBounds,
      mapType: widget.mapOptions.mapType,
      minMaxZoomPreference: widget.mapOptions.minMaxZoomPreference,
      rotateGesturesEnabled: widget.mapOptions.rotateGesturesEnabled,
      scrollGesturesEnabled: widget.mapOptions.scrollGesturesEnabled,
      zoomGesturesEnabled: widget.mapOptions.zoomGesturesEnabled,
      tiltGesturesEnabled: widget.mapOptions.tiltGesturesEnabled,
      myLocationEnabled: widget.mapOptions.myLocationEnabled,
      myLocationButtonEnabled: widget.mapOptions.myLocationButtonEnabled,
      markers: widget.mapOptions.markers,
      polylines: widget.mapOptions.polylines,
      circles: widget.mapOptions.circles,
      onCameraMoveStarted: widget.mapOptions.onCameraMoveStarted,
      onCameraMove: this.onCameraMove,
      onCameraIdle: widget.mapOptions.onCameraIdle,
      onTap: widget.mapOptions.onTap,
      initialCameraPosition: widget.mapOptions.initialCameraPosition,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        this.buildMap(context),
        this.buildUpdater(context),
      ],
    );
  }
}

class _Extensions {
  static Future<LatLngBounds> mapControllerToViewRegion(
      Future<GoogleMapController> controller) {
    return controller.then((mapController) => mapController.getVisibleRegion());
  }
}
