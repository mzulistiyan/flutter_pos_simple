// To parse this JSON data, do
//
//     final signInEntity = signInEntityFromJson(jsonString);

import 'dart:convert';

SignInEntity signInEntityFromJson(String str) => SignInEntity.fromJson(json.decode(str));

String signInEntityToJson(SignInEntity data) => json.encode(data.toJson());

class SignInEntity {
  Data? data;

  SignInEntity({
    this.data,
  });

  factory SignInEntity.fromJson(Map<String, dynamic> json) => SignInEntity(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
      };
}

class Data {
  int? expires;
  String? refreshToken;
  String? accessToken;

  Data({
    this.expires,
    this.refreshToken,
    this.accessToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        expires: json["expires"],
        refreshToken: json["refresh_token"],
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "expires": expires,
        "refresh_token": refreshToken,
        "access_token": accessToken,
      };
}
