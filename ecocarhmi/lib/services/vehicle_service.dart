import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class VehicleService with ChangeNotifier {

  bool accActive = true;

  Future<String> _loadAsset() async {
    return await rootBundle.loadString('assets/hmi_input.json');
  }

  Future<String> loadData() async {
    return await _loadAsset();
  }

  void changeACCStatus() {
    accActive = !accActive;
  }



}

final VehicleService vehicleService = VehicleService();