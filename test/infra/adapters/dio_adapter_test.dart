import 'package:clean/data/adapters/i_http_adapter.dart';
import 'package:clean/infra/adapters/dio_adapter.dart';
import 'package:clean/infra/adapters/models/http_error.dart';
import 'package:clean/infra/adapters/models/http_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class DioMock extends Mock implements Dio {}

void main() {
  late IHttpAdapter sut;
  late Dio dio;

  final path = 'qualquer_path';
  final dataSuccess = <String, dynamic>{'a': 2};

  setUp(() {
    dio = DioMock();
    sut = DioAdapter(dio: dio);
  });

  mockRequest() => when(() => dio.get(any()));

  mockSuccess(int statusCode) => mockRequest().thenAnswer(
        (_) async => Response(
          statusCode: statusCode,
          data: dataSuccess,
          requestOptions: RequestOptions(path: path),
        ),
      );

  mockError() => mockRequest().thenThrow(
        DioError(
          requestOptions: RequestOptions(path: path),
          response: Response(
            data: {'error': 'deu erro'},
            requestOptions: RequestOptions(path: path),
            statusCode: 500,
            statusMessage: 'deu erro',
          ),
        ),
      );

  test('Ensure Dio.get is called', () async {
    mockSuccess(200);

    await sut.get(path);

    verify(() => dio.get(path));
  });

  test('Ensure dio.get returns HttpResponse', () async {
    mockSuccess(200);
    final response = await sut.get(path);

    expect(response, isA<HttpResponse>());
    expect(response.statusCode, equals(200));
    expect(response.data, dataSuccess);
  });

  test('Ensure throws HttpError on error', () async {
    mockError();

    final future = sut.get(path);

    expect(
      future,
      throwsA(
        HttpError(
          statusCode: 500,
          message: 'deu erro',
          data: {'error': 'deu erro'},
        ),
      ),
    );
  });
}
