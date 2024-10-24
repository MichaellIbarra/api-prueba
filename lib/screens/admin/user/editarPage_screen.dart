import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/services/config.dart';

class EditUserPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditUserPage({super.key, required this.userId, required this.userData});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final _formKey = GlobalKey<FormState>();
  late String username;
  late String password;
  late String firstName;
  late String lastName;
  late String address;
  late String phone;
  late String email;
  late String documentType;
  late int documentNumber;
  late String userType;

  final List<String> documentTypes = ['DNI', 'CE'];
  final List<String> userTypes = ['CLIENT', 'ADMIN'];

  @override
  void initState() {
    super.initState();
    // Prellena los campos con los datos existentes
    username = widget.userData['username'];
    password = widget.userData['password'];
    firstName = widget.userData['first_name'];
    lastName = widget.userData['last_name'];
    address = widget.userData['address'];
    phone = widget.userData['phone'];
    email = widget.userData['email'];
    documentType = widget.userData['document_type'];
    documentNumber = widget.userData['document_number'];
    userType = widget.userData['user_type'];
  }

  Future<void> updateUser() async {
    final response = await http.put(
      Uri.parse(
          '$baseUrl/api/v1/users/update/${widget.userId}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'address': address,
        'phone': phone,
        'email': email,
        'document_type': documentType,
        'document_number': documentNumber,
        'user_type': userType,
      }),
    );
 
    if (response.statusCode == 200) {
      Navigator.pop(context, true); // Regresa a la pantalla anterior
    } else {
      // Manejar el error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al actualizar el usuario.'),
      ));
    }
  }

  String? validateNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    const pattern = r'^[a-zA-Z0-9]+$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Solo se permiten letras y números';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length < 8 || value.length > 15) {
      return 'La contraseña debe tener entre 8 y 15 caracteres';
    }

    // Comprobar si contiene al menos un número, una letra y un carácter especial
    bool hasLetter = value.contains(RegExp(r'[a-zA-Z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacter =
        value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasLetter || !hasDigit || !hasSpecialCharacter) {
      return 'La contraseña debe contener letras, números y caracteres especiales';
    }

    return null;
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    const pattern = r'^[a-zA-Z\s]+$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Solo se permiten letras y espacios';
    }
    return null;
  }

  String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    const pattern = r'^[a-zA-Z0-9\s]+$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Solo se permiten letras, números y espacios';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    if (value.length != 9 || !value.startsWith('9')) {
      return 'El número de teléfono debe comenzar con 9 y tener 9 dígitos';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    const pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Ingrese un correo electrónico válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: username,
                decoration: const InputDecoration(labelText: 'Username'),
                onChanged: (value) => username = value,
                validator: validateUsername,
              ),
              TextFormField(
                initialValue: password,
                decoration: const InputDecoration(labelText: 'Password'),
                onChanged: (value) => password = value,
                obscureText: true,
                validator: validatePassword,
              ),
              TextFormField(
                initialValue: firstName,
                decoration: const InputDecoration(labelText: 'First Name'),
                onChanged: (value) => firstName = value,
                validator: validateName,
              ),
              TextFormField(
                initialValue: lastName,
                decoration: const InputDecoration(labelText: 'Last Name'),
                onChanged: (value) => lastName = value,
                validator: validateName,
              ),
              TextFormField(
                initialValue: address,
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => address = value,
                validator: validateAddress,
              ),
              TextFormField(
                initialValue: phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                onChanged: (value) => phone = value,
                validator: validatePhone,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: validateEmail,
              ),
              DropdownButtonFormField<String>(
                value: documentType,
                decoration:
                    const InputDecoration(labelText: 'Tipo de Documento'),
                items: documentTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    documentType = value!;
                  });
                },
                validator: validateNotEmpty,
              ),
              TextFormField(
                initialValue: documentNumber.toString(),
                decoration: const InputDecoration(labelText: 'Document Number'),
                keyboardType: TextInputType.number,
                onChanged: (value) => documentNumber = int.tryParse(value) ?? 0,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Este campo es obligatorio';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Ingrese un número válido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: userType,
                decoration: const InputDecoration(labelText: 'Tipo de Usuario'),
                items: userTypes.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    userType = value!;
                  });
                },
                validator: validateNotEmpty,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUser();
                  }
                },
                child: const Text('Actualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
