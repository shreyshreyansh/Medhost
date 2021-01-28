import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    price: 0,
    description: "",
    imageUrl: '',
    title: "",
  );
  bool _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        final _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          //'imageUrl': _editedProduct.imageUrl
          'imageUrl': ''
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // The Dispose here is recommended to ensure a clean user experience
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageURL);
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageURL() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    // The save method here is provided to us by the Flutter
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    } else {
      _form.currentState.save();
    }
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['title'],
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (value) =>
                    {FocusScope.of(context).requestFocus(_priceFocusNode)},
                onSaved: (newValue) => {
                  _editedProduct = Product(
                      title: newValue,
                      description: _editedProduct.description,
                      id: _editedProduct.id,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price,
                      isFavourite: _editedProduct.isFavourite)
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) => {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode)
                },
                validator: (value) {
                  // Any String Implies an  error
                  if (value.isEmpty) {
                    return 'Please Enter A Value';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please Enter a Valid Number';
                  }
                  if (double.parse(value) <= 0) {
                    return "Please Enter A Number Greater Than 0";
                  }
                  // We return NUll if there is no Error
                  return null;
                },
                onSaved: (newValue) => {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      description: _editedProduct.description,
                      id: null,
                      imageUrl: _editedProduct.imageUrl,
                      price: double.parse(newValue))
                },
              ),
              TextFormField(
                initialValue: _initValues['description'],
                focusNode: _descriptionFocusNode,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onSaved: (newValue) => {
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      description: newValue,
                      id: null,
                      imageUrl: _editedProduct.imageUrl,
                      price: _editedProduct.price)
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Enter a Description';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter Url ')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (newValue) => {
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            id: null,
                            imageUrl: newValue,
                            price: _editedProduct.price)
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Enter a Valid Image URL';
                        }
                        if (!value.startsWith('http') &&
                            !value.startsWith('https')) {
                          return 'Please enter a Valid URL';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
