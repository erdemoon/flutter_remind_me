import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../jobs.dart';
import '../../controller.dart';

class SettingsPage extends StatefulWidget{
  SettingsPage(this.changeTheme);

  final Function changeTheme;

  @override
  _SettingsPageState createState()=> _SettingsPageState(changeTheme);
}

class _SettingsPageState extends State<SettingsPage> {

  _SettingsPageState(this.changeTheme);

  final Function changeTheme;

  late bool isSwitchOn = Get.isDarkMode;

  final Controller controller = Get.find();


  @override
  Widget build (BuildContext context) {
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
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ,
                color: Theme.of(context).colorScheme.background
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Dark Mode',
                      style: TextStyle(
                          fontWeight:FontWeight.w500 ,
                          fontSize:20,
                          color: Theme.of(context).colorScheme.secondaryVariant
                      )
                  ),
                ),
                Switch(
                  value: isSwitchOn,
                  onChanged: (value) {
                    setState(() {
                      isSwitchOn = !isSwitchOn;
                      isSwitchOn ? changeTheme('dark'):changeTheme('light');
                    });
                  },
                  activeTrackColor: Colors.grey,
                  activeColor: Colors.white,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ,
                color: Theme.of(context).colorScheme.background
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text('Conversion Unit',
                      style: TextStyle(
                          fontWeight:FontWeight.w500 ,
                          fontSize:20,
                          color: Theme.of(context).colorScheme.secondaryVariant
                      )
                  ),
                ),
                const SizedBox(width: 40),
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        controller.changeUnit('metric'.obs);
                      });
                    },
                    child: Text('Metric'),
                    style: ElevatedButton.styleFrom(
                      primary:  controller.conventionUnit=='metric'?Theme.of(context).colorScheme.secondary: Color(0xffbcbcbc),
                    )
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: (){
                    setState(() {
                      controller.changeUnit('imperial'.obs);
                    });
                    },
                    child: Text('Imperial'),
                    style: ElevatedButton.styleFrom(
                      primary: controller.conventionUnit!='metric'?Theme.of(context).colorScheme.secondary: Color(0xffbcbcbc),
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


}