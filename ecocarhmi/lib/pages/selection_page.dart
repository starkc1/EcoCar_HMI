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
            new Container(
              decoration: new BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  new BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4
                  )
                ],
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20
                  )
                )
              ),
              child: new Material(
                color: Colors.transparent,
                child: new InkWell(
                  child: new Container(
                    width: 400,
                    decoration: new BoxDecoration(
                      
                    ),
                    child: new Padding(
                      padding: new EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20
                      ),
                      child: new Text(
                        "Continue Without Assistance",
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                          fontSize: 25
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                  },
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}

class SelectionButton extends StatelessWidget {

  Color backgroundColor;

  SelectionButton(
    {
      this.backgroundColor,
    }
  );

  @override
  Widget build(BuildContext context) {
    return new Container(
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
      child: new Material(
        borderRadius: BorderRadius.all(
          Radius.circular(
            20
          )
        ),
      ),
    );
  }
}
