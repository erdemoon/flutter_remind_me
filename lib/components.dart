import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import './jobs.dart';
import 'package:remind_me/pages/account/main.dart';
import 'package:remind_me/pages/setting/main.dart';
import 'package:remind_me/pages/notes/main.dart';

//----DrawerMenu
class DrawerMenu extends StatelessWidget{

  DrawerMenu(this.changeTheme);

  final Function changeTheme;

  @override
  Widget build(BuildContext context){
    return Container(
      width: 200,
      child:Drawer(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: <Widget>[
                Expanded(
                    child:ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Container(
                          color: Theme.of(context).colorScheme.background,
                          height: 120.0,
                          child:  DrawerHeader(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:[
                                  Text('Name Surname',style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant),),
                                  const SizedBox(height: 10),
                                  RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          children: [
                                            WidgetSpan(alignment: ui.PlaceholderAlignment.middle,child: Icon(Icons.location_pin,color: Theme.of(context).colorScheme.secondaryVariant,))
                                            ,TextSpan(text:"Beykent University",style: TextStyle(color: Theme.of(context).colorScheme.secondaryVariant),)
                                          ]
                                      )
                                  )
                                ]
                            ),
                          ),
                        ),
                        ListTile(
                          title: MenuText(
                            Icons.account_box_rounded,
                            "Account"
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true).push(
                               CupertinoPageRoute<bool>(
                                fullscreenDialog: false,
                                builder: (BuildContext context) =>  AccountPage(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: MenuText(
                            Icons.settings_applications_rounded,
                            "Settings"
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: false,
                                builder: (BuildContext context) =>  SettingsPage(changeTheme),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: MenuText(
                            Icons.sticky_note_2_rounded,
                            "Notes"
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context, rootNavigator: true).push(
                              CupertinoPageRoute<bool>(
                                fullscreenDialog: false,
                                builder: (BuildContext context) =>  NotesPage(),
                              ),
                            );
                          },
                        ),
                      ],
                    )
                ),
                ListTile(
                  title: MenuText(
                    Icons.exit_to_app_rounded,
                    "Signout"
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
      ),
    );
  }
}

