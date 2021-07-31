import 'package:clean/domain/enitites/product.dart';
import 'package:clean/domain/failures/failure.dart';
import 'package:clean/domain/repositories/i_product_repository.dart';
import 'package:clean/domain/usecases/get_products_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class ProductsRepositoryMock extends Mock implements IProductRepository {}

void main() {
  late IGetProducts sut;
  late IProductRepository repository;

  final dataSuccess = [
    Product(id: "a", nome: "a"),
  ];

  setUp(() {
    repository = ProductsRepositoryMock();
    sut = GetProducts(repository: repository);
  });

  mockRequest() => when(() => repository.getProducts());

  mockSuccess() => mockRequest().thenAnswer(
        (_) async => Right<Failure, List<Product>>(dataSuccess),
      );
  mockError() => mockRequest().thenAnswer(
        (_) async => Left<Failure, List<Product>>(UnhandledFailure()),
      );

  test('Ensure usecase calls repository', () async {
    mockSuccess();

    sut();

    verify(() => repository.getProducts());
  });

  test('Ensure usecase returns Right on success ', () async {
    mockSuccess();

    final either = await sut();
    either.fold(
      (l) => null,
      (r) {
        expect(r, isA<List<Product>>());
        expect(r, equals(dataSuccess));
      },
    );
  });

  test('Ensure usecase returns left on error', () async {
    mockError();
    final either = await sut();
    either.fold(
      (l) {
        expect(l, isA<UnhandledFailure>());
      },
      (r) => null,
    );
  });
}
