import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../addRemainder/main.dart';
import 'package:pedometer/pedometer.dart';

import '../../../../controller.dart';
import 'package:get/get.dart';


import './components.dart';
import 'package:http/http.dart' as http;

class Health {
  final Object health;
  final String id;

  Health({required this.health, required this.id});

  factory Health.fromJson(Map<String,dynamic> json){
    return Health(
        health: json['health'],
        id: json['id']
    );
  }
}

Future <List<Health>> fetchHealth() async{
  final response = await http.get(Uri.parse('https://61d7e596e6744d0017ba8812.mockapi.io/health'),
      headers: {"Content-type": "application/json"});


  if(response.statusCode == 200){
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((health) => Health.fromJson(health)).toList();
  }
  else{
    throw Exception('Unexpected error occured!');
  }
}

//----HealthTab
class HealthTab extends StatefulWidget{
  HealthTab({UniqueKey? key}) : super(key:key);

  @override
  _HealthTabState createState()=> _HealthTabState();
}

class _HealthTabState extends State<HealthTab>{
  Future <List<Health>>? futureHealth;

  late Stream<StepCount> _stepCountStream;

  final Controller controller = Get.find();


  String _steps = '?';
  String _distance = '?';

  @override
  void initState() {
    super.initState();
    futureHealth = fetchHealth();
    initPlatformState();

  }


  void onStepCount(StepCount event) {
    setState(() {
      switch(controller.conventionUnit.toString()){
        case 'metric':
          _distance = (event.steps * 0.8 / 1000).toStringAsFixed(2) + ' km';
          break;
        case 'imperial':
          _distance = (event.steps * 0.0004 ).toStringAsFixed(2) + ' ml';
          break;
      }
      _steps = event.steps.toString();

    });
  }

  void onStepCountError(error) {
    setState(() {
      _steps = 'Not Available';
      _distance = 'Not Available';
    });
  }

  void initPlatformState() {
    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  refreshData(){
    setState(() {});
    futureHealth = fetchHealth();
    return futureHealth;
  }

  var remindMe = 'health';

  @override
  Widget build(BuildContext context){
    return FutureBuilder <List<Health>>(
      future: refreshData(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<Health>? data = snapshot.data;
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                    color: Theme.of(context).colorScheme.background,
                    height: 115.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: _returnHealths(data,context, refreshData,remindMe),)
                ),
                Container(
                  height: MediaQuery.of(context).size.height/1.8,
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ,
                    color: Theme.of(context).colorScheme.background
                  ),
                  child: SingleChildScrollView(child: HealthDetails(data,_steps,_distance)),
                )
              ],
            ),
          );
        }
        else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Container();
      },
    );
  }
}

List <Widget> _returnHealths(array,context, refreshData,remindMe){
  final List<Widget> _healthWidgets = <Widget>[];
  _healthWidgets.add(AddHealthButton(context, refreshData,remindMe));
  for( var i=array.length-1; -1<i;i--){
    var todo = array[i].health as Map;
    var id  = array[i].id;
    _healthWidgets.add(RemainderHealth(todo, id,refreshData,remindMe));
  }
  return _healthWidgets;
}

class AddHealthButton extends StatelessWidget{
  AddHealthButton(this.context, this.refreshData,this.remindMe);

  final String remindMe;

  final Function() refreshData;

  final BuildContext context;

  @override
  Widget build(BuildContext context){
    return Container(
      width: 85,
      decoration: BoxDecoration( boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ),
      margin: EdgeInsets.only(left:15,right: 15/2,top:15),
      child: OutlinedButton(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: false,
                builder: (BuildContext context) =>  AddTodoPage(remindMe,'add','0',{}),
              ),
            ).then((value) => refreshData());},
          child: Icon(Icons.add_rounded,size: 75,color: Colors.white,),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(5.0),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          )
      ),
    );
  }
}

class RemainderHealth extends StatelessWidget {

  RemainderHealth(
      this.todo,
      this.id,
      this.refreshData,
      this.remindMe,
      );

  final String remindMe;

  final Function() refreshData;

  final Map todo;
  final String id;

  getRepeatDays(){
    String repeatDays='';

    var repeatArray= todo['repeat'];
    Map expArray ={
      0:'Su,',
      1:'Mo,',
      2:'Tu,',
      3:'We,',
      4:'Th,',
      5:'Fr,',
      6:'Sa'
    };

    for( var i=0; i<repeatArray.length;i++){
      if (repeatArray[i]){
        repeatDays= repeatDays+expArray[i];
      }
    }
    return repeatDays;
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: 85,
      decoration: BoxDecoration( boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ),
      margin: EdgeInsets.only(left:10,top: 30/2,right: 10),
      child: OutlinedButton(
          onPressed: (){Navigator.of(context, rootNavigator: true).push(
            CupertinoPageRoute<bool>(
              fullscreenDialog: false,
              builder: (BuildContext context) =>  AddTodoPage(remindMe,'edit',id,todo),
            ),
          ).then((value) => refreshData());},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(todo['time'],style: TextStyle(color: Colors.white),),
              Text(todo['title'],style: TextStyle(color: Colors.white)),
              todo['isDate']?
              Text(todo['date'],style: TextStyle(color: Colors.white)):
              Text(getRepeatDays(),style: TextStyle(color: Colors.white)),
            ],
          ),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(5.0),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          )
      ),
    );
  }
}