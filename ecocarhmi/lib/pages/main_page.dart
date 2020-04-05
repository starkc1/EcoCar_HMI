import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ecocarhmi/pages/info_page.dart';
import 'package:ecocarhmi/pages/settings_page.dart';
import 'package:ecocarhmi/services/eye_service.dart';
import 'package:ecocarhmi/services/vehicle_service.dart';
import 'package:ecocarhmi/ui/map_ui.dart';
import 'package:ecocarhmi/ui/vehicle_ui.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

import '../services/state_service.dart';

class MainPage extends StatefulWidget {

  final camera;

  MainPage(
    {
      Key key,
      @required this.camera
    }
  ) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  EyeService eyeService = EyeService();

  bool loading = true;
  
  
  
  SpeechToText speech = SpeechToText();
  @override
  void initState() {
    super.initState();

    


    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high
    );

    _initializeControllerFuture = _controller.initialize();
  }

  takePeriodicPicture() async {
    await _initializeControllerFuture;
    const period = const Duration(seconds: 7);

    new Timer(
      period,
      () => takePicture(_controller).then(
        (result) {
          eyeService.processImage(result).then(
            (faces) {
              processFaces(faces);
            }
          );
        }
      )
    );

  }

  processFaces(List<Face> faces) {
    print(faces.length);
    for (Face face in faces) {
      eyeService.checkEyes(face).then(
        (result) {
          print(result);
          if (!result) {
            Scaffold.of(scaffoldContext).showSnackBar(
              new SnackBar(
                content: new Text(
                  "Please Open Your Eyes And Pay Attention To The Road!",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 30
                  ),
                ),
                backgroundColor: Colors.redAccent,
                duration: new Duration(seconds: 2),
              )
            );
          }
        }
      );



      eyeService.checkHeadRotationX(face).then(
        (result) {
          print(result);
          if (!result) {
            Scaffold.of(scaffoldContext).showSnackBar(
              new SnackBar(
                content: new Text(
                  "Please Look Straight Ahead And Pay Attention To The Road!",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 30
                  ),
                ),
                backgroundColor: Colors.redAccent,
                duration: new Duration(seconds: 2),
              )
            );
          }
        }
      );

      eyeService.checkHeadRotationY(face).then(
        (result) {
          print(result);
          Scaffold.of(scaffoldContext).showSnackBar(
            new SnackBar(
              content: new Text(
                "Please Look Straight Ahead And Pay Attention To The Road!",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 30
                )
              ),
              backgroundColor: Colors.redAccent,
              duration: new Duration(seconds: 2)
            )
          );
        }
      )
    }
  }

  setupSpeech() async {
    bool available = await speech.initialize(
      onStatus: statusListener,
      onError: errorListener
    );

    if (available) {}
  }

  void statusListener(String status) {

  }

  void errorListener(SpeechRecognitionError error) {

  }

  ImageCache imageCache = ImageCache();

  takePicture(CameraController camera) async {

    final path = join(
      (await getTemporaryDirectory()).path,
      'image.png'
      //'${DateTime.now()}.png'
    );
    final dir = Directory(path);
    try {
      await camera.takePicture(path);
    } catch (e) {
      dir.deleteSync(recursive: true);
    }
    
    takePeriodicPicture();
    return path;    
  }

  bool eyesOpen;
  // void _eyeNotifier(context) {
  //   if (!eyesOpen) {
  //     Scaffold.of(context).showSnackBar(snackbar)
  //   }
  // }


  bool darkTheme = false;
  bool active = false;
  var prevPath;
  double speed = 20.0;

  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    takePeriodicPicture();
    final appState = Provider.of<StateService>(context);
    appState.checkTimeOfDay();
    Color backgroundColor = appState.getBackgroundColor();
    Color getTextColor = appState.getTextColor();
    BoxShadow sectionShadow = appState.getSectionShadow();
    Color textColor = appState.getTextColor();
    Color handColor = appState.getTextColor();
    Color circleColor = appState.getGaugeColor();

    
    final vehicleState = Provider.of<VehicleService>(context);

    

    final eyeState = Provider.of<EyeService>(context);
    eyesOpen = eyeState.areEyesOpen();
    
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new AnimatedContainer(
        duration: new Duration(milliseconds: 600),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black26,
        child: new Stack(
          children: <Widget>[
            //new MapView(),
            new Builder(
              builder: (BuildContext context) {
                scaffoldContext = context;
                return new SizedBox();
              },
            ),
            new AnimatedPositioned(
              left: 30,
              top: 30,
              bottom: 30,
              duration: new Duration(milliseconds: 600),
              child: new AnimatedContainer(
                padding: EdgeInsets.symmetric(
                  vertical: 10
                ),
                width: 400,
                duration: new Duration(milliseconds: 600),
                decoration: new BoxDecoration(
                  color: backgroundColor,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  boxShadow: [
                    sectionShadow
                  ]
                ),
                child: new Stack(
                  children: <Widget>[
                    new Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: new VehicleSpeed()
                    ),
                    new Positioned(
                      top: 120,
                      left: 0,
                      right: 0,
                      child: new AspectRatio(
                        aspectRatio: 2.5,
                        child: new Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0
                          ),
                          child: new FlareActor(
                            'assets/Proximity.flr',
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            animation: "Approaching_Level1",
                          ),
                        ),
                      ),
                    ),
                    new Positioned(
                      top: 200,
                      left: 0,
                      right: 0,
                      child: new AspectRatio(
                        aspectRatio: .85,
                        child: new Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 0
                          ),
                          child: new FlareActor(
                              'assets/Vehicle.flr',
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              animation: "Driving",
                            ),
                          ),
                        ),
                    )
                  ],
                ),
                
                //new Center(
                  // child: new GestureDetector(
                  //   child: new AspectRatio(
                  //     aspectRatio: 1,
                  //     child: new Padding(
                  //       padding: EdgeInsets.symmetric(
                  //         vertical: 0,
                  //         horizontal: 0
                  //       ),
                  //       child: new FlareActor(
                  //         'assets/Vehicle.flr',
                  //         alignment: Alignment.center,
                  //         fit: BoxFit.contain,
                  //         animation: active ? 'MoveLeftThenBack' : 'idle',
                  //       ),
                  //     )
                  //   ),
                  //   onTap: () {
                  //     setState(() {
                  //       active = !active;
                  //     });
                  //   },
                  // ),
                //),
              ),
            ),
            new AnimatedPositioned(
              duration: new Duration(milliseconds: 600),
              bottom: 30,
              left: 450,
              right: 30,
              child: new AnimatedContainer(
                height: 100,
                duration: new Duration(milliseconds: 600),
                decoration: new BoxDecoration(
                  color: backgroundColor,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  boxShadow: [
                    sectionShadow
                  ]
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 15
                ),
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 75,
                      color: backgroundColor,
                      child: new Material(
                        borderRadius: new BorderRadius.all(
                          Radius.circular(40)
                        ),
                        color: backgroundColor,
                        // clipBehavior: Clip.antiAlias,
                        child: new IconButton(
                          icon: Icon(
                            Icons.directions,
                            size: 45,
                            color: textColor,
                          ),
                          onPressed: () {

                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 75,
                      color: backgroundColor,
                      child: new Material(
                        color: backgroundColor,
                        borderRadius: new BorderRadius.all(
                          Radius.circular(40)
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: new IconButton(
                          icon: Icon(
                            Icons.help,
                            size: 40,
                            color: textColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => InfoPage()
                              )
                            );
                          },
                        ),
                      ),
                    ),
                    Container(
                      width: 75,
                      color: backgroundColor,
                      child: new Material(
                        borderRadius: new BorderRadius.all(
                          Radius.circular(40)
                        ),
                        color: backgroundColor,
                        clipBehavior: Clip.antiAlias,
                        child: new IconButton(
                          icon: Icon(
                            Icons.settings,
                            size: 40,
                            color: textColor
                          ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => SettingsPage()
                              )
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ), 
            ),
          ],
        )
      ),
    );
  }
}
