import 'package:ecocarhmi/services/vehicle_service.dart';
import 'package:ecocarhmi/ui/map_ui.dart';
import 'package:ecocarhmi/ui/vehicle_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../services/state_service.dart';

class MainPage extends StatefulWidget {

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {

  bool loading = true;
  @override
  void initState() {
    super.initState();
  }

  bool darkTheme = false;
  bool active = false;

  double speed = 20.0;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<StateService>(context);
    appState.checkTimeOfDay();
    Color backgroundColor = appState.getBackgroundColor();
    Color getTextColor = appState.getTextColor();
    BoxShadow sectionShadow = appState.getSectionShadow();
    Color textColor = appState.getTextColor();
    Color handColor = appState.getTextColor();
    Color circleColor = appState.getGaugeColor();

    
    final vehicleState = Provider.of<VehicleService>(context);


    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new AnimatedContainer(
        duration: new Duration(milliseconds: 600),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black26,
        child: new Stack(
          children: <Widget>[
            new MapView(),
            new AnimatedPositioned(
              left: 30,
              top: 30,
              bottom: 30,
              duration: new Duration(milliseconds: 600),
              child: new AnimatedContainer(
                padding: EdgeInsets.symmetric(
                  vertical: 10
                ),
                width: 400,
                duration: new Duration(milliseconds: 600),
                decoration: new BoxDecoration(
                  color: backgroundColor,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  boxShadow: [
                    sectionShadow
                  ]
                ),
                child: new Column(
                  children: <Widget>[
                    new VehicleSpeed(),
                  ],
                )
                //new Center(
                  // child: new GestureDetector(
                  //   child: new AspectRatio(
                  //     aspectRatio: 1,
                  //     child: new Padding(
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: 0,
                  //         horizontal: 0
                  //       ),
                  //       child: new FlareActor(
                  //         'assets/Vehicle.flr',
                  //         alignment: Alignment.center,
                  //         fit: BoxFit.contain,
                  //         animation: active ? 'MoveLeftThenBack' : 'idle',
                  //       ),
                  //     )
                  //   ),
                  //   onTap: () {
                  //     setState(() {
                  //       active = !active;
                  //     });
                  //   },
                  // ),
                //),
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
                  color: backgroundColor,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  boxShadow: [
                    sectionShadow
                  ]
                ),
                child: new Row(
                  children: <Widget>[
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
