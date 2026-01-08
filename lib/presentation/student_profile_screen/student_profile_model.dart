// To parse this JSON data, do
//
//     final studentProfileModel = studentProfileModelFromJson(jsonString);

import 'dart:convert';

import '../student_list_screen/student_list_model.dart';

StudentProfileModel studentProfileModelFromJson(String str) => StudentProfileModel.fromJson(json.decode(str));

String studentProfileModelToJson(StudentProfileModel data) => json.encode(data.toJson());

class StudentProfileModel {
  final int? stateCode;
  final String? message;
  final Data? data;

  StudentProfileModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) => StudentProfileModel(
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
//
// class Data {
//   final int? id;
//   final String? name;
//   final String? hostelName;
//   final String? roomNo;
//   final String? email;
//   final String? residentialAddress;
//   final String? currentlyPursuing;
//   final int? currentlyStudyingYear;
//   final DateTime? date;
//   final int? year;
//   final String? mobile;
//   final String? alternativeMobile;
//   final String? advisorGuide;
//   final String? bloodGroup;
//   final int? deposit;
//   final int? userId;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//
//   Data({
//     this.id,
//     this.name,
//     this.hostelName,
//     this.roomNo,
//     this.email,
//     this.residentialAddress,
//     this.currentlyPursuing,
//     this.currentlyStudyingYear,
//     this.date,
//     this.year,
//     this.mobile,
//     this.alternativeMobile,
//     this.advisorGuide,
//     this.bloodGroup,
//     this.deposit,
//     this.userId,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) => Data(
//     id: json["id"],
//     name: json["name"],
//     hostelName: json["hostel_name"],
//     roomNo: json["room_no"],
//     email: json["email"],
//     residentialAddress: json["residential_address"],
//     currentlyPursuing: json["currently_pursuing"],
//     currentlyStudyingYear: json["currently_studying_year"],
//     date: json["date"] == null ? null : DateTime.parse(json["date"]),
//     year: json["year"],
//     mobile: json["mobile"],
//     alternativeMobile: json["alternative_mobile"],
//     advisorGuide: json["advisor_guide"],
//     bloodGroup: json["blood_group"],
//     deposit: json["deposit"],
//     userId: json["user_id"],
//     createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
//     updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "hostel_name": hostelName,
//     "room_no": roomNo,
//     "email": email,
//     "residential_address": residentialAddress,
//     "currently_pursuing": currentlyPursuing,
//     "currently_studying_year": currentlyStudyingYear,
//     "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
//     "year": year,
//     "mobile": mobile,
//     "alternative_mobile": alternativeMobile,
//     "advisor_guide": advisorGuide,
//     "blood_group": bloodGroup,
//     "deposit": deposit,
//     "user_id": userId,
//     "created_at": createdAt?.toIso8601String(),
//     "updated_at": updatedAt?.toIso8601String(),
//   };
// }
