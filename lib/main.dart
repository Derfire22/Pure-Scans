import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pure_scans/screens/home_screen.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('bookmarked');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pure Scans',
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(scheme: FlexScheme.redWine),
        darkTheme: FlexThemeData.dark(scheme: FlexScheme.redWine),
        themeMode: ThemeMode.system,
        home: const HomeScreen());
  }
}
