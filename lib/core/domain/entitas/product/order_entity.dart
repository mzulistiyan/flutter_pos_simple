// To parse this JSON data, do
//
//     final orderEntity = orderEntityFromJson(jsonString);

import 'dart:convert';

OrderEntity orderEntityFromJson(String str) => OrderEntity.fromJson(json.decode(str));

String orderEntityToJson(OrderEntity data) => json.encode(data.toJson());

class OrderEntity {
  DateTime? dateCreated;
  int? id;
  int? totalAmount;

  OrderEntity({
    this.dateCreated,
    this.id,
    this.totalAmount,
  });

  factory OrderEntity.fromJson(Map<String, dynamic> json) => OrderEntity(
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        id: json["id"],
        totalAmount: json["total_amount"],
      );

  Map<String, dynamic> toJson() => {
        "date_created": dateCreated?.toIso8601String(),
        "id": id,
        "total_amount": totalAmount,
      };
}
