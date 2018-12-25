
import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_app/DynamixelList.dart';


class MotorDetail extends StatefulWidget {
  @override
  _MotorDetailState createState() => new _MotorDetailState();
}

class _MotorDetailState extends State<MotorDetail> {
  StreamSubscription _subscriptionMotor;


  String _Key="";
  String _MotorKey = "Display the Motor name here";
  String _MotorType = "Display the Motor name here";
  String _MotorId = "Display the Motor name here";
  String _PypotSupport = "Display the Motor name here";
  String _SdkSupport = "Display the Motor name here";
  String _WizardSupport = "Display the Motor name here";
  String _Location = "Display the Motor name here";



  @override
  void initState() {
        FirebaseMotors.getMotorStream("-LURR3a8mdiwTxJL-8sE", _updateMotor)
        .then((StreamSubscription s) => _subscriptionMotor = s);



  }




  @override
  void dispose() {
    if (_subscriptionMotor != null) {
      _subscriptionMotor.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemTile1 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("MOTOR KEY")
      ),
      title: new Text("$_MotorKey"),
    );

    var itemTile2 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("MOTOR ID")
      ),
      title: new Text("$_MotorId"),
    );

    var itemTile3 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("MOTOR TYPE")
      ),
      title: new Text("$_MotorType"),
    );

    var itemTile4 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("PYPOT SUPPORT")
      ),
      title: new Text("$_PypotSupport"),
    );

    var itemTile5 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("SDK SUPPORT")
      ),
      title: new Text("$_SdkSupport"),
    );

    var itemTile6 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("MOTOR KEY")
      ),
      title: new Text("$_WizardSupport"),
    );

    var itemTile7 = new ListTile(
      leading: FlatButton(
          onPressed: null,
          padding: const EdgeInsets.all(20.0),
          textColor: Colors.white,
          color: Colors.black54,
          child: Text("LOCATION")
      ),
      title: new Text("$_Location"),
    );



    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Dynamixel Detail"),
      ),
      body: new ListView(
        children: <Widget>[
          itemTile1,itemTile2,itemTile3,itemTile4,itemTile5,itemTile6,itemTile7,
        ],
      ),
    );
  }

  _updateMotor(Motor value) {
    var key=value.key;
    var motor_key = value.motor_key;
    var motor_type= value.motor_type;
    var motor_id= value.motor_id;
    var pypot_support= value.pypot_support;
    var sdk_support= value.sdk_support;
    var wizard_support= value.wizard_support;
    var location= value.location;
    setState((){
      _Key=key;
      _MotorKey = motor_key;
      _MotorType= motor_type;
      _MotorId = motor_id;
      _PypotSupport=pypot_support;
      _SdkSupport=sdk_support;
      _WizardSupport=wizard_support;
      _Location=location;

    });
  }
}





class Motor{
  String key;
  String motor_key;
  String motor_type;
  String motor_id;
  String pypot_support;
  String sdk_support;
  String wizard_support;
  String location;



  Motor.fromJson(this.key,Map data) {
    key=data["key"];
    motor_key= data["motor_key"];
    motor_type= data["motor_type"];
    motor_id= data["motor_id"];
    pypot_support= data["pypot_support"];
    sdk_support= data["sdk_support"];
    wizard_support= data["wizard_support"];
    location= data["location"];

  }
}





class FirebaseMotors {


  static Future<StreamSubscription<Event>> getMotorStream(String MotorKey,
      void onData(Motor motor)) async {
    String motorKey = await Preferences.getAccountKey();

    StreamSubscription<Event> subscription = FirebaseDatabase.instance
        .reference()
        .child("motors")
        .child(motorKey)
        .onValue
        .listen((Event event) {
      var motor = new Motor.fromJson(event.snapshot.key, event.snapshot.value);
      onData(motor);

    });

    return subscription;
  }


  static Future<Motor> getMotor(String motorKey) async {
    Completer<Motor> completer = new Completer<Motor>();

    String motorKey = await Preferences.getAccountKey();

    FirebaseDatabase.instance
        .reference()
        .child("motors")
        .child(motorKey)
        .once()
        .then((DataSnapshot snapshot) {
      var motor = new Motor.fromJson(snapshot.key, snapshot.value);
      completer.complete(motor);
    });

    return completer.future;
  }
}






class Preferences {
  static const String MOTOR_KEY = "motorKey";

  static Future<bool> setAccountKey(String motorKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(MOTOR_KEY, motorKey);
    return prefs.commit();
  }

  static Future<String> getAccountKey() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String motorKey;//= prefs.getString(MOTOR_KEY);


    // workaround - simulate a login setting this
    if (motorKey == null) {
      motorKey="-LUOxF9jxQ3fvKXv3bZK";
      
  }
    return motorKey;
  }
}

