import 'package:flutter/material.dart';

class VehicleService with ChangeNotifier {

  double speed = 0.0;

  // void changeSpeed(delta) {
  //   speed = delta;
  //   notifyListeners();
  // }

  void updateStatus() {
    notifyListeners();
  }

  getSpeed() {
    return speed;
  }

  turnSignalStatus() {

  }

  lanePositionStatus() {

  }

  forwardProximityStatus() {

  }

}

final VehicleService vehicleService = VehicleService();