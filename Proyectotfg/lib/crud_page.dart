import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyectotfg/odooInstance.dart';
import 'package:image_picker/image_picker.dart';


class CrudPage extends StatefulWidget {
  @override
  _CrudPageState createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  List<Actuacion> _actuaciones = [];
  late OdooService odooService;

  @override
  void initState() {
    super.initState();
    odooService = OdooService(
      url: 'http://192.168.1.115:8069',
      db: 'admin',
      username: 'admin',
      password: 'admin',
    );
    _authenticateAndLoadActuaciones();
  }

  Future<void> _authenticateAndLoadActuaciones() async {
    bool isAuthenticated = await odooService.authenticate();
    if (!isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Autenticación fallida')),
      );
    } else {
      List<Actuacion> localActuaciones = await odooService.loadActuacionesFromLocal();
      setState(() {
        _actuaciones = localActuaciones;
      });
    }
  }

  Future<void> _addOrEditActuacion({Actuacion? actuacion, bool isEdit = false}) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String? name, rmiId, descripcion, estadoId, foto;

    // Nueva función para seleccionar una imagen
    Future<XFile?> pickImage() async {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      return pickedFile;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Editar Actuacion' : 'Agregar Actuacion'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    initialValue: isEdit ? actuacion?.name : '',
                    decoration: InputDecoration(labelText: 'Nombre'),
                    onSaved: (value) => name = value,
                    validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    initialValue: isEdit ? actuacion?.rmiId : '',
                    decoration: InputDecoration(labelText: 'RMI ID'),
                    onSaved: (value) => rmiId = value,
                    validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    initialValue: isEdit ? actuacion?.descripcion : '',
                    decoration: InputDecoration(labelText: 'Descripción'),
                    onSaved: (value) => descripcion = value,
                    validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    initialValue: isEdit ? actuacion?.estadoId : '',
                    decoration: InputDecoration(labelText: 'Estado ID'),
                    onSaved: (value) => estadoId = value,
                    validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
                  ),
                  TextFormField(
                    initialValue: isEdit ? actuacion?.foto : '',
                    decoration: InputDecoration(labelText: 'Foto URL'),
                    onSaved: (value) => foto = value,
                    readOnly: true, // El campo de texto de la URL de la foto ahora es solo de lectura
                    onTap: () async {
                      // Mostrar el selector de imagen cuando se toque el campo
                      XFile? imageFile = await pickImage();
                      if (imageFile != null) {
                        setState(() {
                          foto = imageFile.path;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    if (isEdit) {
                      actuacion!.name = name!;
                      actuacion.rmiId = rmiId!;
                      actuacion.descripcion = descripcion!;
                      actuacion.estadoId = estadoId!;
                      actuacion.foto = foto!;
                    } else {
                      final newActuacion = Actuacion(
                        id: DateTime.now().toString(),
                        name: name!,
                        rmiId: rmiId!,
                        descripcion: descripcion!,
                        estadoId: estadoId!,
                        foto: foto!,
                      );
                      _actuaciones.add(newActuacion);
                      _createActuacionInOdoo(newActuacion);
                    }
                  });
                  await odooService.saveActuacionesToLocal(_actuaciones);
                  Navigator.of(context).pop();
                }
              },
              child: Text(isEdit ? 'Guardar' : 'Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createActuacionInOdoo(Actuacion actuacion) async {
    final actuacionData = {
      'name': actuacion.name,
      'rmi_id': actuacion.rmiId,
      'descripcion': actuacion.descripcion,
      'estado_id': actuacion.estadoId,
      'foto': actuacion.foto,
    };

    try {
      final id = await odooService.create('incidencia.actuacion', actuacionData);
      print('ID devuelto por Odoo: $id');
      if (id != null) {
        print('Actuacion creada con ID: $id');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la actuación en Odoo: ID nulo')),
        );
      }
    } catch (e) {
      print('Error al crear la actuación en Odoo: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear la actuación en Odoo: $e')),
      );
    }
  }


  void _deleteActuacion(String id) {
    setState(() {
      _actuaciones.removeWhere((actuacion) => actuacion.id == id);
    });
    odooService.saveActuacionesToLocal(_actuaciones);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Page'),
      ),
      body: ListView.builder(
        itemCount: _actuaciones.length,
        itemBuilder: (context, index) {
          final actuacion = _actuaciones[index];
          return ListTile(
            leading: actuacion.foto.isNotEmpty
                ? Image.network(actuacion.foto, width: 50, height: 50)
                : null,
            title: Text(actuacion.name),
            subtitle: Text(actuacion.descripcion),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _addOrEditActuacion(actuacion: actuacion, isEdit: true),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteActuacion(actuacion.id),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrEditActuacion(),
        child: Icon(Icons.add),
      ),
    );
  }
}

