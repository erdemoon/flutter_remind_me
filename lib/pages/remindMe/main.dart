import 'package:flutter/material.dart';
import 'sub_pages/health/main.dart';
import 'sub_pages/todo/main.dart';


class RemindMePage extends StatefulWidget {
  @override
  State<RemindMePage> createState() => _RemindMePageState();
}
class _RemindMePageState extends State<RemindMePage>{


  String _remindMe = 'todo';
  late List<Color> _todoColor =[Theme.of(context).colorScheme.secondary,
    Theme.of(context).colorScheme.primary,];
  late List<Color> _healthColor=[Color(0xffbcbcbc),Color(0xffbcbcbc)] ;


  void _changeTab(tab) {
    setState(() {
      _remindMe = tab;
    });
  }

  void _changeColor(){
    setState((){
      if(_remindMe=="todo"){
        _todoColor = [Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.primary,];
        _healthColor =[Color(0xffbcbcbc),Color(0xffbcbcbc)];
      }
      else{
        _todoColor = [Color(0xffbcbcbc),Color(0xffbcbcbc)];
        _healthColor =[Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.primary,];
      }
    });
  }

  Widget getRemindMeTab(){
    _changeColor();
    switch(_remindMe){
      case "todo":
        return TodoTab();
      case "health":
        return HealthTab();
    }
    return TodoTab();
  }

  @override
  Widget build(BuildContext context){




    return Column(
      children: [
        Container(
          color:  Theme.of(context).colorScheme.background,
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration( boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ),
                width: MediaQuery.of(context).size.width/2.4,
                height: 35,
                margin: const EdgeInsets.only(left: 20.0,right: 10,bottom: 15),
                child: OutlinedButton(
                    onPressed: (){
                      _changeTab('todo');
                      _changeColor();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration:BoxDecoration(
                          gradient: LinearGradient(
                            colors: _todoColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 175.0, maxHeight: 40.0),
                        alignment: Alignment.center,
                        child: const Text(
                          "Remind Me Todo",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    )
                ),
              ),
              Container(
                decoration: BoxDecoration( boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ),
                margin: const EdgeInsets.only(left: 10.0,right: 20,bottom: 15),
                width: MediaQuery.of(context).size.width/2.4,
                height: 35,
                child: OutlinedButton(
                    onPressed: (){
                      _changeTab('health');
                      _changeColor();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _healthColor,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(8)
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 175.0, maxHeight: 40.0),
                        alignment: Alignment.center,
                        child: const Text(
                          "Remind Me Health",
                          style: TextStyle(
                              color: Colors.white
                          ),
                        ),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    )
                ),
              ),
            ],

          ),
        ),
        Expanded(child:getRemindMeTab())

      ],
    );
  }
}