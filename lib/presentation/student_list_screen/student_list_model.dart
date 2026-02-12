// To parse this JSON data, do
//
//     final studentListModel = studentListModelFromJson(jsonString);

import 'dart:convert';

StudentListModel studentListModelFromJson(String str) =>
    StudentListModel.fromJson(json.decode(str));

String studentListModelToJson(StudentListModel data) =>
    json.encode(data.toJson());

class StudentListModel {
  final int? stateCode;
  final String? message;
  final List<Data>? data;

  StudentListModel({this.stateCode, this.message, this.data});

  factory StudentListModel.fromJson(Map<String, dynamic> json) =>
      StudentListModel(
        stateCode: json["state_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<Data>.from(json["data"]!.map((x) => Data.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "message": message,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Data {
  final int? id;
  final String? name;
  final String? hostelName;
  final String? registrationNumber;
  final String? collageName;
  final String? roomNo;
  final String? email;
  final String? residentialAddress;
  final String? currentlyPursuing;
  final int? currentlyStudyingYear;
  final String? date;
  final int? year;
  final String? mobile;
  final String? alternativeMobile;
  final String? advisorGuide;
  final String? bloodGroup;
  final double? deposit;
  final int? userId;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Data({
    this.id,
    this.name,
    this.hostelName,
    this.roomNo,
    this.email,
    this.residentialAddress,
    this.currentlyPursuing,
    this.currentlyStudyingYear,
    this.date,
    this.year,
    this.mobile,
    this.alternativeMobile,
    this.advisorGuide,
    this.bloodGroup,
    this.deposit,
    this.userId,
    this.collageName,
    this.registrationNumber,
    this.profileImage,
    this.createdAt,
    this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    hostelName: json["hostel_name"],
    roomNo: json["room_no"],
    email: json["email"],
    residentialAddress: json["residential_address"],
    currentlyPursuing: json["currently_pursuing"],
    currentlyStudyingYear: json["currently_studying_year"],
    date: json["date"],
    year: json["year"],
    mobile: json["mobile"],
    alternativeMobile: json["alternative_mobile"],
    advisorGuide: json["advisor_guide"],
    bloodGroup: json["blood_group"],
    deposit: json["deposit"]?.toDouble(),
    userId: json["user_id"],
    registrationNumber: json["registration_no"],
    collageName: json["college_name"],
    profileImage: json["profile_image_url"],
    createdAt: json["created_at"] == null
        ? null
        : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null
        ? null
        : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hostel_name": hostelName,
    "registration_no": registrationNumber,
    "college_name": collageName,
    "room_no": roomNo,
    "email": email,
    "residential_address": residentialAddress,
    "currently_pursuing": currentlyPursuing,
    "currently_studying_year": currentlyStudyingYear,
    "date": date,
    "year": year,
    "mobile": mobile,
    "alternative_mobile": alternativeMobile,
    "advisor_guide": advisorGuide,
    "blood_group": bloodGroup,
    "deposit": deposit,
    "user_id": userId,
    "profile_image_url": profileImage,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
