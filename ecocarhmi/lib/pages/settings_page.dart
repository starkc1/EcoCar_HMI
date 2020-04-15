import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/state_service.dart';

class SettingsPage extends StatefulWidget {

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<StateService>(context);
    Color textColor = appState.getTextColor();
    Color backgroundColor = appState.getBackgroundColor();

    return new Scaffold(
      backgroundColor: backgroundColor,
      appBar: new AppBar(
        title: new Text(
          "Interface Settings",
          style: new TextStyle(
            fontSize: 25,
            color: textColor
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: new Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              "Vehicle",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 23,
                color: textColor
              ),
            ),
            new Divider(
              height: 20,
              thickness: 2,
              color: textColor
            ),
            new Text(
              "Speed Units",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 20,
                color: textColor
              ),
            ),
            new Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Miles Per Hour",
                    style: new TextStyle(
                      color: textColor
                    )
                  ),
                  leading: Radio(
                    value: SpeedUnits.MPH,
                    groupValue: _speedUnits,
                    onChanged: (SpeedUnits value) {
                      setState(() {
                        _speedUnits = value;
                      });
                      appState.setUnits();
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    "Kilometers Per Hour",
                    style: new TextStyle(
                      color: textColor
                    )
                  ),
                  leading: Radio(
                    value: SpeedUnits.KPH,
                    groupValue: _speedUnits,
                    onChanged: (SpeedUnits value) {
                      setState(() {
                        _speedUnits = value;
                      });
                      appState.setUnits();
                    },
                  ),
                )
              ],
            ),
            new Text(
              "Distance Units",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 20,
                color: textColor
              ),
            ),
            new Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Miles",
                    style: new TextStyle(
                      color: textColor
                    )
                  ),
                  leading: Radio(
                    value: DistanceUnits.Miles,
                    groupValue: _distanceUnits,
                    onChanged: (DistanceUnits value) {
                      setState(() {
                        _distanceUnits = value;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: Text(
                    "Kilometers",
                     style: new TextStyle(
                       color: textColor
                     )
                  ),
                  leading: Radio(
                    value: DistanceUnits.Kilometers,
                    groupValue: _distanceUnits,
                    onChanged: (DistanceUnits value) {
                      setState(() {
                        _distanceUnits = value;
                      });
                    },
                  ),
                )
              ],
            ),
            new Text(
              "Display",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 23,
                color: textColor
              ),
            ),
            new Divider(
              height: 20,
              thickness: 2,
              color: textColor
            ),
            new Text(
              "Theme",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 20,
                color: textColor
              ),
            ),
            new Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Dark Theme",
                    style: new TextStyle(
                      color: textColor
                    )
                  ),
                  leading: Switch(
                    value: _darkTheme,
                    onChanged: (bool value) {
                      appState.setDarkTheme(value);
                      setState(() {
                        _darkTheme = value;
                      });
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
bool _darkTheme = false;

DistanceUnits _distanceUnits = DistanceUnits.Miles;
enum DistanceUnits { Miles, Kilometers }

SpeedUnits _speedUnits = SpeedUnits.MPH;
enum SpeedUnits { MPH, KPH }