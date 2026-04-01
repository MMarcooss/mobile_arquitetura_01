import 'package:flutter/foundation.dart';
import '../../data/repositories/product_repositoryimpl.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/product.dart';

class FavoritesProvider extends ChangeNotifier {
  final ProductRepositoryImpl repository;

  FavoritesProvider(this.repository);

  List<ProductModel> _products = [];
  List<ProductModel> _localProducts = [];
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
      // Busca produtos da API (ou cache se offline)
      final productsFromRepo = await repository.getProducts();
      // Converte Product (entidade) para ProductModel
      _products = productsFromRepo
          .map(
            (p) => ProductModel(
              id: p.id ?? 0,
              title: p.title,
              price: p.price,
              image: p.image,
              description: p.description,
              category: p.category,
              ratingRate: p.ratingRate,
              ratingCount: p.ratingCount,
            ),
          )
          .toList();

      // Adiciona produtos locais que foram criados (merge)
      for (var local in _localProducts) {
        if (!_products.any((p) => p.id == local.id)) {
          _products.add(local);
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
      // Converte ProductModel para Product (entidade)
      final productEntity = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
        description: product.description,
        category: product.category,
        ratingRate: product.ratingRate,
        ratingCount: product.ratingCount,
      );
      // Chama o repository que usa cache
      final created = await repository.createProduct(productEntity);
      final createdModel = ProductModel(
        id: created.id ?? 0,
        title: created.title,
        price: created.price,
        image: created.image,
        description: created.description,
        category: created.category,
        ratingRate: created.ratingRate,
        ratingCount: created.ratingCount,
      );
      _products.add(createdModel);
      _localProducts.add(createdModel); // Mantém localmente
      notifyListeners();
    } catch (e) {
      error = 'Erro ao cadastrar produto.';
      notifyListeners();
    }
  }

  Future<void> updateProduct(ProductModel product) async {
    try {
      // Converte ProductModel para Product (entidade)
      final productEntity = Product(
        id: product.id,
        title: product.title,
        price: product.price,
        image: product.image,
        description: product.description,
        category: product.category,
        ratingRate: product.ratingRate,
        ratingCount: product.ratingCount,
      );
      final updated = await repository.updateProduct(productEntity);
      final updatedModel = ProductModel(
        id: updated.id ?? 0,
        title: updated.title,
        price: updated.price,
        image: updated.image,
        description: updated.description,
        category: updated.category,
        ratingRate: updated.ratingRate,
        ratingCount: updated.ratingCount,
      );
      final index = _products.indexWhere((p) => p.id == updated.id);
      if (index != -1) {
        _products[index] = updatedModel;
        // Atualiza também na lista local
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
