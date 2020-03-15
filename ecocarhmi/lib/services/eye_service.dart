import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';



class EyeService {
  // CameraController _camera;
  // bool eyesOpen;
  // bool _isDetecting = false;

  EyeService() {
    
  }

  // FirebaseVisionImageMetadata buildMetadata(CameraImage image) {
  //   return FirebaseVisionImageMetadata(
  //     rawFormat: image.format.raw,
  //     size: Size(image.width.toDouble(), image.height.toDouble()),
  //     rotation: ImageRotation.rotation90,
  //     planeData: image.planes.map((Plane plane) {
  //       return FirebaseVisionImagePlaneMetadata(
  //           bytesPerRow: plane.bytesPerRow,
  //           height: plane.height,
  //           width: plane.width);
  //     }).toList(),
  //   );
  // }

  // Uint8List concatenatePlanes(List<Plane> planes) {
  //   final WriteBuffer allBytes = WriteBuffer();

  //   planes.forEach((Plane plane) => allBytes.putUint8List(plane.bytes));
  //   return allBytes.done().buffer.asUint8List();
  // }

  // Future<dynamic> detect(CameraImage image, FaceDetector faceDetector) async {
  //   return faceDetector.processImage(FirebaseVisionImage.fromBytes(
  //       concatenatePlanes(image.planes), buildMetadata(image)));
  // }

  //bool detecting = false;
  //Future<String> startCameraStream(CameraController _camera) async {
    //final FirebaseVision mlVision = FirebaseVision.instance;
    //final faceDetector = mlVision.faceDetector(FaceDetectorOptions(enableClassification: true, enableLandmarks: true));


    // _camera.startImageStream((CameraImage image) {
    //   if(_isDetecting) return;
    //   _isDetecting = true;
    //   detect(image, faceDetector).then((dynamic result) {
    //     print(result);
    //   }).catchError((error) {
    //     _isDetecting = false;
    //   });
    //   _isDetecting = false;
    //   _camera.stopImageStream();
    // });
  //}

  void processImage(String path) async {
    File image = File(path);
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    final FirebaseVision mlVision = FirebaseVision.instance;
    final faceDetector = mlVision.faceDetector(FaceDetectorOptions(enableClassification: true, enableLandmarks: true));

    List<Face> faces = await faceDetector.processImage(visionImage);
    checkStatus(faces);
  }

  checkStatus(List<Face> faces) {
    print(faces);
    for (Face face in faces) {
      print(face.rightEyeOpenProbability);
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
