// To parse this JSON data, do
//
//     final categoryProductEntity = categoryProductEntityFromJson(jsonString);

import 'dart:convert';

CategoryProductEntity categoryProductEntityFromJson(String str) => CategoryProductEntity.fromJson(json.decode(str));

String categoryProductEntityToJson(CategoryProductEntity data) => json.encode(data.toJson());

class CategoryProductEntity {
  int? id;
  String? status;
  String? userCreated;
  DateTime? dateCreated;
  String? name;

  CategoryProductEntity({
    this.id,
    this.status,
    this.userCreated,
    this.dateCreated,
    this.name,
  });

  factory CategoryProductEntity.fromJson(Map<String, dynamic> json) => CategoryProductEntity(
        id: json["id"],
        status: json["status"],
        userCreated: json["user_created"],
        dateCreated: json["date_created"] == null ? null : DateTime.parse(json["date_created"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "status": status,
        "user_created": userCreated,
        "date_created": dateCreated?.toIso8601String(),
        "name": name,
      };
}
