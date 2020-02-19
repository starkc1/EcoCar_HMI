import 'package:flutter/material.dart';

class SelectionPage extends StatefulWidget {

  @override
  SelectionPageState createState() => SelectionPageState();
}

class SelectionPageState extends State<SelectionPage> {

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      child: new Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "EcoCar",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 50
              )
            ),
            new Text(
              "Vehicle Interface Disability Assistance Selection",
              textAlign: TextAlign.left,
              style: new TextStyle(
                fontSize: 30
              )
            ),
            new SizedBox(
              height: 20,
            ),
            new SelectionButton(
              backgroundColor: Colors.white,
              width: 400,
              content: new Text(
                "Continue Without Assistance",
                textAlign: TextAlign.center,
                style: new TextStyle(
                  fontSize: 24
                ),
              ),
              onTap: () {

              },
            ),
            new SizedBox(
              height: 100
            ),
            new Row(
              children: <Widget>[
                new SelectionButton(
                  backgroundColor: Colors.white,
                  width: 400,
                )
              ],
            )
          ],
        )
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {

  Color backgroundColor;
  Widget content;
  double width;
  VoidCallback onTap;

  SelectionButton(
    {
      this.backgroundColor,
      this.content,
      this.width,
      this.onTap
    }
  );

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 700),
      decoration: new BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 5
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(
            20
          )
        ) 
      ),
      width: width,
      child: new Material(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20
          )
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.transparent,
        child: new InkWell(
          child: new Container(
            child: new Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20
              ),
              child: new Center(
                child: content
              ),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
