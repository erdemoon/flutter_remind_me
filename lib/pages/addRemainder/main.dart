import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import '../../jobs.dart';
import 'package:flutter/cupertino.dart';
import 'package:weekday_selector/weekday_selector.dart';

Future<Todo> postTodoDB(Map todo,String remindMe) async{
  var uri;
  switch (remindMe){
    case 'todo': uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/todo'; break;
    case 'health': uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/health'; break;
  }
  final response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String,Map>{
      remindMe:todo,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Todo> deleteTodoDB(String remindMe,String id) async{
  var uri;
  switch (remindMe){
    case 'todo': uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/todo/'+id; break;
    case 'health': uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/health/'+id; break;
  }
  final response = await http.delete(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Todo> putTodoDB(Map todo,String remindMe,String id) async{
  var uri;
  switch (remindMe){
    case 'todo': uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/todo/'+id; break;
    case 'health': uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/health/'+id; break;
  }
  final response = await http.put(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String,Map>{
      remindMe:todo,
    }),
  );
  if (response.statusCode == 200) {
    return Todo.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Todo {

  Null  title;
  Null  desc;
  Null  time;
  Null  date;
  Null  values;

  Todo({
    required this.title,
    required this.time,
    required this.desc,
    required this.date,
    required this.values,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      time: json['time'],
      values: json['values'],
      date: json['date'],
      desc: json['desc']
    );
  }
}

class AddTodoPage extends StatefulWidget {
  AddTodoPage(this.remindMe,this.pageState,this.id,this.todo);

  final String remindMe;
  final String pageState;
  final String id;
  final Map todo;

  @override
  _AddTodoPageState createState()
  {
    return _AddTodoPageState(remindMe,pageState,id,todo);
  }
}

class _AddTodoPageState extends State<AddTodoPage> {
  late Future<Todo>? _futureTodo;

  _AddTodoPageState(this.remindMe,this.pageState,this.id,this.todo);

  final String remindMe;
  final String pageState;
  final String id;
  final Map todo;

  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  bool isDate = true;
  bool isRepeat = false;
  List<bool> values= [
  true, // Sunday
    true, // Monday
    true, // Tuesday
    true, // Wednesday
    true, // Thursday
    true, // Friday
    true, // Saturday
  ];

  late final titleController = TextEditingController(text:pageState=='edit'?'${todo['title']}':'' );

  late final descController = TextEditingController(text:pageState=='edit'?'${todo['desc']}':'' );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: GradientIcon(
                      Icons.arrow_back_ios,
                      30.0,
                      LinearGradient(
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  );
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
        ),
        body: Container(
          child: SingleChildScrollView(child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.only(left:20,right: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          _selectTime(context);
                        },
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(margin:EdgeInsets.only(right: 30),child: Text("Choose Time")),
                                  Container(
                                    width: 75,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(pageState=='edit'?'${todo['time']}':'${selectedTime.hour}:${selectedTime.minute}',
                                        style: TextStyle(
                                          backgroundColor: Colors.white,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                              Spacer(),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                          )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.only(left:20,right: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            isDate?_selectDate(context):null;
                          },
                              child:Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(margin:EdgeInsets.only(right: 30),child: Text("Choose Date ")),
                                  Container(
                                    width: 75,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,

                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(pageState=='edit'?'${todo['date']}':'${selectedDate.day}:${selectedDate.month}:${selectedDate.year}',
                                        style: TextStyle(
                                            backgroundColor: Colors.white,
                                            color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  Switch(
                                    value: isDate,
                                    onChanged: (value) {
                                      setState(() {
                                        isRepeat = !value;
                                        isDate = value;
                                      });
                                    },
                                    activeTrackColor: Theme.of(context).colorScheme.secondary,
                                    activeColor: Theme.of(context).colorScheme.primaryVariant,
                                  ),
                                ],
                              ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isDate?Theme.of(context).colorScheme.primary:Color(0xffbcbcbc),
                          )
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      padding: EdgeInsets.only(left:20,right: 20),
                      child: ElevatedButton(
                          onPressed: () {
                          },
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Choose Repeat"),
                              Switch(
                                value: isRepeat,
                                onChanged: (value) {
                                  setState(() {
                                    isDate = !value;
                                    isRepeat = value;
                                  });
                                },
                                activeTrackColor: Theme.of(context).colorScheme.secondary,
                                activeColor: Theme.of(context).colorScheme.primaryVariant,
                              ),
                            ],
                          ),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isRepeat?Theme.of(context).colorScheme.primary:Color(0xffbcbcbc),
                          )
                      ),
                    ),
                  ],
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds:200),
                  width: MediaQuery.of(context).size.width,
                  height: isRepeat?50:0,
                  padding: EdgeInsets.only(left:20,right: 20),
                  child: WeekdaySelector(
                    selectedFillColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (v) {
                      setState(() {
                        values[v % 7] = !values[v % 7];
                      });
                    },
                    selectedElevation: 15,
                    elevation: 5,
                    disabledElevation: 0,
                    values: values,
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.only(left:20,right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child:  TextField(
                    maxLength: 15,
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.secondaryVariant),
                      enabledBorder:  OutlineInputBorder(
                        borderSide:  BorderSide(color: Theme.of(context).colorScheme.secondaryVariant, width:1.0),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderSide:  BorderSide(color: Theme.of(context).colorScheme.secondaryVariant, width:1.0),
                      ),

                  ),),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.only(left:20,right: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child: TextField(
                    controller: descController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Description",
                      hintStyle: TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.secondaryVariant),
                      enabledBorder:  OutlineInputBorder(
                        borderSide:  BorderSide(color: Theme.of(context).colorScheme.secondaryVariant, width:1.0),
                      ),
                      focusedBorder:  OutlineInputBorder(
                        borderSide:  BorderSide(color: Theme.of(context).colorScheme.secondaryVariant, width:1.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                pageState == 'add'?Container(
                      width: MediaQuery.of(context).size.width/2,
                      height: 50,
                      padding: EdgeInsets.only(left:20,right: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            var todoTitle='';
                            if(titleController.text==''){
                              todoTitle="Untitled";
                            }
                            else{
                              todoTitle=titleController.text;
                            }

                            formatTime(){
                              String formatedTime = selectedTime.hour.toString() +':' +selectedTime.minute.toString();
                              return formatedTime;
                            }

                            Map todo= {
                              'title': todoTitle,
                              'desc': descController.text,
                              'time': formatTime(),
                              'date': DateFormat('dd:M:yyyy').format(selectedDate),
                              'repeat': values,
                              'isDate' : isDate,
                              'isRepeat' : isRepeat,
                            };
                            setState(() {
                              _futureTodo = postTodoDB(todo,remindMe);
                            });

                            Navigator.pop(context);
                          },
                          child:Text("Create Task",style: TextStyle(fontSize: 20),),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          )
                      ),
                    ):
                    Container(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: <Widget>[
                            Container(
                            width: MediaQuery.of(context).size.width/2,
                            height: 50,
                            padding: EdgeInsets.only(left:20,right: 20),
                            child: ElevatedButton(
                                onPressed: () {
                                  deleteTodoDB(remindMe, id);
                                  Navigator.pop(context);
                                },
                                child:Text("Delete Task",style: TextStyle(fontSize: 20),),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                )
                            ),
                          ),
                            Container(
                              width: MediaQuery.of(context).size.width/2,
                              height: 50,
                              padding: EdgeInsets.only(left:20,right: 20),
                              child: ElevatedButton(
                                  onPressed: () {
                                    var todoTitle='';
                                    if(titleController.text==''){
                                      todoTitle="Untitled";
                                    }
                                    else{
                                      todoTitle=titleController.text;
                                    }

                                    formatTime(){
                                      String formatedTime = selectedTime.hour.toString() +':' +selectedTime.minute.toString();
                                      return formatedTime;
                                    }

                                    Map todo= {
                                      'title': todoTitle,
                                      'desc': descController.text,
                                      'time': formatTime(),
                                      'date': DateFormat('dd:M:yyyy').format(selectedDate),
                                      'repeat': values,
                                      'isDate' : isDate,
                                      'isRepeat' : isRepeat,
                                    };


                                    setState(() {
                                      _futureTodo = putTodoDB(todo,remindMe,id);
                                    });
                                    Navigator.pop(context);
                                  },
                                  child:Text("Save Task",style: TextStyle(fontSize: 20),),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                  )
                              ),
                            ),])
                    ),
                  ],

            ),
        )),
    );
  }
  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      builder: (context, child)=> Theme(
        data: ThemeData().copyWith(
            colorScheme: ColorScheme.light(
              background: Theme.of(context).colorScheme.primary,
              primary: Theme.of(context).colorScheme.secondary,
            )
        ),
        child: child as Widget,
      ),
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.input,
    );
    if(timeOfDay != null && timeOfDay != selectedTime)
    {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? dateTime = await showDatePicker(
      context: context,
      builder: (context, child)=> Theme(
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.light(
            primary: Theme.of(context).colorScheme.secondary,
          )
        ),
        child: child as Widget,
      ),
      initialDate: selectedDate,
      firstDate: selectedDate,
      lastDate: DateTime(2023, 7),
    );
    if(dateTime != null && dateTime != selectedDate)
    {
      setState(() {
        selectedDate = dateTime;
      });
    }
  }
}
