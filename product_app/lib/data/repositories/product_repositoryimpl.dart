import '../../domain/entities/product.dart';
import '../../domain/repositories/product%20repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/productcachedatasource.dart';
import '../../core/errors/failure.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;
  ProductRepositoryImpl(this.remote, this.cache);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models
          .map(
            (m) => Product(
              id: m.id,
              title: m.title,
              price: m.price,
              image: m.image,
              description: m.description,
              category: m.category,
              ratingRate: m.ratingRate,
              ratingCount: m.ratingCount,
            ),
          )
          .toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached
            .map(
              (m) => Product(
                id: m.id,
                title: m.title,
                price: m.price,
                image: m.image,
                description: m.description,
                category: m.category,
                ratingRate: m.ratingRate,
                ratingCount: m.ratingCount,
              ),
            )
            .toList();
      }
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      final model = await remote.createProduct(
        ProductModel(
          id: product.id ?? 0,
          title: product.title,
          price: product.price,
          image: product.image,
          description: product.description,
          category: product.category,
          ratingRate: product.ratingRate,
          ratingCount: product.ratingCount,
        ),
      );
      return Product(
        id: model.id,
        title: model.title,
        price: model.price,
        image: model.image,
        description: model.description,
        category: model.category,
        ratingRate: model.ratingRate,
        ratingCount: model.ratingCount,
      );
    } catch (e) {
      throw Failure("Não foi possível criar o produto");
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = await remote.updateProduct(
        ProductModel(
          id: product.id ?? 0,
          title: product.title,
          price: product.price,
          image: product.image,
          description: product.description,
          category: product.category,
          ratingRate: product.ratingRate,
          ratingCount: product.ratingCount,
        ),
      );
      return Product(
        id: model.id,
        title: model.title,
        price: model.price,
        image: model.image,
        description: model.description,
        category: model.category,
        ratingRate: model.ratingRate,
        ratingCount: model.ratingCount,
      );
    } catch (e) {
      throw Failure("Não foi possível atualizar o produto");
    }
  }

  @override
  Future<void> deleteProduct(int id) async {
    try {
      await remote.deleteProduct(id);
    } catch (e) {
      throw Failure("Não foi possível deletar o produto");
    }
  }
}
