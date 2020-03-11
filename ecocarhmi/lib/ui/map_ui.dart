import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:mapbox_gl/mapbox_gl.dart';
//import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
//import 'package:location/location.dart';

import 'package:provider/provider.dart';

import '../services/state_service.dart';

class MapView extends StatefulWidget {

  @override
  MapViewState createState() => MapViewState();
}

class MapViewState extends State<MapView> {

  GoogleMapController mapController ;
  CameraPosition currentLocation = new CameraPosition(
      target: LatLng(37.0902, -95.7129),
      zoom: 5
    );

  @override
  void initState() {
    super.initState();

    currentLocation = new CameraPosition(
      target: LatLng(37.0902, -95.7129),
      zoom: 5
    );

  }
    
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<StateService>(context);
    appState.checkTimeOfDay();
    bool darkTheme = appState.isDarkTheme;
    

    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: new GoogleMap(
        compassEnabled: false,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: new CameraPosition(
          target: LatLng(37.0902, -95.7129),
          zoom: 5
        ),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
          String mapStyle;
          if (darkTheme) {
            rootBundle.loadString('assets/map_dark.txt').then(
              (string) {
                setState(() {
                  mapStyle = string;
                });
              }
            );
          } else {
            rootBundle.loadString('assets/map_light.txt').then(
              (string) {
                setState(() {
                  mapStyle = string;
                });
              }
            );
          }
          mapController.setMapStyle(mapStyle);
        },
      ),
    );
  }

  // CameraPosition currentLocation = new CameraPosition(
  //   target: LatLng(0.0, 0.0)
  // );
  // @override
  // void initState() {
  //   super.initState();
  //   currentLocation = new CameraPosition(
  //     target: LatLng(0.0, 0.0)
  //   );
  // }

  // Location location = new Location();
  // void getPosition() async {

  //   //PermissionStatus locationData = await location.hasPermission(); 
  //   LocationData locationData = await location.getLocation();
  //   setState(() {
  //     currentLocation = new CameraPosition(
  //       target: LatLng(locationData.latitude, locationData.longitude),
  //       zoom: 17.0,
  //       tilt: 45.0
  //     );
  //   });
  //   mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       currentLocation
  //     )
  //   );
  // }

  // MapboxMapController mapController;
  // void onMapCreated(MapboxMapController controller) {
  //   mapController = controller;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   final appState = Provider.of<StateService>(context);
  //   var style = appState.getMapTheme();
  //   //getPosition();
  //   return new Container(
  //     width: MediaQuery.of(context).size.width,
  //     height: MediaQuery.of(context).size.height,
  //     child: new MapboxMap(
  //       onMapCreated: onMapCreated,
  //       styleString: style,
  //       initialCameraPosition: currentLocation,
  //       gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
  //         Factory<OneSequenceGestureRecognizer>(
  //           () => EagerGestureRecognizer(),
  //         )
  //       ].toSet(),
  //     )
  //   );
  // }
}