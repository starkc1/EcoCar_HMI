import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
//import 'package:permission_handler/permission_handler.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class MapView extends StatefulWidget {

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {

  CameraPosition currentLocation = new CameraPosition(
    target: LatLng(0.0, 0.0)
  );
  @override
  void initState() {
    super.initState();
    currentLocation = new CameraPosition(
      target: LatLng(0.0, 0.0)
    );
  }

  Location location = new Location();
  void getPosition() async {

    //PermissionStatus locationData = await location.hasPermission(); 
    LocationData locationData = await location.getLocation();
    setState(() {
      currentLocation = new CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        zoom: 17.0,
        tilt: 45.0
      );
    });
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        currentLocation
      )
    );
  }

  MapboxMapController mapController;
  void onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    getPosition();
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new MapboxMap(
        onMapCreated: onMapCreated,
        styleString: MapboxStyles.LIGHT,
        initialCameraPosition: currentLocation,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          )
        ].toSet(),
      )
    );
  }
}