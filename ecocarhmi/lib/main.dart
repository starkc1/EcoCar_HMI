import 'package:ecocarhmi/pages/selection_page.dart';
import 'package:ecocarhmi/services/state_service.dart';
import 'package:provider/provider.dart';
import './pages/main_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StateService>(
          builder: (_) => StateService()
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData( 
          fontFamily: "OpenSans"
        ),
        home: MainPage()
      ),
    );
  }
}