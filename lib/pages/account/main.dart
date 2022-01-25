import 'package:flutter/material.dart';
import '../../jobs.dart';

class AccountPage extends StatelessWidget {
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
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ,
                color: Theme.of(context).colorScheme.background
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text('Sign in with Apple',
                      style: TextStyle(
                          fontWeight:FontWeight.w500 ,
                          fontSize:20,
                          color: Theme.of(context).colorScheme.secondaryVariant
                      )
                  ),
                ),

              ],
            ),
          ),
          Container(
            height: 50,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(spreadRadius: 2.5,color: Color.fromRGBO(0, 0, 0,0.2),blurRadius: 10)] ,
                color: Theme.of(context).colorScheme.background
            ),
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text('Sign in with Google',
                      style: TextStyle(
                          fontWeight:FontWeight.w500 ,
                          fontSize:20,
                          color: Theme.of(context).colorScheme.secondaryVariant
                      )
                  ),
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}

