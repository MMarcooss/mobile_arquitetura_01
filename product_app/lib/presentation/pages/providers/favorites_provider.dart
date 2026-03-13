import 'package:flutter/foundation.dart';
import '../../../data/models/product_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<ProductModel> _products = [
    ProductModel(id: 1, title: 'Notebook', price: 3500, image: ''),
    ProductModel(id: 2, title: 'Mouse', price: 120, image: ''),
    ProductModel(id: 3, title: 'Teclado', price: 250, image: ''),
    ProductModel(id: 4, title: 'Monitor', price: 900, image: ''),
    ProductModel(id: 5, title: 'Headset', price: 350, image: ''),
  ];

  List<ProductModel> get products => _products;

  List<ProductModel> get favorites =>
      _products.where((p) => p.favorite).toList();

  int get favoritesCount => favorites.length;

  void toggleFavorite(int index) {
    _products[index].favorite = !_products[index].favorite;
    notifyListeners();
  }
}
