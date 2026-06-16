import 'package:flutter/foundation.dart';
import '../../data/repositories/product_repositoryimpl.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final ProductRepositoryImpl repository;

  FavoritesProvider(this.repository);

  List<ProductModel> _products = [];
  final List<ProductModel> _localProducts = [];
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
      final productsFromRepo = await repository.getProducts();

      _products = productsFromRepo
          .map(
            (p) => ProductModel(
              id: p.id,
              title: p.title,
              price: p.price,
              image: p.thumbnail, // Entidade (thumbnail) -> Model (image)
              description: p.description,
              category: p.category,
              ratingRate: p.rating, // Entidade (rating) -> Model (ratingRate)
              ratingCount: 0, // Valor padrão
            ),
          )
          .toList();

      for (var local in _localProducts) {
        if (!_products.any((p) => p.id == local.id)) {
          _products.insert(0, local);
        }
      }
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

  Future<void> createProduct(ProductModel product) async {
    try {
      final productEntity = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        thumbnail: product.image, // Model (image) -> Entidade (thumbnail)
        description: product.description,
        category: product.category,
        rating: product.ratingRate, // Model (ratingRate) -> Entidade (rating)
        stock: 0,
      );

      final created = await repository.createProduct(productEntity);

      final createdModel = ProductModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: created.title,
        price: created.price,
        image: created.thumbnail,
        description: created.description,
        category: created.category,
        ratingRate: created.rating,
        ratingCount: 0,
      );

      _products.insert(0, createdModel);
      _localProducts.add(createdModel);
      notifyListeners();
    } catch (e) {
      error = 'Erro ao cadastrar produto.';
      notifyListeners();
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      final productEntity = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        thumbnail: product.image,
        description: product.description,
        category: product.category,
        rating: product.ratingRate,
        stock: 0,
      );

      final updated = await repository.updateProduct(productEntity);

      final updatedModel = ProductModel(
        id: updated.id,
        title: updated.title,
        price: updated.price,
        image: updated.thumbnail,
        description: updated.description,
        category: updated.category,
        ratingRate: updated.rating,
        ratingCount: 0,
      );

      final index = _products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        _products[index] = updatedModel;
        final localIndex = _localProducts.indexWhere((p) => p.id == updated.id);
        if (localIndex != -1) {
          _localProducts[localIndex] = updatedModel;
        }
        notifyListeners();
      }
    } catch (e) {
      error = 'Erro ao atualizar produto.';
      notifyListeners();
    }
  }
}
