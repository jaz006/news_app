import 'package:dio/dio.dart';

class ApiHelper {

  late Dio _dio;

  ApiHelper(String baseUrl) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
      ),
    );
  }


  Future<Response> getRequest({
    required String endPoint,
    Map<String, dynamic>? queryParams,
  }) async {
    return _dio.get(
      endPoint,
      queryParameters: queryParams,
    );
  }


  String handleException(Object e) {

    String errorMsg;

    if (e is DioException) {

      if (e.response?.data != null) {

        var errorResponse =
            e.response?.data as Map<String, dynamic>;

        errorMsg =
            errorResponse['message'] ?? 'Something went wrong';

      } else {

        errorMsg =
            'Network error happened try again later';
      }

    } else {

      errorMsg =
          'error happened try again later';
    }

    return errorMsg;
  }
}