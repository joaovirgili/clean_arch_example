import 'package:clean/data/adapters/i_http_adapter.dart';
import 'package:dio/dio.dart';

import 'models/http_error.dart';
import 'models/http_response.dart';

class DioAdapter implements IHttpAdapter {
  final Dio dio;

  DioAdapter({required this.dio});

  @override
  Future<HttpResponse> get(String path) async {
    try {
      final response = await dio.get(path);
      return HttpResponse(
        statusCode: response.statusCode ?? 200,
        data: response.data,
      );
    } on DioError catch (e) {
      throw HttpError(
        data: e.response?.data ?? {},
        message: e.response?.statusMessage ?? 'error',
        statusCode: e.response?.statusCode ?? 500,
      );
    }
  }
}
