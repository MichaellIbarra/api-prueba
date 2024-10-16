// search_screen.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';
import '../widgets/product_widget.dart';
import '../widgets/title_text.dart';
import 'edit_upload_product_form.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TextEditingController searchTextController;
  List<ProductModel> productList = [];
  List<ProductModel> productListSearch = [];
  List<ProductModel> inactiveProductList = [];
  List<ProductModel> inactiveProductListSearch = [];
  bool isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
    _fetchProducts();
    _fetchInactiveProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<ProductModel> products = await ProductService.fetchProducts();
      setState(() {
        productList = products;
        productListSearch = products; // Initialize search list
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  Future<void> _fetchInactiveProducts() async {
    try {
      List<ProductModel> products = await ProductService.fetchInactiveProducts();
      setState(() {
        inactiveProductList = products;
        inactiveProductListSearch = products; // Initialize search list
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle error
    }
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _searchProducts(String query, bool isActive) {
    List<ProductModel> filteredList = isActive ? productList : inactiveProductList;
    List<ProductModel> searchList = filteredList
        .where((product) => product.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      if (isActive) {
        productListSearch = searchList;
      } else {
        inactiveProductListSearch = searchList;
      }
    });
  }

  Widget _buildProductList(bool isActive) {
    List<ProductModel> filteredProductList = isActive ? productList : inactiveProductList;
    List<ProductModel> productListSearch = isActive ? this.productListSearch : inactiveProductListSearch;

    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : filteredProductList.isEmpty
            ? const Center(child: TitlesTextWidget(label: "No product found"))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15.0),
                    TextField(
                      controller: searchTextController,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            searchTextController.clear();
                            _searchProducts('', isActive); // Clear search results
                          },
                          child: const Icon(Icons.clear, color: Colors.red),
                        ),
                      ),
                      onChanged: (value) {
                        _searchProducts(value, isActive);
                      },
                    ),
                    const SizedBox(height: 15.0),
                    if (searchTextController.text.isNotEmpty && productListSearch.isEmpty)
                      const Center(child: TitlesTextWidget(label: "No products found")),
                    Expanded(
                      child: GridView.builder(
                        itemCount: searchTextController.text.isNotEmpty ? productListSearch.length : filteredProductList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          final product = searchTextController.text.isNotEmpty ? productListSearch[index] : filteredProductList[index];
                          return ProductWidget(
                            product: product,
                            isActive: isActive,
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditOrUploadProductScreen(productModel: product),
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
    String? passedCategory = ModalRoute.of(context)!.settings.arguments as String?;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TitlesTextWidget(label: passedCategory ?? "Search products"),
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
                  _fetchProducts();
                } else {
                  _fetchInactiveProducts();
                }
              },
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildProductList(true),
              _buildProductList(false),
            ],
          ),
          floatingActionButton: Visibility(
            visible: _tabController.index == 0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, EditOrUploadProductScreen.routeName);
              },
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}