import 'package:flutter/material.dart';
import 'package:odoo/odoo.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Odoo Connection Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final odoo = Odoo(Connection(url: Url(Protocol.http, "192.168.1.115", 8069), db: 'proyecto'));
  String _connectionStatus = "Not connected";

  @override
  void initState() {
    super.initState();
    _connectToOdoo();
  }

  Future<void> _connectToOdoo() async {
    try {
      print("Attempting to connect...");
      final user = await odoo.connect(Credential("admin", "admin"));
      print("Connection successful: ${user.name}");
      setState(() {
        _connectionStatus = "Connected: ${user.name}";
      });
    } catch (e) {
      print("Connection failed: $e");
      setState(() {
        _connectionStatus = "Failed to connect: $e";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Odoo Connection Demo'),
      ),
      body: Center(
        child: Text(_connectionStatus),
      ),
    );
  }
}
