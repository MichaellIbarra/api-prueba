import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/models/product_model.dart';
import 'package:myapp/services/product_service.dart';
import 'package:uuid/uuid.dart';

import '../consts/validator.dart';
import '../widgets/subtitle_text.dart';
import '../widgets/title_text.dart';
import 'loading_manager.dart';

class EditOrUploadProductScreen extends StatefulWidget {
  static const routeName = '/EditOrUploadProductScreen';

  const EditOrUploadProductScreen({super.key, this.productModel});
  final ProductModel? productModel;

  @override
  State<EditOrUploadProductScreen> createState() => _EditOrUploadProductScreenState();
}

class _EditOrUploadProductScreenState extends State<EditOrUploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  late TextEditingController _titleController,
      _priceController,
      _descriptionController,
      _quantityController;
  String? _categoryValue;
  bool isEditing = false;
  String? productNetworkImage;
  bool _isLoading = false;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.productModel?.productTitle);
    _priceController = TextEditingController(text: widget.productModel?.productPrice);
    _descriptionController = TextEditingController(text: widget.productModel?.productDescription);
    _quantityController = TextEditingController(text: widget.productModel?.productQuantity);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
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
    if (_pickedImage == null) {
      Fluttertoast.showToast(
        msg: "Make sure to pick up an image",
        textColor: Colors.white,
      );
      return;
    }
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        final productId = const Uuid().v4();
        final product = ProductModel(
          productId: productId,
          productTitle: _titleController.text,
          productPrice: _priceController.text,
          productImage: _pickedImage!.path,
          productCategory: _categoryValue,
          productDescription: _descriptionController.text,
          productQuantity: _quantityController.text,
          status: 'A',
        );

        await ProductService().saveProduct(product, isEditing: false);

        Fluttertoast.showToast(
          msg: "Product has been added",
          textColor: Colors.white,
        );
        if (!mounted) return;
        clearForm();
      } catch (error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _editProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_pickedImage == null && productNetworkImage == null) {
      Fluttertoast.showToast(
        msg: "Please pick up an image",
        textColor: Colors.white,
      );
      return;
    }
    if (isValid) {
      try {
        setState(() {
          _isLoading = true;
        });

        final product = ProductModel(
          productId: widget.productModel!.productId,
          productTitle: _titleController.text,
          productPrice: _priceController.text,
          productImage: _pickedImage?.path ?? productNetworkImage,
          productCategory: _categoryValue,
          productDescription: _descriptionController.text,
          productQuantity: _quantityController.text,
          status: 'A',
        );

        await ProductService().saveProduct(product, isEditing: true);

        Fluttertoast.showToast(
          msg: "Product has been edited",
          textColor: Colors.white,
        );
        if (!mounted) return;
        clearForm();
      } catch (error) {
        Fluttertoast.showToast(
          msg: error.toString(),
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker picker = ImagePicker();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pick an image'),
        actions: [
          TextButton(
            onPressed: () async {
              _pickedImage = await picker.pickImage(source: ImageSource.camera);
              setState(() {
                productNetworkImage = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Camera'),
          ),
          TextButton(
            onPressed: () async {
              _pickedImage = await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                productNetworkImage = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Gallery'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _pickedImage = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return LoadingManager(
      isLoading: _isLoading,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          bottomSheet: SizedBox(
            height: kBottomNavigationBarHeight + 10,
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
                    icon: const Icon(Icons.clear),
                    label: const Text(
                      "Clear",
                      style: TextStyle(fontSize: 20),
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
                    icon: const Icon(Icons.upload),
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
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  if (isEditing && productNetworkImage != null) ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        productNetworkImage!,
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ] else if (_pickedImage == null) ...[
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
                                onPressed: () {
                                  localImagePicker();
                                },
                                child: const Text("Pick Product Image"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(_pickedImage!.path),
                        height: size.width * 0.5,
                        alignment: Alignment.center,
                      ),
                    ),
                  ],
                  if (_pickedImage != null || productNetworkImage != null) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            localImagePicker();
                          },
                          child: const Text("Pick another image"),
                        ),
                        TextButton(
                          onPressed: () {
                            removePickedImage();
                          },
                          child: const Text("Remove image"),
                        ),
                      ],
                    ),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _titleController,
                            decoration: const InputDecoration(labelText: 'Title'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a title';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _priceController,
                            decoration: const InputDecoration(labelText: 'Price'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a price';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            decoration: const InputDecoration(labelText: 'Description'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _quantityController,
                            decoration: const InputDecoration(labelText: 'Quantity'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a quantity';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _categoryValue,
                            decoration: const InputDecoration(labelText: 'Category'),
                            items: <String>['Category 1', 'Category 2', 'Category 3']
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (newValue) {
                              setState(() {
                                _categoryValue = newValue;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a category';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}