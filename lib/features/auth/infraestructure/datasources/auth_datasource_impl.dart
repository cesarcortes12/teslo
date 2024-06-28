import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';

import '../../domain/domain.dart';
import '../infraestructure.dart';

class AuthDataSourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Enviroment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(
            headers: {
            'Authorization': 'Bearer $token'
          }));
      print(response);
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(e.response?.data['message'] ?? 'Token invalido');
      }

      if (e.type == DioExceptionType.connectionTimeout)
        throw CustomError('revisar conexión');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {"email": email, "password": password});

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'credenciales incorrectas');
      }

      if (e.type == DioExceptionType.connectionTimeout)
        throw CustomError('revisar conexión');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      final response = await dio.post('/auth/register',
          data: {"email": email, "password": password, "fullName": fullName});
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'creacion ususario fallida');
      }
      if (e.type == DioExceptionType.connectionTimeout)
        throw CustomError('revisar conexión');
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }
}
