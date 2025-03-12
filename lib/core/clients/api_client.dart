import 'package:dio/dio.dart';
import 'package:road_oper_app/core/types.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  final SharedPreferences _prefs;
  final Dio _dio;

  ApiClient(this._prefs, this._dio) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final accessToken = _prefs.getString('accessToken');

        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }

        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          if (await _refreshToken()) {
            final newRequest = error.requestOptions;
            final newAccessToken = _prefs.getString('accessToken');
            newRequest.headers['Authorization'] = 'Bearer $newAccessToken';
            try {
              final response = await _dio.fetch(newRequest);
              return handler.resolve(response);
            } catch (e) {
              return handler.reject(e as DioException);
            }
          }
        }

        return handler.next(error);
      },
    ));
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _prefs.getString('refreshToken');
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        _prefs.setString('accessToken', response.data['accessToken']);
        _prefs.setString('refreshToken', response.data['refreshToken']);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  bool _checkTokens() {
    return _prefs.getString('accessToken') == null ||
        _prefs.getString('refreshToken') == null;
  }

  Future<Response<Json>> get(
    String path, {
    Json? queryParameters,
  }) {
    try {
      if (_checkTokens()) throw 'There is no token';

      return _dio.get(path, queryParameters: queryParameters);
    } catch (_) {
      rethrow;
    }
  }

  Future<Response<Json>> post(
    String path, {
    Object? data,
  }) {
    try {
      if (_checkTokens()) throw 'There is no token';

      return _dio.get(path, data: data);
    } catch (_) {
      rethrow;
    }
  }
}
