import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiClient {
  final Dio _dio;
  final _storage = const FlutterSecureStorage();
  final String BASE_URL = dotenv.env['BASE_URL'] ?? 'localhost:8080';

  ApiClient() : _dio = Dio(BaseOptions(
    baseUrl: 'http://BASE_URL',
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
