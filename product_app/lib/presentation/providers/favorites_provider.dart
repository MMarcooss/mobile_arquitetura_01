import 'package:flutter/foundation.dart';
import '../../data/datasources/product_remote_datasource.dart';
import '../../data/models/product_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final ProductRemoteDatasource remote;

  FavoritesProvider(this.remote);

  List<ProductModel> _products = [];
  bool isLoading = false;
  String? error;

  List<ProductModel> get products => _products;
  List<ProductModel> get favorites =>
      _products.where((p) => p.favorite).toList();
  int get favoritesCount => favorites.length;

  Future<void> loadProducts() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _products = await remote.getProducts();
    } catch (e) {
      error = 'Erro ao carregar produtos. Verifique sua conexão.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleFavorite(int index) {
    _products[index].favorite = !_products[index].favorite;
    notifyListeners();
  }
}
