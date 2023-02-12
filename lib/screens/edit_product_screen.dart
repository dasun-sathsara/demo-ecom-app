import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/product.dart';
import '../providers.dart';

class EditProductScreen extends ConsumerStatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends ConsumerState<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late final BuildContext _buildContext;
  String? _oldProductId;
  Product? _oldProduct;
  Product currentEditingProduct = const Product(id: '', title: '', description: '', price: 0, imageUrl: '');
  var _isInit = false;
  var _isLoading = false;

  final _imageUrlController = TextEditingController();
  final _imageFocusNode = FocusNode();

  @override
  void initState() {
    ref.read(productsProvider.notifier).fetchAndSetProducts();
    _buildContext = context;
    _imageFocusNode.addListener(() {
      updateImage();
    });
    super.initState();
  }

  void updateImage() {
    if (!_imageFocusNode.hasFocus) {
      setState(() {
        currentEditingProduct = currentEditingProduct.copyWith(imageUrl: _imageUrlController.text);
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_oldProductId != null && _oldProduct == currentEditingProduct) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(8),
          content: Text('Nothing has changed to update'),
        ));
      } else if (_oldProductId != null && _oldProduct != currentEditingProduct) {
        try {
          setState(() {
            _isLoading = true;
          });

          await ref.read(productsProvider.notifier).updateProduct(updatedProduct: currentEditingProduct);
          Navigator.of(context).pop();
        } catch (err) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occurred!'),
              content: const Text('Something went wrong while updating the product.'),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          );

          setState(() {
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _isLoading = true;
        });

        try {
          await ref.read(productsProvider.notifier).addProduct(
                title: currentEditingProduct.title,
                price: currentEditingProduct.price,
                description: currentEditingProduct.description,
                imageUrl: currentEditingProduct.imageUrl,
              );

          setState(() {
            _isLoading = false;
          });

          Navigator.of(_buildContext).pop();
        } catch (e) {
          await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('An error occurred!'),
              content: const Text('Something went wrong while adding the new product.'),
              actions: [
                TextButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ),
          );

          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _oldProductId = ModalRoute.of(context)?.settings.arguments as String?;

      if (_oldProductId != null) {
        _oldProduct = ref.read(productsProvider.notifier).getProduct(_oldProductId!);
        currentEditingProduct = currentEditingProduct.copyWith(
            id: _oldProduct!.id,
            title: _oldProduct!.title,
            description: _oldProduct!.description,
            price: _oldProduct!.price,
            imageUrl: _oldProduct!.imageUrl);

        _imageUrlController.text = currentEditingProduct.imageUrl;
      }

      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_oldProductId != null ? _oldProduct!.title : 'Add new product'),
        actions: [
          IconButton(
              onPressed: () {
                _saveForm();
              },
              icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: currentEditingProduct.title,
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 14),
                            isDense: true,
                            label: Text(
                              'Title',
                              style: TextStyle(fontSize: 17),
                            ),
                            border: OutlineInputBorder()),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {},
                        onSaved: (newValue) {
                          currentEditingProduct = currentEditingProduct.copyWith(title: newValue!);
                        },
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          } else {
                            return 'Title is required';
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: currentEditingProduct.price == 0 ? '' : currentEditingProduct.price.toString(),
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 14),
                            isDense: true,
                            label: Text(
                              'Price',
                              style: TextStyle(fontSize: 17),
                            ),
                            border: OutlineInputBorder()),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {},
                        onSaved: (newValue) {
                          currentEditingProduct = currentEditingProduct.copyWith(price: double.parse(newValue!));
                        },
                        validator: (value) {
                          if (value != null && double.tryParse(value) != null) {
                            return null;
                          } else {
                            return 'Enter a valid price';
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: currentEditingProduct.description,
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                            errorStyle: TextStyle(fontSize: 14),
                            isDense: true,
                            label: Text(
                              'Description',
                              style: TextStyle(fontSize: 17),
                            ),
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (value) {},
                        onSaved: (newValue) {
                          currentEditingProduct = currentEditingProduct.copyWith(description: newValue!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description is required';
                          } else if (value.length < 10) {
                            return 'Description should at least be 10 chracters long';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(border: Border.all(width: 1)),
                            child: currentEditingProduct.imageUrl.isEmpty
                                ? Container()
                                : Image.network(
                                    currentEditingProduct.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.url,
                              decoration: const InputDecoration(
                                  errorStyle: TextStyle(fontSize: 14),
                                  isDense: true,
                                  label: Text(
                                    'Image Url',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  border: OutlineInputBorder()),
                              textInputAction: TextInputAction.done,
                              controller: _imageUrlController,
                              focusNode: _imageFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (newValue) {
                                currentEditingProduct = currentEditingProduct.copyWith(imageUrl: newValue!);
                              },
                              validator: (value) {
                                var exp = RegExp(
                                    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)');
                                if (value == null || value.isEmpty) {
                                  return 'Image Url is required';
                                } else if (!exp.hasMatch(value)) {
                                  return 'Entered Url is invalid';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
