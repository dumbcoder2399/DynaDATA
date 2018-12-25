import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter_app/DynamixelDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/DynamixelDetail.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData.dark(),
      home: MotorList(),
    );
  }
}

class MotorList extends StatefulWidget{

  @override
  MotorListState createState() {
    return new MotorListState();
  }
}

class MotorListState extends State<MotorList> {



  List<Motor> motors = List();
  Motor motor;
  DatabaseReference motorRef;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    motor = Motor("","","","","","","");
    final FirebaseDatabase database = FirebaseDatabase.instance;//(app: app);
    motorRef = database.reference().child('motors');
    motorRef.onChildAdded.listen(_onEntryAdded);
    motorRef.onChildChanged.listen(_onEntryChanged);
    //motorRef = FirebaseDatabase.instance.reference().child('motors');
  }


  _onEntryAdded(Event event) {
    setState(() {
      motors.add(Motor.fromSnapshot(event.snapshot));
    });
  }

  _onEntryChanged(Event event){
    var old = motors.singleWhere((entry){
      return entry.key == event.snapshot.key;
    });
    setState(() {
      motors[motors.indexOf(old)] = Motor.fromSnapshot(event.snapshot);
    });
  }

//when we add the dynamixel
  void handleSubmit(){
    final FormState form = formKey.currentState;

    if (form.validate()){
      form.save();
      form.reset();
      motorRef.push().set(motor.toJson());
    }

  }

  String thefuckingkey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamixel List'),
        backgroundColor: Colors.blueGrey,
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: motorRef,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new ListTile(
                  leading: Icon(Icons.add_box),
                  title: new RaisedButton(
                    onPressed: () {
                      //Preferences().getAccountKey().motorKey=motors[index].key;
                      Navigator.push(context, new MaterialPageRoute(
                          builder: (context) => MotorDetail()));
                    },
                    textColor: Colors.white,
                    color: Colors.black54,
                    padding: const EdgeInsets.all(20.0),
                    child: new Text(motors[index].motor_key),

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
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

  Motor(this.motor_key,this.motor_type,this.motor_id,this.pypot_support,this.sdk_support,this.wizard_support,this.location);

  Motor.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        motor_key = snapshot.value["motor_key"],
        motor_type = snapshot.value["motor_type"],
        motor_id = snapshot.value["motor_id"],
        pypot_support = snapshot.value["pypot_support"],
        sdk_support = snapshot.value["sdk_support"],
        wizard_support = snapshot.value["wizard_support"],
        location = snapshot.value["location"];




  toJson() {
    return {
      "motor_key": motor_key,
      "motor_type": motor_type,
      "motor_id": motor_id,
      "pypot_support": pypot_support,
      "sdk_support": sdk_support,
      "wizard_support": wizard_support,
      "location": location,

    };
  }

}


