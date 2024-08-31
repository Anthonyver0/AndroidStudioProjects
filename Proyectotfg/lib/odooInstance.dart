import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:xml_rpc/client.dart' as xml_rpc;



class OdooService {
  final String url;
  final String db;
  final String username;
  final String password;
  int? uid;

  OdooService({
    required this.url,
    required this.db,
    required this.username,
    required this.password,
  });

  Future<bool> authenticate() async {
    final uri = Uri.parse('$url/xmlrpc/2/common');
    final response = await xml_rpc.call(
      uri,
      'authenticate',
      [db, username, password, {}],
    );

    if (response is int) {
      uid = response;
      return true;
    }
    return false;
  }

  Future<int?> create(String model, Map<String, dynamic> values) async {
    if (uid == null) return null;

    final uri = Uri.parse('$url/xmlrpc/2/object');
    try {
      final response = await xml_rpc.call(
        uri,
        'execute_kw',
        [db, uid, password, model, 'create', [values]],
      );

      if (response is int) {
        return response;
      }
      print('Error response: $response');
    } catch (e) {
      print('Exception: $e');
    }
    return null;
  }

  Future<void> saveActuacionesToLocal(List<Actuacion> actuaciones) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> actuacionesJson = actuaciones.map((actuacion) => jsonEncode(actuacion.toJson())).toList();
    await prefs.setStringList('actuaciones', actuacionesJson);
  }

  Future<List<Actuacion>> loadActuacionesFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? actuacionesJson = prefs.getStringList('actuaciones');
    if (actuacionesJson != null) {
      return actuacionesJson.map((json) => Actuacion.fromJson(jsonDecode(json))).toList();
    }
    return [];
  }
}

class Actuacion {
  String id;
  String name;
  String rmiId;
  String descripcion;
  String estadoId;
  String foto;

  Actuacion({
    required this.id,
    required this.name,
    required this.rmiId,
    required this.descripcion,
    required this.estadoId,
    required this.foto,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rmiId': rmiId,
      'descripcion': descripcion,
      'estadoId': estadoId,
      'foto': foto,
    };
  }

  factory Actuacion.fromJson(Map<String, dynamic> json) {
    return Actuacion(
      id: json['id'],
      name: json['name'],
      rmiId: json['rmiId'],
      descripcion: json['descripcion'],
      estadoId: json['estadoId'],
      foto: json['foto'],
    );
  }
}
