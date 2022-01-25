import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../addRemainder/main.dart';

import 'package:http/http.dart' as http;

//----Fetch_Todo
class Todo {
  final Object todo;
  final String id;

  Todo({required this.todo, required this.id});

  factory Todo.fromJson(Map<String,dynamic> json){
    return Todo(
        todo: json['todo'],
        id: json['id']
    );
  }
}

Future <List<Todo>> fetchTodo() async{
  final response = await http.get(Uri.parse('https://61d7e596e6744d0017ba8812.mockapi.io/todo'),
      headers: {"Content-type": "application/json"});


  if(response.statusCode == 200){
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((todo) => Todo.fromJson(todo)).toList();
  }
  else{
    throw Exception('Unexpected error occured!');
  }
}

//----TodoTab
class TodoTab extends StatefulWidget{
  TodoTab({UniqueKey? key}) : super(key:key);

  @override
  _TodoTabState createState()=> _TodoTabState();
}

class _TodoTabState extends State<TodoTab>{
  Future <List<Todo>>? futureTodo;

  @override
  void initState() {
    super.initState();
    refreshData();
  }

  refreshData(){
    setState(() {});
    futureTodo = fetchTodo();
    return futureTodo;
  }

  var remindMe = 'todo';

  @override
  Widget build(BuildContext context){
    return  FutureBuilder <List<Todo>>(
      future: refreshData(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          List<Todo>? data = snapshot.data;
          return Container(
            color: Theme.of(context).colorScheme.background,
            child: GridView.count(
              childAspectRatio:1.2,
              crossAxisCount: 2,
              children: _returnTodos(data,context, refreshData,remindMe),),
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

List <Widget> _returnTodos(array,context, refreshData,remindMe,){
  final List<Widget> _todoWidgets = <Widget>[];
  _todoWidgets.add(AddTodoButton(context, refreshData,remindMe));
  for( var i=array.length-1; -1<i;i--){
    var todo = array[i].todo as Map;
    var id  = array[i].id;
    _todoWidgets.add(RemainderTodo(todo, id,refreshData,remindMe));
  }
  return _todoWidgets;
}

class AddTodoButton extends StatelessWidget {

  AddTodoButton(
      this.context, this.refreshData,this.remindMe
      );

  final Function() refreshData;

  final String remindMe;

  final BuildContext context;

  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration( boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ),
      margin: EdgeInsets.only(left:30,top: 30/2,bottom: 30/2,right: 30),
      child: OutlinedButton(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).push(
              CupertinoPageRoute<bool>(
                fullscreenDialog: false,
                builder: (BuildContext context) =>  AddTodoPage(remindMe,'add','0',{}),
              ),
            ).then((value) => refreshData());
          },
          child: Icon(Icons.add_rounded,size: 100,color: Colors.white,),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(0.0),
              backgroundColor:Theme.of(context).colorScheme.primaryVariant,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          )
      ),
    );
  }
}

class RemainderTodo extends StatelessWidget {

  RemainderTodo(
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
      decoration: BoxDecoration( boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ),
      margin: EdgeInsets.only(left:30,top: 30/2,bottom: 30/2,right: 30),
      child: OutlinedButton(
          onPressed: (){
            Navigator.of(context, rootNavigator: true).push(
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
              padding: EdgeInsets.all(0.0),
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          )
      ),
    );
  }
}
