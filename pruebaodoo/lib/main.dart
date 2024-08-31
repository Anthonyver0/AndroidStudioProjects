import 'package:flutter/material.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

final orpc = OdooClient('http://192.168.1.115:8069');

void main() async {
  await orpc.authenticate('admin', 'admin', 'admin');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Future<dynamic> fetchIncidencias() {
    return orpc.callKw({
      'model': 'incidencia.incidencia',
      'method': 'search_read',
      'args': [],
      'kwargs': {
        'context': {'bin_size': true},
        'domain': [['profesor', '!=', '']],  // Filtra las incidencias que tienen profesor
        'fields': ['profesor', 'descripcion'],
        'limit': 80,
      },
    });
  }

  Widget buildListItem(Map<String, dynamic> record) {
    return ListTile(
      title: Text(record['profesor'] ?? ''),
      subtitle: Text(record['descripcion'] ?? ''),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Incidencias'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchIncidencias(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  final record = snapshot.data[index] as Map<String, dynamic>;
                  return buildListItem(record);
                },
              );
            } else {
              if (snapshot.hasError) return Text('Unable to fetch data');
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
