import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ecocarhmi/services/eye_service.dart';

import '../services/eye_service.dart';

class MainPage extends StatefulWidget {

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  CameraPosition currentLocation;
  var currentLat;
  var currentLng;

  var eyeService = EyeService();
  bool eyesOpen;
  @override
  void initState() {
    super.initState();
    _requestPermission(PermissionGroup.location);
    _requestPermission(PermissionGroup.camera);
    setState(() {
      currentLocation = CameraPosition(
        target: LatLng(
          37.0902,
          -95.7192
        ),
        zoom: 5
      );
      eyesOpen = eyeService.getEyeStatus() as bool;
    });
    _getLocation().then(
      (position) {
        print(position);
        mapController.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                position.latitude,
                position.longitude
              ),
              zoom: 13.5
            )
          )
        );
      }
    );

  }

  Geolocator geolocator = Geolocator();
  Future<Position> _getLocation() async {
    var currentLocal;

    try {
      currentLocal = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation
      );
    } catch (e) {
      currentLocal = null;
    }
    print(currentLocal);

    return currentLocal;
  }

  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  MapboxMapController mapController;
  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new AnimatedContainer(
        duration: new Duration(milliseconds: 600),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black26,
        child: new Stack(
          children: <Widget>[
            new AnimatedPositioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              duration: new Duration(milliseconds: 600),
              child: new MapboxMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: currentLocation
              ),
            ),
            new AnimatedPositioned(
              left: 30,
              top: 30,
              bottom: 30,
              duration: new Duration(milliseconds: 600),
              child: new AnimatedContainer(
                width: 400,
                duration: new Duration(milliseconds: 600),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  boxShadow: [
                    new BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26
                    )
                  ]
                ),
                child: new Column(
                  
                ),
              ),
            ),
            new AnimatedPositioned(
              duration: new Duration(milliseconds: 600),
              bottom: 30,
              left: 450,
              right: 30,
              child: new AnimatedContainer(
                height: 75,
                duration: new Duration(milliseconds: 600),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  boxShadow: [
                    new BoxShadow(
                      blurRadius: 10,
                      color: Colors.black26
                    )
                  ]
                ),
                child: new Text(eyesOpen.toString(), textScaleFactor: 3,)
              ), 
            ),
          ],
        )
      ),
    );
  }
}
