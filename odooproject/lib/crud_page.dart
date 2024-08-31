import 'package:flutter/material.dart';

class CrudPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Page'),
      ),
      body: Center(
        child: Text('Aquí se mostrarán los datos de incidencias'),
      ),
    );
  }
}
