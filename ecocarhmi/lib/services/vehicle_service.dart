import 'package:flutter/material.dart';

class VehicleService with ChangeNotifier {

  double speed = 0.0;

  changeSpeed(delta) {
    if (speed >= 0) {
      speed = speed + delta;
    }
    print(speed);
    return speed;
  }

  getSpeed() {
    return speed;
  }

}

final VehicleService vehicleService = VehicleService();