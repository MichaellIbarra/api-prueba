import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/screens/admin/user/editarPage_screen.dart';
import 'package:myapp/services/assets_manager.dart';
import 'package:myapp/services/config.dart';
import 'package:myapp/widgets/title_text.dart';

class UserslistScreen extends StatefulWidget {
  static const routeName = '/UserslistScreen';
  const UserslistScreen({super.key});

  @override
  State<UserslistScreen> createState() => _UserslistScreenState();
} 

class _UserslistScreenState extends State<UserslistScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController searchTextController;
  List<dynamic> users = [];
  List<dynamic> allUsers = [];
  bool isActive = true;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final status = isActive ? "activos" : "inactivos";
    final response = await http.get(Uri.parse(
        "$baseUrl/api/v1/users/$status"));

    if (response.statusCode == 200) {
      setState(() {
        allUsers = json.decode(response.body);
        users = allUsers;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Error en la conexión :(');
    }
  }

  void toggleActiveStatus() {
    setState(() {
      isActive = !isActive;
      isLoading = true;
    });
    fetchUsers();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _searchUsers(String query) {
    if (query.isEmpty) {
      setState(() {
        users = allUsers;
      });
    } else {
      List<dynamic> filteredList = allUsers.where((user) {
        final fullName = '${user['first_name']} ${user['last_name']}';
        return fullName.toLowerCase().contains(query.toLowerCase());
      }).toList();

      setState(() {
        users = filteredList;
      });
    }
  }

  Widget _buildUserList() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                TextField(
                  controller: searchTextController,
                  decoration: InputDecoration(
                    hintText: "Buscar",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        searchTextController.clear();
                        _searchUsers(''); // Clear search results
                      },
                      child: const Icon(Icons.clear, color: Colors.red),
                    ),
                  ),
                  onChanged: (value) {
                    _searchUsers(value);
                  },
                ),
                const SizedBox(height: 15.0),
                if (searchTextController.text.isNotEmpty && users.isEmpty)
                  const Center(child: Text("No usuarios found")),
                Expanded(
                  child: users.isEmpty
                      ? const Center(child: Text("Usuarios no encontrados"))
                      : ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.all(5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 50.0,
                                      height: 50.0,
                                      child: Image.asset(
                                          AssetsManager.shoppingCart),
                                    ),
                                    const SizedBox(width: 15.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${user['first_name']} ${user['last_name']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                              'Documento: ${user['document_type']} ${user['document_number']}'),
                                          Text('Email: ${user['email']}'),
                                          Text('Teléfono: ${user['phone']}'),
                                          Text('Dirección: ${user['address']}'),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        if (isActive)
                                          IconButton(
                                            icon: const Icon(Icons.edit),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditUserPage(
                                                    userId: user['id_user']
                                                        .toString(),
                                                    userData: user,
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (value == true) {
                                                  fetchUsers();
                                                }
                                              });
                                            },
                                          ),
                                        IconButton(
                                          icon: Icon(isActive
                                              ? Icons.delete
                                              : Icons.restore),
                                          onPressed: () {
                                            eliminarPersona(
                                                user['id_user'].toString(),
                                                isActive);
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const TitlesTextWidget(label: "Usuarios"),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Activos'),
                Tab(text: 'Inactivos'),
              ],
              onTap: (index) {
                setState(() {
                  isLoading = true;
                });
                if (index == 0) {
                  isActive = true;
                } else {
                  isActive = false;
                }
                fetchUsers();
              },
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildUserList(),
              _buildUserList(),
            ],
          ),
          floatingActionButton: Visibility(
            visible: _tabController.index == 0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, "registrar_usuario");
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }

  void eliminarPersona(String id, bool estado) async {
    String title =
        estado ? "Confirmación de Eliminación" : "Confirmación de Restauración";
    String content = estado
        ? "¿Estás seguro que quieres eliminar a este usuario?"
        : "¿Estás seguro que quieres restaurar a este usuario?";

    final confirmAction = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text("Sí"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmAction == true) {
      try {
        setState(() {
          users.removeWhere((user) => user['id_user'].toString() == id);
        });
        _showSnackBar(
            "${estado ? 'Eliminado' : 'Restaurado'} exitoso persona con id: $id");
      } catch (error) {
        _showSnackBar("Error al eliminar/restaurar persona: $error");
      }
    } else {
      _showSnackBar("Acción cancelada");
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
