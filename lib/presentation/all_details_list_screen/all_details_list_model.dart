// To parse this JSON data, do
//
//     final studentAllDetailsModel = studentAllDetailsModelFromJson(jsonString);

import 'dart:convert';

StudentAllDetailsModel studentAllDetailsModelFromJson(String str) => StudentAllDetailsModel.fromJson(json.decode(str));

String studentAllDetailsModelToJson(StudentAllDetailsModel data) => json.encode(data.toJson());

class StudentAllDetailsModel {
  final int? stateCode;
  final String? message;
  final List<AllData>? data;

  StudentAllDetailsModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory StudentAllDetailsModel.fromJson(Map<String, dynamic> json) => StudentAllDetailsModel(
    stateCode: json["state_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<AllData>.from(json["data"]!.map((x) => AllData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class AllData {
  final int? id;
  final int? studentId;
  final int? totalDay;
  final int? totalEatDay;
  final int? cutDay;
  final double? amount;
  final DateTime? date;
  final int? simpleGuest;
  final double? simpleGuestAmount;
  final int? feastGuest;
  final double? feastGuestAmount;
  final String? rate;
  final double? dueAmount;
  final double? penaltyAmount;
  final double? totalAmount;
  final double? paidAmount;
  final double? remainAmount;
  final String? remark;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? studentName;

  AllData({
    this.id,
    this.studentId,
    this.totalDay,
    this.totalEatDay,
    this.cutDay,
    this.amount,
    this.date,
    this.simpleGuest,
    this.simpleGuestAmount,
    this.feastGuest,
    this.feastGuestAmount,
    this.dueAmount,
    this.penaltyAmount,
    this.totalAmount,
    this.rate,
    this.paidAmount,
    this.remainAmount,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.studentName,
  });

  factory AllData.fromJson(Map<String, dynamic> json) => AllData(
    id: json["id"],
    studentId: json["student_id"],
    totalDay: json["total_day"],
    totalEatDay: json["total_eat_day"],
    cutDay: json["cut_day"],
    amount: json["amount"].toDouble(),
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    simpleGuest: json["simple_guest"],
    simpleGuestAmount: json["simple_guest_amount"].toDouble(),
    feastGuest: json["feast_guest"],
    feastGuestAmount: json["feast_guest_amount"].toDouble(),
    dueAmount: json["due_amount"].toDouble(),
    penaltyAmount: json["penalty_amount"].toDouble(),
    totalAmount: json["total_amount"].toDouble(),
    paidAmount: json["paid_amount"].toDouble(),
    rate: json["rate"] ,
    remainAmount: json["remain_amount"].toDouble(),
    remark: json["remark"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    studentName: json["student_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "student_id": studentId,
    "total_day": totalDay,
    "total_eat_day": totalEatDay,
    "rate": rate,
    "cut_day": cutDay,
    "amount": amount,
    "date": date?.toIso8601String(),
    "simple_guest": simpleGuest,
    "simple_guest_amount": simpleGuestAmount,
    "feast_guest": feastGuest,
    "feast_guest_amount": feastGuestAmount,
    "due_amount": dueAmount,
    "penalty_amount": penaltyAmount,
    "total_amount": totalAmount,
    "paid_amount": paidAmount,
    "remain_amount": remainAmount,
    "remark": remark,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "student_name": studentName,
  };
}
