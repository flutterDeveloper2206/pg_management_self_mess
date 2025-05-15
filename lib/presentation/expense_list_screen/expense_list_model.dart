// To parse this JSON data, do
//
//     final expenseListModel = expenseListModelFromJson(jsonString);

import 'dart:convert';

ExpenseListModel expenseListModelFromJson(String str) => ExpenseListModel.fromJson(json.decode(str));

String expenseListModelToJson(ExpenseListModel data) => json.encode(data.toJson());

class ExpenseListModel {
  final int? stateCode;
  final String? message;
  final List<Data>? data;

  ExpenseListModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory ExpenseListModel.fromJson(Map<String, dynamic> json) => ExpenseListModel(
    stateCode: json["state_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Data {
  final int? id;
  final String? item;
  final double? amount;
  final DateTime? date;
  final String? remark;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.item,
    this.amount,
    this.date,
    this.remark,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    item: json["item"],
    amount: json["amount"]?.toDouble(),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    remark: json["remark"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "item": item,
    "amount": amount,
    "date": date?.toIso8601String(),
    "remark": remark,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
