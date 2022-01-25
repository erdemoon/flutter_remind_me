import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../jobs.dart';
import 'package:http/http.dart' as http;
import '../addNotes/main.dart';

Future <List<Notes>> fetchNotes() async{
  final response = await http.get(Uri.parse('https://61d7e596e6744d0017ba8812.mockapi.io/notes'),
      headers: {"Content-type": "application/json"});

  if(response.statusCode == 200){
    List jsonResponse = json.decode(response.body);

    return jsonResponse.map((notes) => Notes.fromJson(notes)).toList();
  }
  else{
    throw Exception('Unexpected error occured!');
  }
}

class Notes {

  final Object notes;
  final String  id;

  Notes({
    required this.notes,
    required this.id,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
        notes: json['notes'],
        id: json['id']
    );
  }
}

class NotesPage extends StatefulWidget{
  NotesPage({UniqueKey? key}) : super(key:key);

  @override
  _NotesPageState createState()=> _NotesPageState();
}

class _NotesPageState extends State<NotesPage>{

  Future <List<Notes>>? futureNotes;

  @override
  void initState() {
    super.initState();
    futureNotes = fetchNotes();
  }

  refreshData(){
    setState(() {
    });
    futureNotes = fetchNotes();
    return futureNotes;
  }

  refreshPage(){
    setState(() {
    });
  }

  @override
  Widget build (BuildContext context) {
    return
      Scaffold(
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
              actions: [IconButton(
                padding: EdgeInsets.only(right: 10,top: 5),
                icon: GradientIcon(
                  Icons.refresh,
                  40.0,
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
                  refreshPage();
                },
              )
              ],
            )
        ),
        body: FutureBuilder <List<Notes>>(
            future: refreshData(),
            builder: (context,snapshot){
              if(snapshot.hasData){
                List<Notes>? data = snapshot.data;
                return ListView(
                    children: _returnNotes(data,refreshData));
              }
              else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              return Container();
            }
        ),
    );
  }
}


List <Widget> _returnNotes(array,refreshData){
  final List<Widget> _healthWidgets = <Widget>[];

  _healthWidgets.add(AddNoteButton(refreshData));
  for( var i=array.length-1; -1<i;i--){
    var note = array[i].notes as Map;
    var id  = array[i].id;
    _healthWidgets.add(Note(note, id,refreshData));
  }
  return _healthWidgets;
}

class AddNoteButton extends StatelessWidget {

  AddNoteButton(
       this.refreshData
      );

  final Function() refreshData;



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
                builder: (BuildContext context) =>  AddNotesPage('add','0',{}),
              ),
            ).then((value) => refreshData());
          },
          child: Row(
            children: [
              Icon(Icons.add_rounded,size: 60,color: Colors.white,),
              Text('New Note',style: TextStyle(color: Colors.white,fontSize: 30),)
            ],
          ),
          style: OutlinedButton.styleFrom(
              padding: EdgeInsets.all(0.0),
              backgroundColor: Theme.of(context).colorScheme.primaryVariant,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              )
          )
      ),
    );
  }
}

class Note extends StatelessWidget {

  Note(
      this.note,
      this.id,
      this.refreshData,
      );

  final Function() refreshData;

  final Map note;
  final String id;



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
                builder: (BuildContext context) =>  AddNotesPage('edit',id,note),
              ),
            ).then((value) => refreshData());
          },
          child: Row(
            children: [
              Container(height:60,
                  child: Align(alignment: Alignment.centerLeft,
                      child: Padding(padding: EdgeInsets.only(left: 15),
                          child: Text(note['title'],style: TextStyle(color: Colors.white,fontSize: 30),)
                      )
                  )
              )
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
