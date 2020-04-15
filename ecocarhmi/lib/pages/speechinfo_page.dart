import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/state_service.dart';

class SpeechInfoPage extends StatefulWidget {

  @override
  SpeechInfoPageState createState() => SpeechInfoPageState();
}

class SpeechInfoPageState extends State<SpeechInfoPage> {

  @override
  void initState() {
    super.initState();
  }

  


  int _selected = 0;
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<StateService>(context);
    bool darkTheme = appState.isDarkTheme;
    Color textColor = appState.getTextColor();
    Color backgroundColor = appState.getBackgroundColor();
    Color elevatedBackgroundColor = appState.getElevatedBackgroundColor();


    List<Widget> commands = [
      new Container(
        child: new ListView(
          children: <Widget>[
            new Text(
              "Home Page Commands",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 23,
                color: textColor
              )
            ),
            new Divider(
              height: 20,
              thickness: 2,
              color: textColor,
            ),
            new ListTile(
              isThreeLine: true,
              title: new Text(
                "Information Page",
                style: new TextStyle(
                  color: textColor
                )
              ),
              subtitle: new Text(
                "Command: Vehicle Go To Info \nAction: Goes To Information Page",
                style: new TextStyle(
                  color: textColor
                )
              ),
            ),
            new ListTile(
              isThreeLine: true,
              title: new Text(
                "Settings Page",
                style: new TextStyle(
                  color: textColor
                )
              ),
              subtitle: new Text(
                "Command: Vehicle Go To Settings \nAction: Goes To Settings Page",
                style: new TextStyle(
                  color: textColor
                )
              ),
            ),
            new ListTile(
              isThreeLine: true,
              title: new Text(
                "Help Page",
                style: new TextStyle(
                  color: textColor
                )
              ),
              subtitle: new Text(
                "Command: 'Vehicle Go To Help' or 'Help'\nAction: Goes To Help Page",
                style: new TextStyle(
                  color: textColor
                )
              ),
            ),
            new ListTile(
              isThreeLine: true,
              title: new Text(
                "Status Update",
                style: new TextStyle(
                  color: textColor
                )
              ),
              subtitle: new Text(
                "Command: Vehicle Status Update \n Action: Reads Vehicle Information",
                style: new TextStyle(
                  color: textColor
                )
              ), 
            ),
            new ListTile(
              isThreeLine: true,
              title: new Text(
                "ACC Feature",
                style: new TextStyle(
                  color: textColor
                )
              ),
              subtitle: new Text(
                "Command: 'Vehicle Activate ACC' or 'Vehicle Deactivate ACC' \n Action: Controls the status of ACC",
                style: new TextStyle(
                  color: textColor
                )
              ), 
            ),
            new ListTile(
              isThreeLine: true,
              title: new Text(
                "Interface Location",
                style: new TextStyle(
                  color: textColor
                )
              ),
              subtitle: new Text(
                "Command: What Page Am I On \n Action: Reads out the current page",
                style: new TextStyle(
                  color: textColor
                )
              ), 
            )
          ],
        ),
      ),
      new Container(
        child: new ListView(
          children: <Widget>[
            new Text(
              "Information Page Commands",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 23,
                color: textColor
              )
            ),
            new Divider(
              height: 20,
              thickness: 2,
              color: textColor,
            ),
          ],
        )
      )
    ];

    return new Scaffold(
      backgroundColor: backgroundColor,
      appBar: new AppBar(
        title: new Text(
          "Speech Commands and Actions", 
          style: new TextStyle(
            fontSize: 25,
            color: textColor
          )
        ),
        leading: new IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: textColor,
            size: 35
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
        child: new Stack(
          children: <Widget>[
            new Positioned(
              top: 20,
              left: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10
                ),
                width: 300,
                child: new ListView(
                  children: <Widget>[
                    new Card(
                      color: elevatedBackgroundColor,
                      elevation: darkTheme ? 2 : 5,
                      child: new ListTile(
                        title: new Text(
                          "Home Page Commands",
                          style: new TextStyle(
                            fontSize: 18,
                            color: textColor
                          )
                        ),
                        onTap: () {
                          setState(() {
                            _selected = 0;
                          });
                        },
                      ),
                    ),
                    new Card(
                      color: elevatedBackgroundColor,
                      elevation: darkTheme ? 2 : 5,
                      child: new ListTile(
                        title: new Text(
                          "Information Page Commands",
                          style: new TextStyle(
                            fontSize: 18,
                            color: textColor
                          )
                        ),
                        onTap: () {
                          setState(() {
                            _selected = 1;
                          });
                        },
                      )
                    ),
                    new Card(
                      color: elevatedBackgroundColor,
                      elevation: darkTheme ? 2 : 5,
                      child: new ListTile(
                        title: new Text(
                          "Settings Page Commands",
                          style: new TextStyle(
                            fontSize: 18,
                            color: textColor
                          )
                        ),
                        onTap: () {
                          setState(() {
                            _selected = 1;
                          });
                        },
                      )
                    ),
                    new Card(
                      color: elevatedBackgroundColor,
                      elevation: darkTheme ? 2 : 5,
                      child: new ListTile(
                        title: new Text(
                          "Speech Info Page Commands",
                          style: new TextStyle(
                            fontSize: 18,
                            color: textColor
                          )
                        ),
                        onTap: () {
                          setState(() {
                            _selected = 1;
                          });
                        },
                      )
                    )
                  ],
                ),
              )
            ),
            new Positioned(
              top: 20,
              right: 0,
              bottom: 0,
              child: new Container(
                width: MediaQuery.of(context).size.width - 300,
                height: MediaQuery.of(context).size.height,
                child: commands[_selected],
              )
            )
          ],
        )
      ),
    );
  }
}