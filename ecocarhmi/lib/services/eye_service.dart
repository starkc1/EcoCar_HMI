import 'dart:ui';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:camera/camera.dart';

class StateService {

  CameraController cameraController;
  bool eyesOpen;

  StateService() {
    availableCameras().then((cameras) => {
      cameraController = CameraController(cameras[0], ResolutionPreset.max)
    });
    cameraController.initialize().then((x) => {
      cameraController.startImageStream((image) => {
        this.updateEyeStatus(FirebaseVisionImage.fromBytes(image.planes[0].bytes, 
        FirebaseVisionImageMetadata(
          rawFormat: image.format.raw,
          size: Size(image.width.toDouble(),image.height.toDouble()),
          planeData: image.planes.map((currentPlane) => FirebaseVisionImagePlaneMetadata(
            bytesPerRow: currentPlane.bytesPerRow,
            height: currentPlane.height,
            width: currentPlane.width
            )).toList(),
          rotation: ImageRotation.rotation90
          )
          )).then((boolean) => {
            this.eyesOpen = boolean
        })
      })
    });
  }

  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
    FaceDetectorOptions(enableClassification: true, enableLandmarks: true)
  );

  Future<bool> updateEyeStatus(FirebaseVisionImage fbImage) async {
    if(fbImage == null) return false;

    final List<Face> faces = await faceDetector.processImage(fbImage);

    for (Face face in faces){

      if (face.leftEyeOpenProbability < 0.75 && face.rightEyeOpenProbability < 0.75){
        return false;
      }

      final double headRotation = face.headEulerAngleY;

      if (headRotation > 30 || headRotation < -30){
        return false;
      }
    }

    return true;

  }

  bool getBooleanStatus(){
    return eyesOpen;
  }
}

final StateService eyeService = StateService();