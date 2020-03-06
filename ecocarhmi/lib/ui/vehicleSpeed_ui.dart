import 'package:flutter/material.dart';
import 'package:flutter_gauge/flutter_gauge.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

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
    return new Container(
      padding: EdgeInsets.symmetric(
        vertical: 10
      ),
      child: new CustomPaint(
        size: Size(100, 100),
        painter: SpeedPrinter(),
      )
    );
  }
}

class SpeedPrinter extends CustomPainter {
  
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 10, 200, 200);
    final startAngle = math.pi;
    final sweepAngle = (2 * math.pi) / 2;
    final useCenter = false;
    final paint = Paint()
      ..color = new Color(0xFF00B0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
  }


  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }

}

