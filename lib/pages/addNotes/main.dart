import 'dart:convert';
import 'package:flutter/material.dart';
import '../../jobs.dart';
import 'package:http/http.dart' as http;

Future<Notes> postNotesDB(Map notes ) async{
  var uri;

  uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/notes';

  final response = await http.post(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String,Map>{
      'notes':notes,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Notes.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Notes> deleteNotesDB(String id) async{
  var uri;

  uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/notes/'+id;

  final response = await http.delete(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Notes.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

Future<Notes> putNotesDB(Map notes,String id) async{
  var uri;

  uri = 'https://61d7e596e6744d0017ba8812.mockapi.io/notes/'+id;

  final response = await http.put(
    Uri.parse(uri),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String,Map>{
      'notes':notes,
    }),
  );
  if (response.statusCode == 200) {
    return Notes.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class Notes {

  Null  title;
  Null  desc;

  Notes({
    required this.title,
    required this.desc,
  });

  factory Notes.fromJson(Map<String, dynamic> json) {
    return Notes(
        title: json['title'],
        desc: json['desc']
    );
  }
}

class AddNotesPage extends StatefulWidget {
  AddNotesPage(this.pageState,this.id,this.note);

  final String pageState;
  final String id;
  final Map note;

  @override
  _AddNotesPageState createState()
  {
    return _AddNotesPageState(pageState,id,note);
  }
}

class _AddNotesPageState extends State<AddNotesPage> {
  late Future<Notes>? _futureNotes;

  _AddNotesPageState(this.pageState,this.id,this.note);

  final String pageState;
  final String id;
  final Map note;


  late final titleController = TextEditingController(text:pageState=='edit'?'${note['title']}':'' );

  late final descController = TextEditingController(text:pageState=='edit'?'${note['desc']}':'' );

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
              const SizedBox(height: 200),
              pageState == 'add'?Container(
                width: MediaQuery.of(context).size.width/2,
                height: 50,
                padding: EdgeInsets.only(left:20,right: 20),
                child: ElevatedButton(
                    onPressed: () {
                      var noteTitle='';
                      if(titleController.text==''){
                        noteTitle="Untitled";
                      }
                      else{
                        noteTitle=titleController.text;
                      }

                      Map note= {
                        'title': noteTitle,
                        'desc': descController.text,
                      };

                      setState(() {
                        postNotesDB(note);
                      });

                      Navigator.pop(context);
                    },
                    child:Text("Create Note",style: TextStyle(fontSize: 20),),
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
                                setState(() {
                                  deleteNotesDB(id);
                                });
                                Navigator.pop(context);
                              },
                              child:Text("Delete Note",style: TextStyle(fontSize: 20),),
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
                                var noteTitle='';
                                if(titleController.text==''){
                                  noteTitle="Untitled";
                                }
                                else{
                                  noteTitle=titleController.text;
                                }

                                Map note= {
                                  'title': noteTitle,
                                  'desc': descController.text,
                                };

                                setState(() {
                                  putNotesDB(note, id);
                                });

                                Navigator.pop(context);
                              },
                              child:Text("Save Note",style: TextStyle(fontSize: 20),),
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
}
