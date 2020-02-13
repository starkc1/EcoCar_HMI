import 'package:ecocarhmi/pages/selection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData( 
        fontFamily: "OpenSans"
      ),
      //home: new SelectionPage(),
      routes: <String, WidgetBuilder>{
        '/' : (BuildContext context) => new SelectionPage(),
        //'/NoAssitance' : (BuildContext context) => n
      },
    );
  }
}