import 'package:ecocarhmi/services/vehicle_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/state_service.dart';

class VehicleSpeed extends StatefulWidget {

  @override
  VehicleSpeedState createState() => VehicleSpeedState();
}

class VehicleSpeedState extends State<VehicleSpeed> {

  @override
  Widget build(BuildContext context) {
    final vehicleState = Provider.of<VehicleService>(context);
    double speed = vehicleState.getSpeed();
    //Color turnSignalColor = vehicleState.getTurnSignalColor();

    final appState = Provider.of<StateService>(context);
    Color textColor = appState.getTextColor();
    Color handColor = appState.getTextColor();
    Color circleColor = appState.getGaugeColor();


    return new Column(
      children: <Widget>[
        new AnimatedContainer(
          duration: new Duration(milliseconds: 400),
          width: speed,
          height: 30,
          margin: EdgeInsets.symmetric(
            horizontal: 20
          ),
          decoration: BoxDecoration(
            color: circleColor
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20
          ),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Icon(
                FontAwesomeIcons.arrowLeft,
                size: 35,
              ),
              new Column(
                children: <Widget>[
                  new Text(
                    speed.toInt().toString(),
                    style: new TextStyle(
                      color: textColor,
                      fontSize: 35
                    ),
                  ),
                  new Text(
                    "MPH",
                    style: new TextStyle(
                      fontSize: 25,
                      color: textColor
                    )
                  )
                ],
              ),
              new Icon(
                FontAwesomeIcons.arrowRight,
                size: 35
              )
            ],
          ),
        )
      ],
    );
  }
}
