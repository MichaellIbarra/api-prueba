import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/services/config.dart';

class RegisterPage extends StatefulWidget {
  static const routeName = '/registrar_usuario';

  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    "username": "",
    "password": "",
    "first_name": "",
    "last_name": "",
    "address": "",
    "phone": "",
    "email": "",
    "document_type": "",
    "document_number": 0,
    "user_type": "",
  };

  void _registerUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      final response = await http.post(
        Uri.parse(
            '$baseUrl/api/v1/users/register'), // Cambia la URL según tu API
        headers: {"Content-Type": "application/json"},
        body: json.encode(_formData),
      );

      if (response.statusCode == 201) {
        _showSnackBar("Registro exitoso");
        Navigator.pop(context, true); // Return true to indicate success
      } else {
        _showSnackBar("Error al registrar: ${response.body}");
      }
    }
  } 

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateUsername(String? value) {
    final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9]+$');
    if (value == null || value.isEmpty) {
      return "Ingresa un username";
    } else if (!usernameRegExp.hasMatch(value)) {
      return "El username solo puede contener letras y números";
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final RegExp passwordRegExp =
        RegExp(r'^(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.*[a-zA-Z]).{8,15}$');
    if (value == null || value.isEmpty) {
      return "Ingresa una contraseña";
    } else if (!passwordRegExp.hasMatch(value)) {
      return "La contraseña debe tener entre 8 y 15 caracteres, incluyendo números, letras y caracteres especiales";
    }
    return null;
  }

  String? _validateName(String? value) {
    final RegExp nameRegExp = RegExp(r'^[a-zA-Z\s]+$');
    if (value == null || value.isEmpty) {
      return "Ingresa tu nombre e apellido";
    } else if (!nameRegExp.hasMatch(value)) {
      return "El nombre solo puede contener letras y espacios";
    }
    return null;
  }

  String? _validateAddress(String? value) {
    final RegExp addressRegExp = RegExp(r'^[a-zA-Z0-9\s]+$');
    if (value == null || value.isEmpty) {
      return "Ingresa tu dirección";
    } else if (!addressRegExp.hasMatch(value)) {
      return "La dirección solo puede contener letras, números y espacios";
    }
    return null;
  }

  String? _validatePhone(String? value) {
    final RegExp phoneRegExp = RegExp(r'^9\d{8}$');
    if (value == null || value.isEmpty) {
      return "Ingresa tu teléfono";
    } else if (!phoneRegExp.hasMatch(value)) {
      return "El teléfono debe comenzar con 9 y tener 9 dígitos";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (value == null || value.isEmpty) {
      return "Ingresa un email válido";
    } else if (!emailRegExp.hasMatch(value)) {
      return "Ingresa un email válido con @ y un punto";
    }
    return null;
  }

  String? _validateDocumentNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Ingresa el número de documento";
    }
    if (_formData['document_type'] == "CE") {
      if (value.length < 9 || value.length > 15) {
        return "El número de documento CE debe tener entre 9 y 15 dígitos";
      }
    } else if (_formData['document_type'] == "DNI") {
      if (value.length != 8) {
        return "El número de documento DNI debe tener exactamente 8 dígitos";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro de Usuario")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Username"),
                validator: _validateUsername,
                onSaved: (value) => _formData['username'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: _validatePassword,
                onSaved: (value) => _formData['password'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Nombre"),
                validator: _validateName,
                onSaved: (value) => _formData['first_name'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Apellido"),
                validator: _validateName,
                onSaved: (value) => _formData['last_name'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Dirección"),
                validator: _validateAddress,
                onSaved: (value) => _formData['address'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Teléfono"),
                keyboardType: TextInputType.number,
                validator: _validatePhone,
                onSaved: (value) => _formData['phone'] = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                validator: _validateEmail,
                onSaved: (value) => _formData['email'] = value,
              ),
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: "Tipo de Documento"),
                value: _formData['document_type'].isEmpty
                    ? null
                    : _formData['document_type'],
                items: const [
                  DropdownMenuItem(
                    value: "DNI",
                    child: Text("DNI"),
                  ),
                  DropdownMenuItem(
                    value: "CE",
                    child: Text("CE"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _formData['document_type'] = value ?? '';
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? "Selecciona el tipo de documento"
                    : null,
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Número de Documento"),
                keyboardType: TextInputType.number,
                validator: _validateDocumentNumber,
                onSaved: (value) =>
                    _formData['document_number'] = int.parse(value!),
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Tipo de Usuario"),
                value: _formData['user_type'].isEmpty
                    ? null
                    : _formData['user_type'],
                items: const [
                  DropdownMenuItem(
                    value: "CLIENT",
                    child: Text("CLIENT"),
                  ),
                  DropdownMenuItem(
                    value: "ADMIN",
                    child: Text("ADMIN"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _formData['user_type'] = value ?? '';
                  });
                },
                validator: (value) => value == null || value.isEmpty
                    ? "Selecciona el tipo de usuario"
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text("Registrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
