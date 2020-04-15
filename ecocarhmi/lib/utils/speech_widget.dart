import 'package:speech_recognition/speech_recognition.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechWidget extends StatefulWidget {

  @override
  SpeechWidgetState createState() => SpeechWidgetState();
}

class SpeechWidgetState extends State<SpeechWidget> {


  SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';

  @override
  void initState() {
    super.initState();
    activateSpeechRecognizer();
  }

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
  }

  void onRecognitionComplete() => setState(() {
    _isListening = false;
  });

  @override
  Widget build(BuildContext context) {
    return new IconButton(
      icon: Icon(
        !_isListening ? Icons.mic : Icons.mic_off
      ), 
      onPressed: _speechRecognitionAvailable && !_isListening ? () => start() : () => stop()
    );
  }
}