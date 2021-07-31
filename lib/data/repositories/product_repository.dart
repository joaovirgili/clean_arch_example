import 'package:clean/data/adapters/i_http_adapter.dart';
import 'package:clean/data/model/product_model.dart';
import 'package:clean/domain/enitites/product.dart';
import 'package:clean/domain/failures/failure.dart';
import 'package:clean/domain/repositories/i_product_repository.dart';
import 'package:clean/infra/adapters/models/http_error.dart';
import 'package:dartz/dartz.dart';

import '../paths.dart';

class ProductRepository implements IProductRepository {
  final IHttpAdapter httpAdapter;

  ProductRepository({required this.httpAdapter});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final response = await httpAdapter.get(ApiPaths.getProducts);

      return Right(
        (response.data as List)
            .map((e) => ProductModel.fromJson(e).toEntity())
            .toList(),
      );
    } on HttpError catch (e) {
      if (e.statusCode == 500) {
        return Left(ServerErrorFailure());
      } else if (e.statusCode == 404) {
        return Left(NotFoundFailure());
      } else {
        return Left(UnhandledFailure());
      }
    } catch (e) {
      return Left(UnhandledFailure());
    }
  }
}
