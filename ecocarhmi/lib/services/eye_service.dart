import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';
import 'dart:io';

typedef HandleDetection = Future<dynamic> Function(FirebaseVisionImage image);

class EyeService {
  CameraController _camera;
  bool eyesOpen;

  EyeService(camera) {
    print(camera);
    //_camera = camera;
  }

  FirebaseVisionImageMetadata buildMetadata(CameraImage image) {
    return FirebaseVisionImageMetadata(
      rawFormat: image.format.raw,
      size: Size(
        image.width.toDouble(),
        image.height.toDouble()
      ),
      rotation: ImageRotation.rotation90,
      planeData: image.planes.map(
        (Plane plane) {
          return FirebaseVisionImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width
          );
        }
      ).toList(),
    );
  }

  Uint8List concatenatePlanes(List<Plane> planes) {
    final WriteBuffer allBytes = WriteBuffer();

    planes.forEach(
      (Plane plane) => allBytes.putUint8List(plane.bytes)
    );
    return allBytes.done().buffer.asUint8List();
  }

  Future<dynamic> detect(CameraImage image) async {
     final FirebaseVision mlVision = FirebaseVision.instance;
    //, HandleDetection detectio
    // return detection(
    //   FirebaseVisionImage.fromBytes(
    //     concatenatePlanes(image.planes), 
    //     buildMetadata(image)
    //   )
    // );
    return mlVision.faceDetector().processImage(
      FirebaseVisionImage.fromBytes(
        concatenatePlanes(image.planes), 
        buildMetadata(image)
      )
    );
  }

  bool detecting = false;
  Future startCameraStream(_camera) async {
    final FirebaseVision mlVision = FirebaseVision.instance;

    _camera.startImageStream(
      (CameraImage image) {
        // if (detecting) return;

        // detecting = true;
        detect(
          image
          // , 
          // mlVision.faceDetector(
          //   FaceDetectorOptions(
          //     enableClassification: true,
          //     enableLandmarks: true
          //   )
          // ).processImage
        ).then(
          (dynamic result) {
            // if (result.length > 0) {
            //   checkStatus(result);
            //   detecting = true;
            // } else {
            //   detecting = false;
            // }
            print(result);
            
          }
        ).catchError(
          (error) {
            detecting = false;
          }
        ); 
      }
    );
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