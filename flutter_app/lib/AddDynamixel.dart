import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter_app/DynamixelList.dart';
/* final FirebaseApp app= FirebaseApp.configure(

      FirebaseOptions(
        googleAppID: '1:663823776199:android:7445727a1b688b9f',
        apiKey: 'AIzaSyDFS3kQGh6dm7pyr38_jhir4cnuoSxKKj4',
        databaseURL: 'https://dynadata-21411.firebaseio.com',
    ),
);*/


//void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData.dark(),
      home: AddMotor(),
    );
  }
}

class AddMotor extends StatefulWidget{
  @override
  AddMotorState createState() {
    return new AddMotorState();
  }
}

class AddMotorState extends State<AddMotor> {

  List<DropdownMenuItem<String>> listDrop=[];

  String selected = null ;
  void loadData(){
    listDrop=[];
    listDrop.add(new DropdownMenuItem(child: new Text('FALSE'),value: 'FALSE',));
    listDrop.add(new DropdownMenuItem(child: new Text('TRUE'),value: 'TRUE',));
  }

  List<DropdownMenuItem<String>> listDrop1=[];

  String selected1 = null ;
  void loadData1(){
    listDrop1=[];
    listDrop1.add(new DropdownMenuItem(child: new Text('FALSE'),value: 'FALSE',));
    listDrop1.add(new DropdownMenuItem(child: new Text('TRUE'),value: 'TRUE',));
  }

  List<DropdownMenuItem<String>> listDrop2=[];

  String selected2=null;
  void loadData2(){
    listDrop2=[];
    listDrop2.add(new DropdownMenuItem(child: new Text('FALSE'),value: 'FALSE',));
    listDrop2.add(new DropdownMenuItem(child: new Text('TRUE'),value: 'TRUE',));
  }

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

  @override
  Widget build(BuildContext context){
    loadData();
    loadData1();
    loadData2();
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Dynamixel') ,
        backgroundColor: Colors.blueGrey,
      ),
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            flex: 0,
            child: Center(
              child: Form(
                key: formKey,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      //motor_key
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("MOTOR KEY")
                        ),
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => motor.motor_key= val ,
                          validator: (val) => val == "" ? "Field Empty"  : null,
                        ),
                      ),

                      //motor_type
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("MOTOR TYPE")
                        ),
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => motor.motor_type= val ,
                          validator: (val) => val == "" ? "Field Empty"  : null,
                        ),
                      ),

                      //motor_id
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("MOTOR ID")
                        ),
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => motor.motor_id= val ,
                          validator: (val) => val == "" ? "Field Empty"  : null,
                        ),
                      ),

                      //pypot_support
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("PYPOT SUPPORT"),
                        ),
                          title: new DropdownButton(
                            items: listDrop,
                            value: selected,
                            onChanged: (value){
                              selected=value;
                              setState(() {});
                              motor.pypot_support=value;
                            },
                          )
                      ),

                      //sdk_support
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("SDK SUPPORT")
                        ),
                          title: new DropdownButton(
                            items: listDrop1,
                            value: selected1,
                            onChanged: (value){
                              selected1=value;
                              setState(() {});
                              motor.sdk_support=value;
                            },
                          )
                      ),

                      //wizard_support
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("WIZARD SUPPORT")
                        ),
                          title: new DropdownButton(
                            items: listDrop2,
                            value: selected2,
                            onChanged: (value){
                              selected2=value;
                              setState(() {});
                              motor.wizard_support=value;
                            },
                          )
                      ),

                      //location
                      ListTile(
                        leading: FlatButton(
                            onPressed: null,
                            padding: const EdgeInsets.all(20.0),
                            textColor: Colors.white,
                            color: Colors.black54,
                            child: Text("MOTOR ID")
                        ),
                        title: TextFormField(
                          initialValue: '',
                          onSaved: (val) => motor.location= val ,
                          validator: (val) => val == "" ? "Field Empty" : null,
                        ),
                      ),

                      RaisedButton(
                        child: Text("Add Dynamixel"),
                        padding: const EdgeInsets.all(20.0),
                        onPressed: () {
                          handleSubmit();

                        },
                      ),
                    ],
                  )
              ),
            ),
          ),
          /*Flexible(
            child: FirebaseAnimatedList(
                query: motorRef,
                itemBuilder: ( BuildContext context, DataSnapshot snapshot, Animation<double> animation , int index ){
                  return new ListTile(
                    leading: Icon(Icons.message),
                    title:Text(motors[index].motor_type),
                  );
                },
            ),
          ),*/
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