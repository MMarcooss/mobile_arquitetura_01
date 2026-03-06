import '../../domain/entities/product.dart';
import '../../domain/repositories/product%20repository.dart';
import '../datasources/productremotedatasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource datasource;
  ProductRepositoryImpl(this.datasource);
  @override
  Future<List<Product>> getProducts() async {
    final models = await datasource.getProducts();
    return models
        .map(
          (m) =>
              Product(id: m.id, title: m.title, price: m.price, image: m.image),
        )
        .toList();
  }
}
