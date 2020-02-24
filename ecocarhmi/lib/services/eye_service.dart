import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class EyeService {

  final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFilePath("C:/Users/Alex/Desktop/Young-Black-Man-Smiling-web.png");

  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector(
    FaceDetectorOptions(enableClassification: true, enableLandmarks: true)
  );

  Future<bool> getEyeStatus() async {
    final List<Face> faces = await faceDetector.processImage(visionImage);

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


}

final EyeService eyeService = EyeService();