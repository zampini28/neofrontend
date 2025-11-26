import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:physioapp/utils/domain_connection.dart';

class ApiClient {
  final Dio _dio;
  final _storage = const FlutterSecureStorage();
  
  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: DomainConnection().url,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _storage.read(key: 'jwt_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        print('API Error: ${e.response?.statusCode} - ${e.message}');
        return handler.next(e);
      },
    ));
  }

  Dio get client => _dio;
}
