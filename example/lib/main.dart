import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_overlay/google/google.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int delay = 10;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.4223705, -122.0843794),
    zoom: 10.4746,
  );
  static final CameraPosition _kNearGooglePlex = CameraPosition(
    target: LatLng(37.4084642, -122.0717857),
    zoom: 14.4746,
  );
  void onFloatingPressed() {
    if (delay == 10) {
      setState(() {
        delay = 0;
      });
    } else {
      setState(() {
        delay = 10;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: GoogleMapOverlay(
        delayMilliseconds: this.delay,
        mapOptions: GoogleMapOptions(initialCameraPosition: _kGooglePlex),
        overlays: <MapOverlayWidgetContainer>[
          MapOverlayWidgetContainer(
            offset: Offset(0, 0),
            position: _kGooglePlex.target,
            child: Container(
              child: RaisedButton(
                onPressed: () => print("bob"),
                child: Text("Hello World"),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    style: BorderStyle.solid,
                    width: 1,
                    color: Colors.black,
                  )),
            ),
          ),
          MapOverlayWidgetContainer(
            offset: Offset(0, 0),
            position: _kNearGooglePlex.target,
            child: Text("Near Google Plex"),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: this.onFloatingPressed,
        child: Column(
          children: <Widget>[
            Icon(Icons.pin_drop),
            Text(delay.toString()),
          ],
        ),
      ),
    );
  }
}
