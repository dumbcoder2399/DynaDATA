import 'dart:async';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/AddDynamixel.dart';
import 'package:flutter_app/DynamixelList.dart';





void main() => runApp(new MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new FirstPage(),
    );
  }
}
//intro page
class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
            body: new Container(
            decoration: new BoxDecoration(
                color: Colors.black,
                image: new DecorationImage(
                  image: new AssetImage(
                      'assets/images/39583861_2124508567763086_3905177148209496064_n.jpg'),
                  fit: BoxFit.fitWidth,
                )
            ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new RaisedButton(
                  padding: const EdgeInsets.all(40.0),
                  textColor: Colors.white,
                  color: Colors.black54,
                  onPressed: () {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => HomePage()
                    )
                    );
                  },
                  child: new Text("Get Started"),
                ),
  ]
        )
    ]
    )
        )
    );
  }
}






class HomePage extends StatefulWidget {

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}


class HomePageState extends State<HomePage> {

  String result = "Hey there !";

  Future _scanQR() async{
    try{
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    }on PlatformException catch (ex){
      if(ex.code ==BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      }
      else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    }on FormatException{
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    }catch (ex){
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("DynaDATA"),
        backgroundColor: Colors.blueGrey,
      ),
      body:
      new Container(
        decoration: new BoxDecoration(
          image: new DecorationImage(
              image: new AssetImage('assets/images/mini-hubo-ni2010.jpg'),
              fit: BoxFit.cover,
          )
        ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //Text(result,style: new TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),),

              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new RaisedButton(
                    padding: const EdgeInsets.all(40.0),
                    textColor: Colors.white,
                    color: Colors.black54,
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => AddMotor()));
                    },
                      child: new Text("Add Dynamixel")
                  ),
                  new RaisedButton(
                    onPressed: () {
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => MotorList()));
                    },
                    textColor: Colors.white,
                    color: Colors.black54,
                    padding: const EdgeInsets.all(40.0),
                    child: new Text(
                      "Search Dynamixel",
                    ),
                  ),
                ],
              )
            ],
          )
      ),

      floatingActionButton: FloatingActionButton.extended(onPressed: _scanQR, icon: Icon(Icons.camera_alt), label: Text("Scan Dynamixel"),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );
  }
}


