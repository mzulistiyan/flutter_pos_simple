// To parse this JSON data, do
//
//     final orderItemEntity = orderItemEntityFromJson(jsonString);

import 'dart:convert';

OrderItemEntity orderItemEntityFromJson(String str) => OrderItemEntity.fromJson(json.decode(str));

String orderItemEntityToJson(OrderItemEntity data) => json.encode(data.toJson());

class OrderItemEntity {
  int? id;
  int? quantity;
  int? price;
  ProductId? productId;
  OrderId? orderId;

  OrderItemEntity({
    this.id,
    this.quantity,
    this.price,
    this.productId,
    this.orderId,
  });

  factory OrderItemEntity.fromJson(Map<String, dynamic> json) => OrderItemEntity(
        id: json["id"],
        quantity: json["quantity"],
        price: json["price"],
        productId: json["product_id"] == null ? null : ProductId.fromJson(json["product_id"]),
        orderId: json["order_id"] == null ? null : OrderId.fromJson(json["order_id"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
        "price": price,
        "product_id": productId?.toJson(),
        "order_id": orderId?.toJson(),
      };
}

class OrderId {
  int? totalAmount;
  int? id;
  DateTime? dateCreated;

  OrderId({
    this.totalAmount,
    this.id,
    this.dateCreated,
  });

  factory OrderId.fromJson(Map<String, dynamic> json) => OrderId(
        totalAmount: json["total_amount"],
        id: json["id"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
      );

  Map<String, dynamic> toJson() => {
        "total_amount": totalAmount,
        "id": id,
        "date_created": dateCreated?.toIso8601String(),
      };
}

class ProductId {
  String? name;

  ProductId({
    this.name,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
