// edit_upload_product_form.dart
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/models/categories_model.dart';
import 'package:myapp/services/my_app_functions.dart';
import 'package:myapp/services/product_service.dart';
import 'package:myapp/services/category_service.dart'; // Import the category service

import '../consts/validator.dart';
import '../widgets/subtitle_text.dart';
import '../widgets/title_text.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';

  const EditOrUploadProductScreen({super.key, this.productModel});
  final ProductModel? productModel;
  @override
  State<EditOrUploadProductScreen> createState() =>
      _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController;
  bool isEditing = false;
  List<CategoriesModel> _categories = [];
  int? _selectedCategoryId;
  String? productNetworkImage;

  @override
  void initState() {
    super.initState();
    if (widget.productModel != null) {
      isEditing = true;
      _titleController = TextEditingController(text: widget.productModel?.name);
      _priceController = TextEditingController(text: widget.productModel?.price.toString());
      _descriptionController = TextEditingController(text: widget.productModel?.description);
      _selectedCategoryId = widget.productModel?.idCategory;
      productNetworkImage = widget.productModel?.imageUrl;
    } else {
      _titleController = TextEditingController();
      _priceController = TextEditingController();
      _descriptionController = TextEditingController();
    }
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final categories = await CategoryService.fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (error) {
      // Handle error
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _selectedCategoryId = null;
    removePickedImage();
  }

   void removePickedImage() {
    setState(() {
      _pickedImage = null;
      productNetworkImage = null;
    });
  }
  Future<void> _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        await ProductService.saveProduct(
          idCategory: _selectedCategoryId!,
          imageUrl: '', // Image URL is not needed
          name: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          status: 'A', // Default status
          image: _pickedImage,
        );
        clearForm(); // Clear the form after saving the product
        Navigator.pushReplacementNamed(context, '/SearchScreen'); // Navigate to SearchScreen
      } catch (error) {
        // Handle error
        MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: "Failed to upload product",
          fct: () {},
        );
      }
    }
  }

 Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      try {
        await ProductService.saveProduct(
          id: widget.productModel?.id,
          idCategory: _selectedCategoryId!,
          imageUrl: _pickedImage != null ? '' : productNetworkImage ?? '', // Use existing image URL if no new image is picked
          name: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          status: 'A', // Default status
          image: _pickedImage,
        );
        Navigator.pushReplacementNamed(context, '/SearchScreen'); // Navigate to SearchScreen
      } catch (error) {
        // Handle error
        MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: "Failed to update product",
          fct: () {},
        );
      }
    }
  }
  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await picker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomSheet: SizedBox(
          height: kBottomNavigationBarHeight + 15,
          child: Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.remove_circle_outline),
                  label: const Text(
                    "Limpiar",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () {
                    clearForm();
                  },
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.add_task),
                  label: Text(
                    isEditing ? "Edit Product" : "Upload Product",
                  ),
                  onPressed: () {
                    if (isEditing) {
                      _editProduct();
                    } else {
                      _uploadProduct();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: TitlesTextWidget(
            label: isEditing ? "Edit Product" : "Upload a new product",
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (isEditing && productNetworkImage != null) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          productNetworkImage!,
                          height: size.width * 0.5,
                          alignment: Alignment.center,
                        ),
                      ),
                    ] else if (_pickedImage == null)
                      SizedBox(
                        width: size.width * 0.4 + 10,
                        height: size.width * 0.4,
                        child: DottedBorder(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.image_outlined,
                                  size: 80,
                                  color: Colors.blue,
                                ),
                                TextButton(
                                  onPressed: localImagePicker,
                                  child: const Text("Seleccionar imagen"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_pickedImage!.path),
                          height: size.width * 0.5,
                          alignment: Alignment.center,
                        ),
                      ),
                    if (_pickedImage != null || productNetworkImage != null) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                             onPressed: () {
                          localImagePicker();
                        },
                            child: const Text("Otra imagen"),
                          ),
                          TextButton(
                             onPressed: () {
                          removePickedImage();
                        },
                            child: const Text(
                              "Eliminar imagen",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _titleController,
                            decoration:
                                const InputDecoration(labelText: 'Nombre'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese un nombre';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          flex: 1,
                          child: TextFormField(
                            controller: _priceController,
                            key: const ValueKey('Precio \$'),
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d{0,6}(\.\d{0,2})?$'),
                              ),
                            ],
                            decoration: const InputDecoration(
                              hintText: 'Precio',
                              prefix: SubtitleText(
                                label: "S/. ",
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<int>(
                      value: _selectedCategoryId,
                      decoration:
                          const InputDecoration(labelText: 'Categorias'),
                      items: _categories.map((category) {
                        return DropdownMenuItem<int>(
                          value: category.id,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Seleccione una categoria';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _descriptionController,
                      minLines: 5,
                      maxLines: 8,
                      maxLength: 1000,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'Product description',
                      ),
                      validator: (value) {
                        return MyValidators.uploadProdTexts(
                          value: value,
                          toBeReturnedString: "Description is missed",
                        );
                      },
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}