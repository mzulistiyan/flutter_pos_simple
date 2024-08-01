import 'package:dartz/dartz.dart';
import '../../../common/common.dart';
import '../../core.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductEntity>>> getProduct({String? categoryID});
  Future<Either<Failure, List<CategoryProductEntity>>> getCategory();
  Future<Either<Failure, String>> uploadFile({
    required String filePath,
    required String file,
  });

  //Post Product
  Future<Either<Failure, String>> postProduct({
    required String name,
    required int stock,
    required int price,
    required String categoryID,
    required String image,
  });

  //Update Product
  Future<Either<Failure, String>> updateProduct({
    required int id,
    required String name,
    required int stock,
    required int price,
    required String categoryID,
    required String image,
  });

  //Delete Product
  Future<Either<Failure, String>> deleteProduct({
    required int id,
  });

  //Order Product
  Future<Either<Failure, String>> orderProduct({
    required int amount,
  });
  Future<Either<Failure, String>> orderItemsProduct({
    required int productId,
    required int quantity,
    required int price,
    required int orderID,
  });

  //Update Product Stock
  Future<Either<Failure, String>> updateProductStock({
    required int id,
    required int stock,
  });

  //get Order By Month
  Future<Either<Failure, List<OrderEntity>>> getOrderByMonth();

  //get Order By Date
  Future<Either<Failure, List<OrderEntity>>> getOrderByDate();

  //get OrderItems Today
  Future<Either<Failure, List<OrderItemEntity>>> getOrderItemsToday();
}
