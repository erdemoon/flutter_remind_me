import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HealthDetails extends StatelessWidget{
  late final List? data;
  late final String steps;
  late final String distance;

  HealthDetails(
      this.data,
      this.steps,
      this.distance
      );


  @override
  Widget build(BuildContext context) {
    return
        Column(
          children: [
            Tracker('Steps Taken',Icons.run_circle_outlined,steps),
            Tracker('Distance Traveled',Icons.linear_scale_rounded,distance),
            Container(
              margin: EdgeInsets.only(top: 15,bottom: 5,left: 15),
              child: Row(
                children: [
                  Text('Health Todo Trackers',
                      style: TextStyle(
                        fontWeight:FontWeight.w500 ,
                        fontSize:20,
                        color: Theme.of(context).colorScheme.secondaryVariant
                      )
                  ),
                ],
              ),
            ),
            Divider(thickness: .5, color: Theme.of(context).colorScheme.secondaryVariant,indent: 20,endIndent: 20,),
            ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: _returnHealths(data),
            )
          ],
        );

  }
}

List <Widget> _returnHealths(array){
  final List<Widget> _healthWidgets = <Widget>[];
  for( var i=array.length-1; -1<i;i--){
    var todo = array[i].health as Map;
    var id  = array[i].id;

    var repeatArray= todo['repeat'];

    int trackingDays = 0;

    for( var i=0; i<repeatArray.length;i++){
      if (repeatArray[i]){
        trackingDays++;
      }
    }

    if(todo['isRepeat']){
      _healthWidgets.add(Tracker(todo['title'], Icons.check_circle_outline_rounded, '0/'+trackingDays.toString()));
    }
  }
  return _healthWidgets;
}

class Tracker extends StatelessWidget{

  Tracker(
      this.text,
      this.icon,
      this.trackee
      );

  final String text;
  final String trackee;
  final IconData icon;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15,bottom: 10,left: 10),
          child: Row(
            children: [
              Icon(icon,size: 50,color: Theme.of(context).colorScheme.secondaryVariant),
              Text(text,
                  style: TextStyle(
                    fontWeight:FontWeight.w500 ,
                    fontSize:15.5,
                    color: Theme.of(context).colorScheme.secondaryVariant
                  )
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).colorScheme.primary,
          ),
          padding: EdgeInsets.all(15) ,
          margin: EdgeInsets.only(top: 15,bottom: 10,right: 15),
          child: Text(trackee,
              style: TextStyle(
                  fontWeight:FontWeight.w500 ,
                  fontSize:16.5,
                  color: Colors.white
              )
          ),
        )
      ],
    );
  }
}