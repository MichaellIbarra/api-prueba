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

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  List<ProductModel> productList = [];
  List<ProductModel> productListSearch = [];
  bool isLoading = true;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      List<ProductModel> products = await ProductService.fetchProducts();
      setState(() {
        productList = products;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> filteredProductList = passedCategory == null
        ? productList
        : productList
            .where((product) => product.idCategory == int.parse(passedCategory))
            .toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitlesTextWidget(label: passedCategory ?? "Search products"),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : filteredProductList.isEmpty
                ? const Center(
                    child: TitlesTextWidget(label: "No product found"))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          controller: searchTextController,
                          decoration: InputDecoration(
                            hintText: "Search",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                searchTextController.clear();
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          onSubmitted: (value) {
                            setState(() {
                              productListSearch = filteredProductList
                                  .where((product) => product.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        if (searchTextController.text.isNotEmpty &&
                            productListSearch.isEmpty) ...[
                          const Center(
                            child: TitlesTextWidget(label: "No products found"),
                          ),
                        ],
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditOrUploadProductScreen(
                                        productModel: product,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}