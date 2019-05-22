import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_overlay/map_overlay.dart';

import 'options.dart';

class GoogleMapOverlay extends StatefulWidget {
  GoogleMapOverlay({Key key, this.mapOptions, this.overlays}) : super(key: key);
  final GoogleMapOptions mapOptions;
  final List<MapOverlayWidgetContainer> overlays;

  @override
  _GoogleMapOverlayState createState() => _GoogleMapOverlayState();
}

class _GoogleMapOverlayState extends State<GoogleMapOverlay> {
  Completer<GoogleMapController> _controller = Completer();
  StreamController<CameraPosition> _streamController =
      new StreamController<CameraPosition>();

  Widget buildOverlay(
      BuildContext context,
      AsyncSnapshot<LatLngBounds> snapshot,
      AsyncSnapshot<CameraPosition> position) {
    if (snapshot.data == null || position.data == null) return Container();

    return Stack(
      children: widget.overlays
          .map(
              (element) => element.build(context, snapshot.data, position.data)).where((item) => item != null)
          .toList(),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    if (widget.mapOptions.onMapCreated != null)
      widget.mapOptions.onMapCreated(controller);
  }

  void onCameraMove(CameraPosition position) {
    _streamController.add(position);
    if (widget.mapOptions.onCameraMove != null)
      widget.mapOptions.onCameraMove(position);
  }

  Widget buildUpdater(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (_, position) => FutureBuilder(
            future: _Extensions.mapControllerToViewRegion(_controller.future),
            builder: (context, snapshot) =>
                buildOverlay(context, snapshot, position),
          ),
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
