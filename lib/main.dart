import 'package:akb/HalamanUtama.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: <String, WidgetBuilder> {
        'halamanUtama': (BuildContext context) => HalamanUtama()
      },
      title: 'Atma Jaya Bbq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HalamanUtama(),
      debugShowCheckedModeBanner: false,
    );
  }
}
