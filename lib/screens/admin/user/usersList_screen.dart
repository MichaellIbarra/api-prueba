// search_screen.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';
import 'package:myapp/widgets/product_widget.dart';
import 'package:myapp/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:myapp/pages/users/EditarPage.dart';

class UserslistScreen extends StatefulWidget {
  static const routeName = '/UserslistScreen';
  const UserslistScreen({super.key});

  @override
  State<UserslistScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<UserslistScreen>
    with SingleTickerProviderStateMixin {
   List<dynamic> users = [];
  bool isActive = true;
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }


  Future<void> fetchUsers() async {
    final status = isActive ? "activos" : "inactivos";
    final response = await http.get(Uri.parse(
        "https://psychic-capybara-4xvq5g9x97j377v5-8085.app.github.dev/api/v1/users/$status"));

    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
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
    });
    fetchUsers();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _tabController.dispose();
    super.dispose();
  }


  Widget _buildProductList(bool isActive) {
    List<ProductModel> filteredProductList =
        isActive ? productList : inactiveProductList;
    List<ProductModel> productListSearch =
        isActive ? this.productListSearch : inactiveProductListSearch;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredProductList.isEmpty
            ? const Center(child: TitlesTextWidget(label: "Productos no encontrado"))
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
                            _searchProducts(
                                '', isActive); // Clear search results
                          },
                          child: const Icon(Icons.clear, color: Colors.red),
                        ),
                      ),
                      onChanged: (value) {
                        _searchProducts(value, isActive);
                      },
                    ),
                    const SizedBox(height: 15.0),
                    if (searchTextController.text.isNotEmpty &&
                        productListSearch.isEmpty)
                      const Center(
                          child: TitlesTextWidget(label: "No products found")),
                    Expanded(
                      child: GridView.builder(
                        itemCount: searchTextController.text.isNotEmpty
                            ? productListSearch.length
                            : filteredProductList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product = searchTextController.text.isNotEmpty
                              ? productListSearch[index]
                              : filteredProductList[index];
                          return ProductWidget(
                            product: product,
                            isActive: isActive,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditOrUploadProductScreen(
                                          productModel: product),
                                ),
                              );
                              // Refetch products after returning from edit screen
                              if (isActive) {
                                _fetchProducts();
                              } else {
                                _fetchInactiveProducts();
                              }
                            },
                            onDelete: () {
                              if (isActive) {
                                _fetchProducts();
                              } else {
                                _fetchInactiveProducts();
                              }
                            },
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
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TitlesTextWidget(label:  "Lista de\nUsuarios ${isActive ? 'Activos' : 'Inactivos'}",),
            
          ),
          body: TabBarView(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.5, right: 12.5),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Container(
                    padding: const EdgeInsets.all(20.0),
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 182, 203, 180),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50.0,
                          height: 50.0,
                          child: Image.asset("assets/clientIcon.png"),
                        ),
                        const SizedBox(width: 15.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                      builder: (context) => EditUserPage(
                                        userId: user['id_user'].toString(),
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
                              icon:
                                  Icon(isActive ? Icons.delete : Icons.restore),
                              onPressed: () {
                                eliminarPersona(
                                    user['id_user'].toString(), isActive);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
           Container(
              height: 62.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 28, 100, 13),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "panel");
                    },
                    child: const Icon(Icons.dock_outlined),
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "registrar_usuario");
                    },
                    child: const Icon(Icons.add),
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  ElevatedButton(
                    onPressed: toggleActiveStatus,
                    child: const Icon(Icons.delete),
                  ),
                ],
              ))
          ),
         
        ),
      ),
    );
  }
}

  void eliminarPersona(String id, bool estado) async {
    // Mensaje de confirmación según la acción
    String title =
        estado ? "Confirmación de Eliminación" : "Confirmación de Restauración";
    String content = estado
        ? "¿Estás seguro que quieres eliminar a este usuario?"
        : "¿Estás seguro que quieres restaurar a este usuario?";

    // Mostrar un diálogo de confirmación
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
                Navigator.of(context)
                    .pop(false); // Cierra el diálogo y devuelve false
              },
            ),
            TextButton(
              child: const Text("Sí"),
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Cierra el diálogo y devuelve true
              },
            ),
          ],
        );
      },
    );

    // Si el usuario confirma la acción
    if (confirmAction == true) {
      try {
        if (estado) {
          final response = await http.put(Uri.parse(
              'https://psychic-capybara-4xvq5g9x97j377v5-8085.app.github.dev/api/v1/users/$id/inactivar'));

          setState(() {
            users.removeWhere((user) => user['id_user'].toString() == id);
          });
          _showSnackBar("Eliminado exitoso persona con id: $id");
        } else {
          final response = await http.put(Uri.parse(
              'https://psychic-capybara-4xvq5g9x97j377v5-8085.app.github.dev/api/v1/users/$id/restaurar'));

          setState(() {
            users.removeWhere((user) => user['id_user'].toString() == id);
          });
          _showSnackBar("Restaurado exitoso persona con id: $id");
        }
      } catch (error) {
        _showSnackBar("Error al eliminar/restaurar persona: $error");
      }
    } else {
      _showSnackBar("Acción cancelada");
    }
  }
}
