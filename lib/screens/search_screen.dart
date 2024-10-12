// search_screen.dart
import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/product_widget.dart';
import '../widgets/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productList = [
    ProductModel(
      id: 1,
      idCategory: 1,
      imageUrl: 'https://th.bing.com/th/id/OIP.JZGPXS5azcoxkEuQcvyHzQHaEk?rs=1&pid=ImgDetMain',
      name: 'Product 1',
      description: 'Description for product 1',
      price: 10.0,
      status: 'A',
    ),
    ProductModel(
      id: 2,
      idCategory: 2,
      imageUrl: 'https://via.placeholder.com/150',
      name: 'Product 2',
      description: 'Description for product 2',
      price: 20.0,
      status: 'A',
    ),
    // Add more dummy products as needed
  ];

  List<ProductModel> productListSearch = [];

  @override
  Widget build(BuildContext context) {
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> filteredProductList = passedCategory == null
        ? productList
        : productList.where((product) => product.idCategory == int.parse(passedCategory)).toList();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: TitlesTextWidget(label: passedCategory ?? "Search products"),
        ),
        body: filteredProductList.isEmpty
            ? const Center(child: TitlesTextWidget(label: "No product found"))
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
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.75,
                        ),
                        itemBuilder: (context, index) {
                          return ProductWidget(
                            product: searchTextController.text.isNotEmpty
                                ? productListSearch[index]
                                : filteredProductList[index],
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