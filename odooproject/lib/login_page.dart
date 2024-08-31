import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<bool> _login(String username, String password) async {
    final String url = 'http://192.168.1.115:8069'; // Cambia esto por la URL de tu servidor Odoo
    final String dbName = 'proyecto';
    //5db7177d201ee022f44a77ff4721b097a3930c61

    try {
      final response = await http.post(
        Uri.parse('$url/web/session/authenticate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'jsonrpc': '2.0',
          'params': {
            'db': dbName,
            'login': username,
            'password': password,
          },
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['result'] != null && result['result']['authenticated'] == true) {
          return true; // Autenticación exitosa
        } else {
          return false; // Autenticación fallida
        }
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error de conexión con el servidor Odoo');
    }
  }

  void _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final isLoggedIn = await _login(username, password);
      if (isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/crud');
      } else {
        _showErrorDialog('Nombre de usuario o contraseña incorrectos.');
      }
    } catch (e) {
      _showErrorDialog('Error de conexión con el servidor.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error de inicio de sesión'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión en Odoo'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(hintText: 'Nombre de usuario'),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(hintText: 'Contraseña'),
              ),
              SizedBox(height: 32),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _handleLogin,
                child: Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
