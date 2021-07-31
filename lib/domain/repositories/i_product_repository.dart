import 'package:clean/domain/enitites/product.dart';
import 'package:clean/domain/failures/failure.dart';
import 'package:dartz/dartz.dart';

abstract class IProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
}
