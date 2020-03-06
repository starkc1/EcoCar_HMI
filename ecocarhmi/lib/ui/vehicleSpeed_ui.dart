import 'package:flutter/material.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:provider/provider.dart';

import '../services/state_service.dart';


class VehicleSpeedView extends StatefulWidget {
  
  double speed;

  VehicleSpeedView(
    {
      this.speed
    }
  );

  @override
  VehicleSpeedViewState createState() => VehicleSpeedViewState(speed: this.speed);
}

class VehicleSpeedViewState extends State<VehicleSpeedView> {

  double speed;

  VehicleSpeedViewState(
    {
      this.speed
    }
  );

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<StateService>(context);
    Color textColor = appState.getTextColor();
    Color handColor = appState.getTextColor();
    Color backgroundColor = appState.getGaugeColor();
    print(speed);
    return new FlutterGauge(
      secondsMarker: SecondsMarker.none,
      widthCircle: 10,
      hand: Hand.short,
      circleColor: backgroundColor,
      handColor: handColor,
      number: Number.none,
      index: speed,
      fontFamily: 'Open Sans',
      counterStyle: TextStyle(
        color: textColor,
        fontSize: 45
      ),
      counterAlign: CounterAlign.center,
      isDecimal: false,
      
    );
  }
}

