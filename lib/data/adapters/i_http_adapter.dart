import 'package:clean/infra/adapters/models/http_response.dart';

abstract class IHttpAdapter {
  Future<HttpResponse> get(String path);
}
