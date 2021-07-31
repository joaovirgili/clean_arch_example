import 'package:clean/data/adapters/i_http_adapter.dart';
import 'package:clean/data/paths.dart';
import 'package:clean/data/repositories/product_repository.dart';
import 'package:clean/domain/enitites/product.dart';
import 'package:clean/domain/failures/failure.dart';
import 'package:clean/domain/repositories/i_product_repository.dart';
import 'package:clean/infra/adapters/models/http_error.dart';
import 'package:clean/infra/adapters/models/http_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class HttpAdapterMock extends Mock implements IHttpAdapter {}

void main() {
  late IProductRepository sut;
  late IHttpAdapter httpAdapter;

  setUp(() {
    httpAdapter = HttpAdapterMock();
    sut = ProductRepository(httpAdapter: httpAdapter);
  });

  mockRequest() => when(() => httpAdapter.get(any()));

  mockSuccess() => mockRequest().thenAnswer(
        (_) async => HttpResponse(
          data: [
            {
              "id": "1",
              "name": "name 1",
            }
          ],
          statusCode: 200,
        ),
      );

  mockErrorServerError() => mockRequest().thenThrow(
        HttpError(
          statusCode: 500,
          message: 'message',
          data: {},
        ),
      );

  mockErrorNotFound() => mockRequest().thenThrow(
        HttpError(
          statusCode: 404,
          message: 'message',
          data: {},
        ),
      );

  mockException() => mockRequest().thenThrow(Exception());

  test('Ensure adapter is called ', () async {
    mockSuccess();

    await sut.getProducts();

    verify(() => httpAdapter.get(ApiPaths.getProducts));
  });

  test('Ensure repository returns Right on success', () async {
    mockSuccess();

    final either = await sut.getProducts();
    either.fold(
      (l) => null,
      (r) {
        expect(r, isA<List<Product>>());

        expect(r.first, equals(Product(id: "1", nome: "name 1")));
      },
    );
  });

  test('Ensure repository returns ServerErrorFailure on Server Error ',
      () async {
    mockErrorServerError();

    final either = await sut.getProducts();
    either.fold(
      (l) {
        expect(l, isA<ServerErrorFailure>());
      },
      (r) => null,
    );
  });

  test('Ensure repository returns NotFoundFailure on NotFound', () async {
    mockErrorNotFound();

    final either = await sut.getProducts();
    either.fold(
      (l) {
        expect(l, isA<NotFoundFailure>());
      },
      (r) => null,
    );
  });

  test('Ensure repository returns UnhandledFailure on Exception', () async {
    mockException();

    final either = await sut.getProducts();
    either.fold(
      (l) {
        expect(l, isA<UnhandledFailure>());
      },
      (r) => null,
    );
  });
}
