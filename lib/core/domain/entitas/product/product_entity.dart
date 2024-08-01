// To parse this JSON data, do
//
//     final productEntity = productEntityFromJson(jsonString);

import 'dart:convert';

ProductEntity productEntityFromJson(String str) => ProductEntity.fromJson(json.decode(str));

String productEntityToJson(ProductEntity data) => json.encode(data.toJson());

class ProductEntity {
  int? id;
  String? status;
  String? userCreated;
  DateTime? dateCreated;
  String? name;
  int? price;
  int? stock;
  CategoryId? categoryId;
  String? image;

  ProductEntity({
    this.id,
    this.status,
    this.userCreated,
    this.dateCreated,
    this.name,
    this.price,
    this.stock,
    this.categoryId,
    this.image,
  });

  factory ProductEntity.fromJson(Map<String, dynamic> json) => ProductEntity(
        id: json["id"],
        status: json["status"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        name: json["name"],
        price: json["price"],
        stock: json["stock"],
        categoryId: json["category_id"] == null ? null : CategoryId.fromJson(json["category_id"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "name": name,
        "price": price,
        "stock": stock,
        "category_id": categoryId?.toJson(),
        "image": image,
      };
}

class CategoryId {
  int? id;
  String? name;

  CategoryId({
    this.id,
    this.name,
  });

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
