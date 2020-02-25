import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';


class MainPage extends StatefulWidget {

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  CameraPosition currentLocation;
  var currentLat;
  var currentLng;
  GoogleMapController mapController;
  @override
  void initState() {
    super.initState();
    _requestPermission(PermissionGroup.location);
    setState(() {
      
      currentLocation = CameraPosition(
        target: LatLng(
          0.0,
          0.0
        ),
      );
    });
    getLocation().then(
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

  Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
  Future<Position> getLocation() async {
    //Position currentLocal;
    
    Position currentLocal = await geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );

    return currentLocal;
  }

  Future<GeolocationStatus> checkPermission() async {
    GeolocationStatus status = await geolocator.checkGeolocationPermissionStatus();

    return status;
  }

  final PermissionHandler _permissionHandler = PermissionHandler();
  Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }


  bool active = false;
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
              child: new Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: new GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: currentLocation,
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                ),
              )
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
                child: new Center(
                  child: new GestureDetector(
                    child: new AspectRatio(
                      aspectRatio: 1,
                      child: new Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 0
                        ),
                        child: new FlareActor(
                          'assets/Vehicle.flr',
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: active ? 'MoveLeftThenBack' : 'idle',
                        ),
                      )
                    ),
                    onTap: () {
                      setState(() {
                        active = !active;
                      });
                    },
                  ),
                ),
                // child: new Column(
                //   children: <Widget>[
                    
                //   ],
                // ),
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
                child: new Row(
                  children: <Widget>[
                    new RaisedButton(
                      child: new Text(
                        "Test Location"
                      ),
                      onPressed: () {
                        getLocation().then(
                          (position) {
                            print(position.latitude);
                          }
                        );
                        // checkPermission().then(
                        //   (status) {
                        //     print(status);
                        //   }
                        // );
                      },
                    )
                  ],
                ),
              ), 
            ),
          ],
        )
      ),
    );
  }
}
