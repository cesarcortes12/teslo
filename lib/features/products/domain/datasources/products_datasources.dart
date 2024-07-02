import 'package:teslo_shop/features/products/domain/entities/product.dart';

abstract class ProductsDatasource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}); //entre laves es opcional
  Future<Product> getProductById(String id );
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike);
  Future<List<Product>> searchProductByTerm(String term ); 

}
