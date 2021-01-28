import 'package:flutter/material.dart';

import 'product.dart';

// Like NgRx we never change the main data library or container to maintain the
// solidarity of data we use notifyListeners to tell everyone that the data has changed
// and that new data is available
// Like NgRx we must provide the data in the highest level to ensure the availability
// of data throught the app so we use main.dart to provide the data

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trous')
  ];
  // This way of filtering data theough variables results in a application wide
  // State ot
  var _showFavouritesOnly;

  List<Product> get items {
    if (_showFavouritesOnly) {
      return [..._items];
    }
    return [..._items];
  }

  List<Product> get favouriteItem {
    return [..._items.where((element) => element.isFavourite == true)];
  }

  void showFavourite() {
    _showFavouritesOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavouritesOnly = false;
    notifyListeners();
  }

  void addProduct(Product product) {
    final newProduct = Product(
        description: product.description,
        id: DateTime.now().toString(),
        imageUrl: product.imageUrl,
        price: product.price,
        title: product.title);
    _items.add(newProduct);
    notifyListeners();
  }

  Product findById(String Id) {
    return _items.firstWhere((element) => element.id == Id);
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((value) => value.id == id);
    notifyListeners();
  }
}
