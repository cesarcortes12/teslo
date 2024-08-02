import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/infraestructure/mappers/product_mapper.dart';
import '../../domain/domain.dart';
import '../errors/product_errors.dart';

class ProductsDatasourceImpl extends ProductsDatasource {
  late final Dio dio;
  final String? accessToken;

  ProductsDatasourceImpl({required this.accessToken}) : dio = Dio();
  /*(BaseOptions(
            baseUrl: Enviroment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));*/

  @override
  Future<Product> createUpdateProduct(Map<String, dynamic> productLike) {
    // TODO: implement createUpdateProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get('${Enviroment.apiUrl}/products/$id');

      final product = ProductMapper.jsonToEntity(response.data);
      return product;
    } on DioException catch (e) {
      if (e.response!.statusCode == 404) {
        throw ProductNotFound();
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio
        .get<List>('${Enviroment.apiUrl}/products?limit=$limit&offset=$offset');
    final List<Product> products = [];
    for (final product in response.data ?? []) {
      products.add(ProductMapper.jsonToEntity(product));
    }
    return products;
  }

  @override
  Future<List<Product>> searchProductByTerm(String term) {
    // TODO: implement searchProductByTerm
    throw UnimplementedError();
  }
}
