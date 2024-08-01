import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../common/common.dart';
import '../../core.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductEntity>> getProduct({String? categoryID});
  Future<List<CategoryProductEntity>> getCategory();
  Future<String> uploadFile({
    required String filePath,
    required String fileName,
  });

  //Post Product
  Future<String> postProduct({
    required String name,
    required int stock,
    required int price,
    required String categoryID,
    required String image,
  });

  //Update Product
  Future<String> updateProduct({
    int? id,
    String? name,
    int? stock,
    int? price,
    String? categoryID,
    String? image,
  });

  //Delete Product
  Future<String> deleteProduct({
    required int id,
  });

  //Order Product
  Future<String> orderProduct({
    required int amount,
  });

  Future<String> orderItemsProduct({
    required int productId,
    required int quantity,
    required int price,
    required int orderID,
  });

  //Update Product Stock
  Future<String> updateProductStock({
    required int id,
    required int stock,
  });

  //get Order By Month
  Future<List<OrderEntity>> getOrderByMonth();

  //get Order By Date
  Future<List<OrderEntity>> getOrderByDate();

  //get OrderItems Today
  Future<List<OrderItemEntity>> getOrderItemsToday();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient dioClient;

  ProductRemoteDataSourceImpl({
    required this.dioClient,
  });

  @override
  Future<List<ProductEntity>> getProduct({String? categoryID}) async {
    Map<String, dynamic>? queryParamsWithFilter = {
      'fields': '*,category_id.id,category_id.name',
      'filter[category_id][_eq]': categoryID,
    };

    Map<String, dynamic>? queryParamsWithOutFilter = {
      'fields': '*,category_id.id,category_id.name',
    };

    final response = await dioClient.get(
      url: UrlConstant.product,
      queryParams: categoryID != null ? queryParamsWithFilter : queryParamsWithOutFilter,
    );

    if (response.statusCode == 200) {
      return (response.data['data'] as List).map((data) => ProductEntity.fromJson(data)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<CategoryProductEntity>> getCategory() async {
    final response = await dioClient.get(
      url: UrlConstant.category,
    );

    if (response.statusCode == 200) {
      return (response.data['data'] as List).map((data) => CategoryProductEntity.fromJson(data)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> uploadFile({
    required String filePath,
    required String fileName,
  }) async {
    final file = await MultipartFile.fromFile(
      filePath,
      filename: fileName,
      contentType: MediaType('image', 'jpeg'),
    );

    final formData = FormData.fromMap({
      'file': file,
      'folder': 'ece57edb-4d97-4cdb-bbe9-41bc8a9b7507',
    });

    final response = await dioClient.post(
      url: UrlConstant.uploadFile,
      data: formData,
    );

    if (response.statusCode == 200) {
      return response.data['data']['id'];
    } else {
      throw ServerException();
    }
  }

  //Post Product
  @override
  Future<String> postProduct({
    required String name,
    required int stock,
    required int price,
    required String categoryID,
    required String image,
  }) async {
    final response = await dioClient.post(
      url: UrlConstant.product,
      data: {
        'name': name,
        'stock': stock,
        'price': price,
        'category_id': categoryID,
        'image': image,
      },
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  //Update Product
  @override
  Future<String> updateProduct({
    int? id,
    String? name,
    int? stock,
    int? price,
    String? categoryID,
    String? image,
  }) async {
    final response = await dioClient.patch(
      url: '${UrlConstant.product}/$id',
      data: {
        'name': name,
        'stock': stock,
        'price': price,
        'category_id': categoryID,
        'image': image,
      },
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  //Delete Product
  @override
  Future<String> deleteProduct({
    required int id,
  }) async {
    final response = await dioClient.delete(
      url: '${UrlConstant.product}/$id',
    );

    if (response.statusCode == 204) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  //Order Product
  @override
  Future<String> orderProduct({
    required int amount,
  }) async {
    final response = await dioClient.post(
      url: UrlConstant.order,
      data: {
        'total_amount': amount,
      },
    );

    if (response.statusCode == 200) {
      return response.data['data']['id'].toString();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<String> orderItemsProduct({
    required int productId,
    required int quantity,
    required int price,
    required int orderID,
  }) async {
    final response = await dioClient.post(
      url: UrlConstant.orderItems,
      data: {
        'product_id': productId,
        'quantity': quantity,
        'price': price,
        'order_id': orderID,
      },
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  //Update Product Stock
  @override
  Future<String> updateProductStock({
    required int id,
    required int stock,
  }) async {
    final response = await dioClient.patch(
      url: '${UrlConstant.product}/$id',
      data: {
        'stock': stock,
      },
    );

    if (response.statusCode == 200) {
      return 'Success';
    } else {
      throw ServerException();
    }
  }

  //get Order By Month
  @override
  Future<List<OrderEntity>> getOrderByMonth() async {
    final response = await dioClient.get(
      url: UrlConstant.order,
      queryParams: {
        'filter[month(date_created)][_eq]': '7',
        'fields': 'date_created,id,total_amount',
      },
    );

    if (response.statusCode == 200) {
      return (response.data['data'] as List).map((data) => OrderEntity.fromJson(data)).toList();
    } else {
      throw ServerException();
    }
  }

  //get Order By Date
  @override
  Future<List<OrderEntity>> getOrderByDate() async {
    int day = DateTime.now().day;
    int month = DateTime.now().month;
    final response = await dioClient.get(
      url: UrlConstant.order,
      queryParams: {
        'filter[day(date_created)][_eq]': day,
        'fields': 'date_created,id,total_amount',
        'filter[month(date_created)][_eq]': month,
      },
    );

    if (response.statusCode == 200) {
      return (response.data['data'] as List).map((data) => OrderEntity.fromJson(data)).toList();
    } else {
      throw ServerException();
    }
  }

  //get OrderItems Today
  @override
  Future<List<OrderItemEntity>> getOrderItemsToday() async {
    final response = await dioClient.get(
      url: UrlConstant.orderItems,
      queryParams: {
        'filter[day(date_created)][_eq]': DateTime.now().day,
        'filter[month(date_created)][_eq]': DateTime.now().month,
        'fields': 'id,quantity,price,order_id,product_id.name, order_id.total_amount, order_id.id, order_id.date_created',
      },
    );

    if (response.statusCode == 200) {
      return (response.data['data'] as List).map((data) => OrderItemEntity.fromJson(data)).toList();
    } else {
      throw ServerException();
    }
  }
}
