// product_widget.dart
import 'package:flutter/material.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/my_app_functions.dart';
import 'package:myapp/services/product_service.dart';
import 'package:myapp/widgets/subtitle_text.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProductWidget({super.key, required this.product, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  height: 100,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                product.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SubtitleText(
                      fontSize: 16,
                      label: "S/.${product.price}",
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                  product.status == 'A'
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                          onPressed: () async {
                            bool confirm = await MyAppFunctions.showConfirmationDialog(
                              context: context,
                              title: "Delete Product",
                              subtitle: "Are you sure you want to delete this product?",
                            );
                            if (confirm) {
                              try {
                                await ProductService.deleteProduct(product.id);
                                onDelete();
                              } catch (error) {
                                MyAppFunctions.showErrorOrWarningDialog(
                                  context: context,
                                  subtitle: "Failed to delete product",
                                  fct: () {},
                                );
                              }
                            }
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.restore, color: Colors.blue, size: 24),
                          onPressed: () async {
                            bool confirm = await MyAppFunctions.showRestoreConfirmationDialog(
                              context: context,
                              title: "Restore Product",
                              subtitle: "Are you sure you want to restore this product?",
                            );
                            if (confirm) {
                              try {
                                await ProductService.restoreProduct(product.id);
                                onDelete();
                              } catch (error) {
                                MyAppFunctions.showErrorOrWarningDialog(
                                  context: context,
                                  subtitle: "Failed to restore product",
                                  fct: () {},
                                );
                              }
                            }
                          },
                        ),
                ],
              ),
              Text(
                product.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}