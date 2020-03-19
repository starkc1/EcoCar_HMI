import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../services/state_service.dart';
import '../utils/feature_markdowns.dart';

class InfoPage extends StatefulWidget {

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {

  @override
  void initState() {
    super.initState();
  }

  int featureIndex = 0;
  
  

  @override 
  Widget build(BuildContext context) {
    final appState = Provider.of<StateService>(context);
    bool darkTheme = appState.isDarkTheme;
    Color textColor = appState.getTextColor();
    Color backgroundColor = appState.getBackgroundColor();
    Color elevatedBackgroundColor = appState.getElevatedBackgroundColor();

    List<Widget> features = [
      new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              left: 20
            ),
            child: new Text(
              "Adaptive Cruise Control",
              style: new TextStyle(
                fontSize: 30,
                color: textColor
              )
            ),
          ),
          new Container(
            height: 300,
            child: new FlareActor(
              'assets/Education.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'Demonstration',
            ),
          ),
          new SizedBox(
            height: 200,
            child: new Markdown(
              selectable: false,
              data: featureMarkdowns.accMarkdown,
              styleSheet: MarkdownStyleSheet(
                h2: TextStyle(
                  color: textColor,
                  fontSize: 18
                )
              ),
            ),
          )
        ],
      ),
      new Column(
        children: <Widget>[
          new Container(
            height: 300,
            child: new Text(
              "Lane Departure"
            ),
          )
        ],
      )
    ];

    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: backgroundColor,
      appBar: new AppBar(
        title: new Text(
          "Vehicle Feature Info",
          style: new TextStyle(
            fontSize: 25,
            color: textColor
          ),
        ),
        leading: IconButton(
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
        //color: Colors.red,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: new Stack(
          // mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Positioned(
              top: 20,
              left: 0,
              bottom: 0,
              child: new Container(
                //color: Colors.amberAccent,
                padding: EdgeInsets.symmetric(
                  horizontal: 10
                ),
                width: 300,
                height: MediaQuery.of(context).size.height,
                child: new ListView(
                  children: <Widget>[
                    new Card(
                      color: elevatedBackgroundColor,
                      elevation: darkTheme ? 10 : 2,
                      child: new ListTile(
                        title: new Text(
                          "ACC Features",
                          style: new TextStyle(
                            fontSize: 18,
                            color: textColor
                          ),
                        ),
                        subtitle: new Text(
                          "Adaptive Cruise Control",
                          style: new TextStyle(
                            fontSize: 16,
                            color: textColor
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            featureIndex = 0;
                          });
                        },
                      ),
                    ),
                    new Card(
                      elevation: darkTheme ? 10 : 2,
                      color: elevatedBackgroundColor,
                      child: new ListTile(
                        title: new Text(
                          "Lane Keep Features",
                          style: new TextStyle(
                            fontSize: 18,
                            color: textColor
                          )
                        ),
                        subtitle: new Text(
                          "Lane Departure Prevention",
                          style: new TextStyle(
                            fontSize: 16,
                            color: textColor
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            featureIndex = 1;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            new Positioned(
              top: 20,
              right: 0,
              bottom: 0,
              child: new Container(
                width: MediaQuery.of(context).size.width - 300,
                height: MediaQuery.of(context).size.height,
                child: features[featureIndex]
              ),
            )
            
          ],
        ),
      ),
    );
  }
}