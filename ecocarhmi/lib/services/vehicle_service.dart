import 'package:flutter/material.dart';

class VehicleService with ChangeNotifier {

  double speed = 0.0;

  void changeSpeed(delta) {
    speed = delta;
    notifyListeners();
  }

  getSpeed() {
    return speed;
  }

  getTurnSignalColor() {

  }

}

final VehicleService vehicleService = VehicleService();