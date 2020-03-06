import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class StateService with ChangeNotifier {

  bool isDarkTheme = false;
  setDarkTheme(value) async {
    isDarkTheme = value;
    notifyListeners();
    return isDarkTheme;
  } 

  checkTimeOfDay() {
    var now = new DateTime.now();
    var time = DateTime.parse(now.toString());
    var sunrise = DateTime(now.year, now.month, now.day, 08, 00);
    var sunset = DateTime(now.year, now.month, now.day, 20, 00);
    if (time.isBefore(sunrise) || time.isAfter(sunset)) {
      setDarkTheme(true);
      //print("true");
    } else if (time.isAfter(sunrise) || time.isBefore(sunset)) {
      setDarkTheme(false);
      //print("false");
    }
  }

  Color blueGrey = new Color(0xFF263238);
  Color darkColor = new Color(0xFF212121);
  Color lightColor = new Color(0xFFFAFAFA);
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

  getMapTheme() {
    if (isDarkTheme) {
      return MapboxStyles.DARK;
    } else {
      return MapboxStyles.LIGHT;
    }
  }

  getGaugeColor() {
    if (isDarkTheme) {
      return new Color(0xFF01579B);
    } else {
      return new Color(0xFF00B0FF);
    } 
  }

  getSectionShadow() {
    if (isDarkTheme) {
      return new BoxShadow(
        blurRadius: 0,
        color: Colors.transparent
      );
    } else {
      return new BoxShadow(
        blurRadius: 10,
        color: Colors.black26
      );
    }
  }

}

final StateService stateService = StateService();