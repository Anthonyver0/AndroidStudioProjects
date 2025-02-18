import 'package:flutter/material.dart';
import 'login_page.dart';
import 'crud_page.dart';
import 'main_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Odoo Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => MainPage(),
        '/login': (context) => LoginPage(),
        '/crud': (context) => CrudPage(),
      },
    );
  }
}
