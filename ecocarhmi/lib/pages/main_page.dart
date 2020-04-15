import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:ecocarhmi/pages/info_page.dart';
import 'package:ecocarhmi/pages/settings_page.dart';
import 'package:ecocarhmi/pages/speechinfo_page.dart';
import 'package:ecocarhmi/services/eye_service.dart';
import 'package:ecocarhmi/services/vehicle_service.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/painting.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:speech_recognition/speech_recognition.dart';

import '../services/state_service.dart';
import '../utils/speech_widget.dart';

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

enum TtsState { playing, stopped }

class MainPageState extends State<MainPage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  EyeService eyeService = EyeService();

  bool loading = true;
  
  
  @override
  void initState() {
    super.initState();

    


    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high
    );

    _initializeControllerFuture = _controller.initialize();
    //activateSpeechRecognizer();
    initTts();
  }
  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';

  void requestPermissions() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);

    if (permission != PermissionStatus.granted) {
      await PermissionHandler().requestPermissions([PermissionGroup.microphone]);
    }
  }

  void activateSpeechRecognizer() {
    requestPermissions();

    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.activate().then(
      (res) => setState(() {
        _speechRecognitionAvailable = res;
      })
    );
  }

  void start() => _speech.listen(
    locale: 'en_US'
  ).then(
    (result) {
      print("Started Listening => result $result");
    }
  );

  void cancel() => _speech.cancel().then(
    (result) {
      setState(() {
        _isListening = result;
      });
    }
  );

  void stop() => _speech.stop().then(
    (result) {
      setState(() {
        _isListening = result;
      });
    }
  );

  void onSpeechAvailability(bool result) => setState(() {
    _speechRecognitionAvailable = result;
  });

  void onCurrentLocale(String locale) => setState(() {
    print("current locale: $locale");
  });

  void onRecognitionStarted() => setState(() {
    _isListening = true;
  });

  void onRecognitionResult(String text) {
    setState(() {
      transcription = text;
    });

    processSpeech(text);
  }

  void onRecognitionComplete() => setState(() {
    _isListening = false;
  });

  processSpeech(String text) {
    
    if (text.contains('vehicle go to info')) {
      stop();
      print("Here");
      Navigator.push(
        scaffoldContext, 
        MaterialPageRoute(
          builder: (context) => InfoPage()
        )
      );
    } else if (text.contains('vehicle go to settings')) {
      stop();
      Navigator.push(
        scaffoldContext,
        MaterialPageRoute(
          builder: (context) => SettingsPage()
        )
      );
    } else if (text.contains('help') || text.contains('vehicle go to help')) {
      stop();
      Navigator.push(
        scaffoldContext,
        MaterialPageRoute(
          builder: (context) => SpeechInfoPage() 
        )
      );
    } else if (text.contains('vehicle status update')) {
      stop();
      speed = speed;
      String action;
      switch(vehicleAction) {
        case 0: {
          action = "Driving Straight";
        }
        break;
        
        case 1: {
          action = "Accelerating";
        }
        break;

        case 2: {
          action = "Not Accelerating";
        }
        break;

        case 3: {
          action = "Decelerating";
        }
        break;

        case 4: {
          action = "Not Decelerating";
        }
        break;

        case 5: {
          action = "Drifting Right";
        }
        break;

        case 6: {
          action = "Returning to Center";
        }
        break;

        case 7: {
          action = "Drifting Left";
        }
        break;

        case 8: {
          action = "Returning to Center";
        }
        break;

        case 9: {
          action = "Departing Left Lane";
        }
        break;

        case 10: {
          action = "Returning to Center";
        }
        break;

        case 11: {
          action = "Departing Right Lane";
        }
        break;

        case 12: {
          action = "Returning to center";
        }
      }

      String proximity;
      switch(proximityLevel) {
        case 0: {
          proximity = "No Vehicles Close to Front";
        }
        break;

        case 1: {
          proximity = "Vehicle Approaching Front";
        }
        break;

        case 2: {
          proximity = "Vehicle Getting close to front";
        }
        break;

        case 3: {
          proximity = "Vehicle Very Close to front";
        }
        break;

        case 4: {
          proximity = "Vehicle moving away";
        }
        break;

        case 5: {
          proximity = "Vehicle moving away";
        }
        break;

        case 6: {
          proximity = "Vehicle moving away";
        }
        break;
      }

      String sentence = "Vehicle is traveling at " + speed.toString() + " Miles Per Hour while " + action + " in the lane with " + proximity;
      _speak(sentence);

    } else if (text.contains('vehicle activate ACC') || text.contains('vehicle deactivate ACC')) {
      stop();
      setState(() {
        accActive = !accActive;
      });
      _speak(accActive ? "Adaptive Cruise Control Activated" : "Adaptive Cruise Control Deactivated");
                                  Scaffold.of(scaffoldContext).showSnackBar(
                                    new SnackBar(
                                      content: new Text(
                                        accActive ? "Adaptive Cruise Control Activated" : "Adaptive Cruise Control Deactivated",
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                          fontSize: 30
                                        ),
                                      ),
                                      backgroundColor: accActive ? Colors.green : Colors.redAccent,
                                      duration: new Duration(seconds: 2),
                                    )
                                  );
    } else if (text.contains('vehicle what page am I on')) {
      stop();
      _speak("Currently on the Home Page");
    }

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
    if (faces.length == 0) {
      return;
    }

    //print(faces.length);
    for (Face face in faces) {
      eyeService.checkEyes(face).then(
        (result) {
          //print(result);
          if (!result) {
            isPlaying ? null : _speak("Please Open Your Eyes And Pay Attention To The Road");
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
          //print(result);
          if (!result) {
            isPlaying ? null : _speak("Please Look Straight Ahead And Pay Attention To The Road");
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
          //print(result);
          
          if (!result) {
            isPlaying ? null : _speak("Please Look Straight Ahead And Pay Attention To The Road");
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
        }
      );
    }
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

  int speed = 45;
  int prevSpeed = 0;
  int proximityLevel = 0;
  List<String> proximityLevels = [
    "None",
    "Approaching_Level3",
    "Approaching_Level2",
    "Approaching_Level1",
    "Deproaching_Level1",
    "Deproaching_Level2",
    "Deproaching_Level3"
  ];
  int vehicleAction = 0;
  List<String> vehicleActions = [
    "Driving",
    "Accelerating",
    "To_Center_From_Accelerating",
    "Deccelerate",
    "To_Center_From_Decclerating",
    "Drift_Right",
    "To_Center_From_Drift_Right",
    "Drift_Left",
    "To_Center_From_Drift_Left",
    "Depart_Left",
    "To_Center_From_Left",
    "Depart_Right",
    "To_Center_From_Right"
  ];
  vehicleMovement() {
    speed = 0;
    prevSpeed = 0;
    proximityLevel = 0;
    vehicleAction = 0;
    vehicleService.loadData().then(
      (result) async {
        List data = jsonDecode(result);

        for (int i = 0; i < data.length; i++) {
          //print(data[i]['LandSpeedMph']);
          processSpeed(data[i]["LandSpeedMph"]);
          processProximity(data[i]['ForwardProximity']);
          await Future.delayed(Duration(seconds: 1));
        }
      }
    );
  }

  vehicleMovement2() {
    speed = 0;
    prevSpeed = 0;
    proximityLevel = 0;
    vehicleAction = 0;
    vehicleService.loadData().then(
      (result) async {
        List data = jsonDecode(result);

        for (int i = 0; i < data.length; i++) {
          processSpeed(data[i]['LandSpeedMph']);
          processPosition(data[i]['HorizontalPosition']);
          await Future.delayed(Duration(seconds: 1));
        }
      }
    );
  }

  processPosition(double value) {
    setState(() {
      if (0.0 < value && value <= 0.5) {
        vehicleAction == 5 ? null : vehicleAction = 5;
      } else if (0.5 < value) {
        if (vehicleAction == 5) {
          vehicleAction = 6;
        } else if (vehicleAction == 6) {
          vehicleAction == 11 ? null : vehicleAction = 11;
        } else {
          vehicleAction == 11 ? null : vehicleAction = 11;
        } 
      } else if (0.0 > value && value > -0.5) {
        vehicleAction == 7 ? null : vehicleAction = 7;
      } else if (value < -0.5) {
        if (vehicleAction == 7) {
          vehicleAction = 8;
        } else if (vehicleAction == 8) {
          vehicleAction == 9 ? null : vehicleAction = 9;
        } else  {
          vehicleAction == 9 ? null : vehicleAction = 9;
        }
      } else {
        vehicleAction == 0 ? null : vehicleAction = 0;
      }
    });
  }

  processSpeed(double value) {
    setState(() {
      speed = value.round();
      if (speed < prevSpeed) {
        if (vehicleAction == 3) {

        } else {
          vehicleAction = 3;
        }
        
      } else if (speed > prevSpeed) {
        if (vehicleAction == 1) {

        } else {
          vehicleAction = 1;
        }
        
      } 
      prevSpeed = speed;
    });
  }

  processProximity(double value) {
    setState(() {
      if (value == 0.0) {
        proximityLevel == 0 ? null : proximityLevel = 0; 
      } else if (0.0 < value && value <= 0.3) {
        proximityLevel == 1 ? null : proximityLevel = 1;
      } else if (0.3 < value && value <= 0.6) {
        proximityLevel == 2 ? null : proximityLevel = 2;
      } else if (0.6 < value && value <= 1.0) {
        proximityLevel == 3 ? null : proximityLevel = 3;
      }
    });
  }




  FlutterTts tts;
  String language = "en-US";
  double volume = 0.5;
  double pitch = 0.8;
  double rate = 0.5;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;

  initTts() {
    tts = FlutterTts();
    
    tts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });  
    });

    tts.setCompletionHandler(() {
      setState(() {
        print("complete");
        ttsState = TtsState.stopped;
      });
    });

    tts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });

  }
  
  Future _speak(String text) async {
    await tts.setVolume(volume);
    await tts.setSpeechRate(rate);
    await tts.setPitch(pitch);

    if (text != null) {
      if (text.isNotEmpty) {
        var result = await tts.speak(text);
        if (result == 1) {
          setState(() {
            ttsState = TtsState.playing;
          });
        }
      }
    }
  }
  



  bool darkTheme = false;
  bool active = false;
  var prevPath;
  bool accActive = true;

  BuildContext scaffoldContext;
  @override
  Widget build(BuildContext context) {
    takePeriodicPicture();
    final appState = Provider.of<StateService>(context);
    appState.checkTimeOfDay();
    Color backgroundColor = appState.getBackgroundColor();
    BoxShadow sectionShadow = appState.getSectionShadow();
    Color textColor = appState.getTextColor();
    bool isKPH = appState.getUnits();
    

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
            new Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: new Image.asset(
                "assets/background.jpg",
                fit: BoxFit.cover,
              ),
            ),
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
                      top: 20,
                      left: 0,
                      right: 0,
                      //child: new VehicleSpeed(),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              size: 45,
                              color: textColor
                            ),
                            onPressed: () {
                              vehicleMovement2();
                            },
                          ),
                          new Column(
                            children: <Widget>[
                              new Text(
                                !isKPH ? speed.toString() : (speed * 1.6093).round().toString(),
                                style: new TextStyle(
                                  fontSize: 45,
                                  color: textColor
                                )
                              ),
                              new Text(
                                !isKPH ? "MPH" : "KPH",
                                style: new TextStyle(
                                  fontSize: 25,
                                  color: textColor
                                )
                              )
                            ],
                          ),
                          new IconButton(
                            icon: Icon(
                              Icons.arrow_forward,
                              size: 45,
                              color: textColor
                            ),
                            onPressed: () {
                              vehicleMovement();
                            },
                          )
                        ],
                      )
                    ),
                    new Positioned(
                      top: 120,
                      left: -8,
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
                            animation: proximityLevels[proximityLevel],
                          ),
                        ),
                      ),
                    ),
                    new Positioned(
                      top: 200,
                      left: -14,
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
                              animation: vehicleActions[vehicleAction],
                            ),
                          ),
                        ),
                    ),
                    new Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          new Container(
                            child: new Material(
                              color: Colors.transparent,
                              child: new InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10
                                  ),
                                  child: new Column(
                                    children: <Widget>[
                                      new Icon(
                                        Icons.warning,
                                        size: 35,
                                        color: accActive ? Colors.green : Colors.redAccent
                                      ),
                                      new Text(
                                        "ACC",
                                        style: new TextStyle(
                                          fontSize: 20,
                                          color: accActive ? Colors.green : Colors.redAccent
                                        )
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    accActive = !accActive;
                                  });
                                  _speak(accActive ? "Adaptive Cruise Control Activated" : "Adaptive Cruise Control Deactivated");
                                  Scaffold.of(scaffoldContext).showSnackBar(
                                    new SnackBar(
                                      content: new Text(
                                        accActive ? "Adaptive Cruise Control Activated" : "Adaptive Cruise Control Deactivated",
                                        textAlign: TextAlign.center,
                                        style: new TextStyle(
                                          fontSize: 30
                                        ),
                                      ),
                                      backgroundColor: accActive ? Colors.green : Colors.redAccent,
                                      duration: new Duration(seconds: 2),
                                    )
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    )
                  ],
                ),
              ),
            ),
            new AnimatedPositioned(
              duration: new Duration(milliseconds: 600),
              right: 30,
              top: 30,
              child: new Container(
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
                child: new Material(
                  color: Colors.transparent,
                  borderRadius: new BorderRadius.all(
                    Radius.circular(
                      20
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10
                    ),
                    child: new IconButton(
                      padding: EdgeInsets.all(0),
                      icon: new Icon(
                        Icons.mic,
                        size: 50,
                        color: _isListening ? Colors.green : Colors.amberAccent,
                      ),
                      onPressed: () => start(),
                    ),
                  ),
                ),
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
                            FontAwesomeIcons.fileAudio,
                            size: 35,
                            color: textColor,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => SpeechInfoPage()
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
