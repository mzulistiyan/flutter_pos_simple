import '../../../common/common.dart';
import '../../core.dart';
import 'package:dartz/dartz.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ProductEntity>>> getProduct({String? categoryID}) async {
    try {
      final result = await remoteDataSource.getProduct(categoryID: categoryID);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, List<CategoryProductEntity>>> getCategory() async {
    try {
      final result = await remoteDataSource.getCategory();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> uploadFile({
    required String filePath,
    required String file,
  }) async {
    try {
      final result = await remoteDataSource.uploadFile(filePath: filePath, fileName: file);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> postProduct({
    required String name,
    required int stock,
    required int price,
    required String categoryID,
    required String image,
  }) async {
    try {
      final result = await remoteDataSource.postProduct(
        name: name,
        stock: stock,
        price: price,
        categoryID: categoryID,
        image: image,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> updateProduct({
    required int id,
    required String name,
    required int stock,
    required int price,
    required String categoryID,
    required String image,
  }) async {
    try {
      final result = await remoteDataSource.updateProduct(
        id: id,
        name: name,
        stock: stock,
        price: price,
        categoryID: categoryID,
        image: image,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> deleteProduct({
    required int id,
  }) async {
    try {
      final result = await remoteDataSource.deleteProduct(id: id);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> orderProduct({
    required int amount,
  }) async {
    try {
      final result = await remoteDataSource.orderProduct(amount: amount);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> orderItemsProduct({
    required int productId,
    required int quantity,
    required int price,
    required int orderID,
  }) async {
    try {
      final result = await remoteDataSource.orderItemsProduct(
        productId: productId,
        quantity: quantity,
        price: price,
        orderID: orderID,
      );
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, String>> updateProductStock({
    required int id,
    required int stock,
  }) async {
    try {
      final result = await remoteDataSource.updateProductStock(id: id, stock: stock);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderByMonth() async {
    try {
      final result = await remoteDataSource.getOrderByMonth();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrderByDate() async {
    try {
      final result = await remoteDataSource.getOrderByDate();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }

  @override
  Future<Either<Failure, List<OrderItemEntity>>> getOrderItemsToday() async {
    try {
      final result = await remoteDataSource.getOrderItemsToday();
      return Right(result);
    } on ServerException {
      return Left(ServerFailure(
        'Server Failure',
      ));
    }
  }
}
