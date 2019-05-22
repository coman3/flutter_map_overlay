# flutter_map_overlay
A simple to use widget based map overlay plugin for flutter.

# WARNING: In very early Development
This plugin was only just started, and therefor **SHOULD NOT BE USED IN PRODUCTION**. 
There will be breaking API changes.


# Planned Features
 - [ ] Support for other maping platforms (such as MapBox or Bing Maps)
	- I'd like to see a unified API that supports it all but it may not be possible / feasible
 - [ ] Support for Pan and Tilt operations (curently disabled)
 - [ ] Support for either 'Ground Plane' or 'Upright Plane' display modes 
	- Ground Plane will be like a sticker on top of the map
	- Upright Plane will be like a 'building' that stands upright and faces the screen at all times
 - [ ] Implement a custom gesture controller to ensure that the widgets move at the same speed as the map
	- The controller will override the google maps gesture controlls for a smoother pan speed

---

## Usage as of (22/05/2019)
```dart

GoogleMapOverlay(
	mapOptions: GoogleMapOptions(
		initialCameraPosition: _kGooglePlex,
		// Your typical google map options here (will pass through all events - even if used)
	), 
	overlays: <MapOverlayWidgetContainer>[
		// All widgets you wish to display on the map (they must have some form of default size)
		MapOverlayWidgetContainer(
			offset: Offset(50, 15),
			position: LatLng(37.4223705, -122.0843794),
			child: SizedBox(
				child: Container(
				    child: Text("Google Plex"),
				    decoration: BoxDecoration(
					    color: Colors.white,
					    border: Border.all(
						    style: BorderStyle.solid,
							width: 1,
							color: Colors.black,
					    ),
					),
				),
				width: 100,
				height: 30
			),
		),
		MapOverlayWidgetContainer(
			offset: Offset(0, 0),
			position: LatLng(37.4084642, -122.0717857),
			child: Text("Near Google Plex"),
		)
	],
)

```
