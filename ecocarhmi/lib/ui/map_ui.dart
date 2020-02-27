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

  @override
  void initState() {
    super.initState();

  }

  Location location = new Location();
  getPosition() async {

    //PermissionStatus locationData = await location.hasPermission(); 
    LocationData locationData = await location.getLocation();
    return locationData;
    // await Geolocator().getCurrentPosition(
    //           desiredAccuracy: 
    //         ).then(
    //           (result) {
                
    //             print(result);
    //             return result;
    //           }
    //         ).catchError(
    //           (error) {
    //             print(error);
    //           }
    //         );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: new Center(
        child: new RaisedButton(
          child: new Text(
            "Test"
          ),
          onPressed: () {
            getPosition().then(
              (result) {
                print(result);
              }
            );
          },
        )
      )
      
      
      // child: new GoogleMap(
      //   mapType: MapType.hybrid,
      //   initialCameraPosition: currentLocation,
      //   onMapCreated: (GoogleMapController controller) {
      //     mapController = controller;
      //   },
      // ),
    );
  }
}