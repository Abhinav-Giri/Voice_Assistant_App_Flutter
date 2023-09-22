import 'package:flutter/material.dart';

import 'home_page.dart';
import 'pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(useMaterial3: true).copyWith(scaffoldBackgroundColor: Color.fromARGB(255, 238, 243, 245),
      appBarTheme: const AppBarTheme(backgroundColor: Color.fromARGB(255, 191, 222, 236))),
      home: HomePage(),
    );
  }
}
