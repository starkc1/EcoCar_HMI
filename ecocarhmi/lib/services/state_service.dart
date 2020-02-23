import 'package:flutter/material.dart';

class StateService with ChangeNotifier {

  bool isDarkTheme;
  setDarkTHeme(bool) async {
    isDarkTheme = bool;
    notifyListeners();
    return isDarkTheme;
  } 

  checkTimeOfDay() {
    var now = new DateTime.now();
    var time = DateTime.parse(now.toString());
    
    if (time.isBefore(DateTime.parse("08:00:00Z")) && time.isAfter(DateTime.parse("20:00:00Z"))) {
      setDarkTHeme(true);
    } else if (time.isAfter(DateTime.parse("08:00:00Z")) && time.isBefore(DateTime.parse("20:00:00Z"))) {
      setDarkTHeme(false);
    }
  }

  Color blueGrey = new Color(0xFF263238);
  Color darkColor = new Color(0xFFFAFAFA);
  Color lightColor = new Color(0xFF212121);
  getBackgroundColor() {
    if (isDarkTheme) {
      return darkColor;
    } else {
      return lightColor;
    }
  }

  getTextColor() {
    if (isDarkTheme) {
      return lightColor;
    } else {
      return darkColor;
    }
  }

}

final StateService stateService = StateService();