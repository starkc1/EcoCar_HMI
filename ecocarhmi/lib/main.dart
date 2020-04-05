import 'package:camera/camera.dart';
import 'package:ecocarhmi/services/eye_service.dart';
import 'package:ecocarhmi/services/state_service.dart';
import 'package:ecocarhmi/services/vehicle_service.dart';
import 'package:provider/provider.dart';
import './pages/main_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//void main() => runApp(HMI());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final camera = cameras[1];

  runApp(
    HMI(camera: camera)
  );
}

class HMI extends StatelessWidget {

  final camera;

  HMI(
    {
      @required this.camera
    }
  );

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StateService>(
          builder: (_) => StateService()
        ),
        ChangeNotifierProvider<VehicleService>(
          builder: (_) => VehicleService(),
        ),
        ChangeNotifierProvider<EyeService>(
          builder: (_) => EyeService(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'EcoCar HMI',
        theme: ThemeData( 
          fontFamily: "OpenSans"
        ),
        home: MainPage(camera: camera,)
      ),
    );
  }
}