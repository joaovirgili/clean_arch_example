import 'package:clean/domain/enitites/product.dart';
import 'package:clean/domain/failures/failure.dart';
import 'package:clean/domain/repositories/i_product_repository.dart';
import 'package:dartz/dartz.dart';

abstract class IGetProducts {
  Future<Either<Failure, List<Product>>> call();
}

class GetProducts implements IGetProducts {
  final IProductRepository repository;

  GetProducts({required this.repository});

  @override
  Future<Either<Failure, List<Product>>> call() {
    return repository.getProducts();
  }
}
