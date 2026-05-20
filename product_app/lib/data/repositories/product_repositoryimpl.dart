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
      return models.map((m) => _toEntity(m)).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null) {
        return cached.map((m) => _toEntity(m)).toList();
      }
      throw Failure("Não foi possível carregar os produtos");
    }
  }

  @override
  Future<Product> createProduct(Product product) async {
    try {
      // Converte Entidade para Model para enviar ao Remote
      final model = await remote.createProduct(_toModel(product));
      return _toEntity(model);
    } catch (e) {
      throw Failure("Não foi possível criar o produto");
    }
  }

  @override
  Future<Product> updateProduct(Product product) async {
    try {
      final model = await remote.updateProduct(_toModel(product));
      return _toEntity(model);
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

  // Mapper: Model -> Entity
  Product _toEntity(ProductModel m) => Product(
    id: m.id,
    title: m.title,
    description: m.description,
    category: m.category,
    price: m.price,
    rating: m.ratingRate, // Mapeia ratingRate para rating
    stock: 0, // Model não tem stock, definimos um padrão
    thumbnail: m.image, // Mapeia image para thumbnail
  );

  // Mapper: Entity -> Model
  ProductModel _toModel(Product p) => ProductModel(
    id: p.id,
    title: p.title,
    price: p.price,
    image: p.thumbnail, // Mapeia thumbnail para image
    description: p.description,
    category: p.category,
    ratingRate: p.rating, // Mapeia rating para ratingRate
    ratingCount: 0,
  );
}    // Entity