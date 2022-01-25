import 'package:flutter/material.dart';
import 'package:remind_me/components.dart';
import './jobs.dart';
import './pages/remindMe/main.dart';
import 'package:get/get.dart';
import './controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Remind Me',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Color(0xffb295e9),primary: Color(0xff8179f2),primaryVariant: Color(0xffe1bbff),secondaryVariant: Colors.black,background: Colors.white,surface: Color(0xff2e548a)
            )),
      darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
              brightness: Brightness.dark,secondary: Color(0xff14c9cb),primary: Color(0xff1D9BF0),primaryVariant: Color(0xff00dcff),secondaryVariant: Colors.white,background: Color(0xff1e1e1e),surface: Colors.white)
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(title: 'Remind Me'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  late ThemeData themeData;
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final Controller controller = Get.put(Controller());

  refreshPage(){
    setState(() {
    });
  }

  changeTheme(theme){
    setState(() {
      switch(theme){
        case 'dark':
          Get.changeThemeMode(ThemeMode.dark);
          break;
        case 'light':
          Get.changeThemeMode(ThemeMode.system);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: GradientIcon(
                  Icons.menu_rounded,
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
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
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
      body: Container(
        color: Theme.of(context).colorScheme.background,
        child:RemindMePage()

      ),
       drawer: DrawerMenu(changeTheme)
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
