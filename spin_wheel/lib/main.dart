import 'package:flutter/material.dart';
import 'package:spin_wheel/database.dart' as Store;
import 'package:spin_wheel/pages/home.dart';
import 'package:spin_wheel/pages/loading.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemTheme.accentColor.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future _initFuture = Store.initStore();
  // This widget is the root of your application.
  final lightScheme = ColorScheme.fromSeed(seedColor: Colors.orange);
  final darkScheme = ColorScheme.fromSeed(seedColor: Colors.orange, brightness: Brightness.dark);
  final accentColor = SystemTheme.accentColor;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        //colorSchemeSeed: Colors.orange,
        colorScheme: ColorScheme.fromSeed(seedColor: accentColor.accent),
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 16, color: lightScheme.onSurface, fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 18, color: lightScheme.onPrimaryContainer, fontWeight: FontWeight.w500),
          bodyText2: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          subtitle1: TextStyle(fontSize: 16, color: Color(0xffEE6055), fontWeight: FontWeight.bold),
          headline3: TextStyle(fontSize: 18, color: lightScheme.primaryContainer, fontWeight: FontWeight.bold),
        ),
        //visualDensity: VisualDensity.adaptivePlatformDensity, colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff3CD968)),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: accentColor.accent, brightness: Brightness.dark),
        //colorSchemeSeed: Colors.orange,
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
          headline2: TextStyle(fontSize: 16, color: Colors.white70.withOpacity(0.3), fontWeight: FontWeight.bold),
          bodyText1: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.w500),
          bodyText2: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500),
          subtitle1: TextStyle(fontSize: 16, color: Color(0xffEE6055), fontWeight: FontWeight.bold),
          headline3: TextStyle(fontSize: 18, color: Colors.white70, fontWeight: FontWeight.bold),
        ),
      ),
      themeMode: ThemeMode.system,
      home: InitLoad(),
      debugShowCheckedModeBanner: false,
    );
  }
}

