// To parse this JSON data, do
//
//     final monthlyTransactionModel = monthlyTransactionModelFromJson(jsonString);

import 'dart:convert';

MonthlyTransactionModel monthlyTransactionModelFromJson(String str) => MonthlyTransactionModel.fromJson(json.decode(str));

String monthlyTransactionModelToJson(MonthlyTransactionModel data) => json.encode(data.toJson());

class MonthlyTransactionModel {
  final int? stateCode;
  final String? message;
  final Data? data;

  MonthlyTransactionModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory MonthlyTransactionModel.fromJson(Map<String, dynamic> json) => MonthlyTransactionModel(
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
  final int? id;
  final DateTime? billDate;
  final int? year;
  final int? month;
  final String? currentMonthExpense;
  final String? currentTotalCollection;
  final String? currentMonthTotalGuestAmount;
  final String? currentMonthTotalCashOnHand;
  final String? currentMonthTotalAmount;
  final String? currentTotalRemaining;
  final String? currentMonthTotalEatDay;
  final String? currentMonthTotalCutDay;
  final String? currentMonthTotalDay;
  final String? currentMonthProfit;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.billDate,
    this.year,
    this.month,
    this.currentMonthExpense,
    this.currentTotalCollection,
    this.currentMonthTotalGuestAmount,
    this.currentMonthTotalCashOnHand,
    this.currentMonthTotalAmount,
    this.currentTotalRemaining,
    this.currentMonthTotalEatDay,
    this.currentMonthTotalCutDay,
    this.currentMonthTotalDay,
    this.currentMonthProfit,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    billDate: json["bill_date"] == null ? null : DateTime.parse(json["bill_date"]),
    year: json["year"],
    month: json["month"],
    currentMonthExpense: json["current_month_expense"],
    currentTotalCollection: json["current_total_collection"],
    currentMonthTotalGuestAmount: json["current_month_total_guest_amount"],
    currentMonthTotalCashOnHand: json["current_month_total_cash_on_hand"],
    currentMonthTotalAmount: json["current_month_total_amount"],
    currentTotalRemaining: json["current_total_remaining"],
    currentMonthTotalEatDay: json["current_month_total_eat_day"],
    currentMonthTotalCutDay: json["current_month_total_cut_day"],
    currentMonthTotalDay: json["current_month_total_day"],
    currentMonthProfit: json["current_month_profit"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "bill_date": billDate?.toIso8601String(),
    "year": year,
    "month": month,
    "current_month_expense": currentMonthExpense,
    "current_total_collection": currentTotalCollection,
    "current_month_total_guest_amount": currentMonthTotalGuestAmount,
    "current_month_total_cash_on_hand": currentMonthTotalCashOnHand,
    "current_month_total_amount": currentMonthTotalAmount,
    "current_total_remaining": currentTotalRemaining,
    "current_month_total_eat_day": currentMonthTotalEatDay,
    "current_month_total_cut_day": currentMonthTotalCutDay,
    "current_month_total_day": currentMonthTotalDay,
    "current_month_profit": currentMonthProfit,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
