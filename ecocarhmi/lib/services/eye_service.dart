import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class EyeService with ChangeNotifier {

  EyeService();

  processImage(String path) async {
    File image = File(path);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final FirebaseVision mlVision = FirebaseVision.instance;
    final faceDetector = mlVision.faceDetector(FaceDetectorOptions(enableClassification: true, enableLandmarks: true));

    List<Face> faces = await faceDetector.processImage(visionImage);
    return faces;
    //checkStatus(faces);
  }

  checkStatus(List<Face> faces) {
    print(faces.length);
    for (Face face in faces) {
      checkEyes(face);
      checkHeadRotationY(face);
      checkHeadRotationX(face);
      
      // if (face.leftEyeOpenProbability < 0.75 && face.rightEyeOpenProbability < 0.75) {
      //   print("Eyes Probably Closed");
      //   return;
      // } else {
      //   print("Eyes Open");
      //   return;
      // }
      //print(face.rightEyeOpenProbability);
    }
  }

  bool eyesOpen = true;
  areEyesOpen() {
    return eyesOpen;
  }

  checkEyes(Face face) async {
    if (face.leftEyeOpenProbability < 0.75 && face.rightEyeOpenProbability < 0.75) {
      eyesOpen = false;
      return false;
    } else {
      return true;
      //eyesOpen = true;
      //print(eyesOpen);
    }
    
  }

  checkHeadRotationX(Face face) async {
    double headRotation = face.headEulerAngleY;
    print("Y Angle " + headRotation.toString());
    if (headRotation > 30 || headRotation < -30) {
      return false;
    } else {
      return true;
    }
  }

  checkHeadRotationY(Face face) async {
    double headRotation = face.headEulerAngleZ;
    print("Z Angle " + headRotation.toString());
    
    if (headRotation > 30 || headRotation < -15) {
      return false;
    } else {
      return true;
    }
  }

  


  // Future<bool> updateEyeStatus(FirebaseVisionImage fbImage) async {
  //   if (fbImage == null) return false;

  //   final List<Face> faces = await faceDetector.processImage(fbImage);

  //   for (Face face in faces) {
  //     if (face.leftEyeOpenProbability < 0.75 &&
  //         face.rightEyeOpenProbability < 0.75) {
  //       return false;
  //     }

  //     final double headRotation = face.headEulerAngleY;

  //     if (headRotation > 30 || headRotation < -30) {
  //       return false;
  //     }
  //   }

  //   return true;
  // }
}
