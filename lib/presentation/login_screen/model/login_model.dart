// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  final int? stateCode;
  final String? message;
  final Data? data;

  LoginModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    stateCode: json["state_code"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  final String? accessToken;
  final String? tokenType;
  final User? user;

  Data({
    this.accessToken,
    this.tokenType,
    this.user,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"],
    tokenType: json["token_type"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user?.toJson(),
  };
}

class User {
  final int? id;
  final int? studentId;
  final String? name;
  final String? email;
  final String? mobile;
  final dynamic emailVerifiedAt;
  final int? roleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.emailVerifiedAt,
    this.roleId,
    this.studentId,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    studentId: json["student_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    emailVerifiedAt: json["email_verified_at"],
    roleId: json["role_id"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "name": name,
    "email": email,
    "mobile": mobile,
    "email_verified_at": emailVerifiedAt,
    "role_id": roleId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
