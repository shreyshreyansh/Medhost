import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product(
      {@required this.description,
      @required this.id,
      @required this.imageUrl,
      @required this.price,
      this.isFavourite = false,
      @required this.title});

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
