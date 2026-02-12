// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  final int? stateCode;
  final String? message;
  final List<NotificationData>? data;

  NotificationModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        stateCode: json["state_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<NotificationData>.from(
                json["data"]!.map((x) => NotificationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "state_code": stateCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NotificationData {
  final int? id;
  final int? studentId;
  final String? type;
  final String? title;
  final String? body;
  final Payload? payload;
  final bool? isRead;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Student? student;

  NotificationData({
    this.id,
    this.studentId,
    this.type,
    this.title,
    this.body,
    this.payload,
    this.isRead,
    this.createdAt,
    this.updatedAt,
    this.student,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: _toInt(json["id"]),
        studentId: _toInt(json["student_id"]),
        type: json["type"]?.toString(),
        title: json["title"]?.toString(),
        body: json["body"]?.toString(),
        payload:
            json["payload"] == null ? null : Payload.fromJson(json["payload"]),
        isRead: _toBool(json["is_read"]),
        createdAt: _toDate(json["created_at"]),
        updatedAt: _toDate(json["updated_at"]),
        student:
            json["student"] == null ? null : Student.fromJson(json["student"]),
      );

  static bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return false;
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null || value == "") return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "student_id": studentId,
        "type": type,
        "title": title,
        "body": body,
        "payload": payload?.toJson(),
        "is_read": isRead,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "student": student?.toJson(),
      };
}

class Payload {
  final String? date;

  Payload({
    this.date,
  });

  factory Payload.fromJson(Map<String, dynamic> json) => Payload(
        date: json["date"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
      };
}

class Student {
  final int? id;
  final String? registrationNo;
  final String? collegeName;
  final dynamic profileImage;
  final String? name;
  final String? hostelName;
  final String? roomNo;
  final String? email;
  final String? residentialAddress;
  final String? currentlyPursuing;
  final int? currentlyStudyingYear;
  final DateTime? date;
  final int? year;
  final String? mobile;
  final String? alternativeMobile;
  final String? advisorGuide;
  final String? bloodGroup;
  final int? deposit;
  final int? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final dynamic profileImageUrl;
  final User? user;

  Student({
    this.id,
    this.registrationNo,
    this.collegeName,
    this.profileImage,
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
    this.createdAt,
    this.updatedAt,
    this.profileImageUrl,
    this.user,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: NotificationData._toInt(json["id"]),
        registrationNo: json["registration_no"]?.toString(),
        collegeName: json["college_name"]?.toString(),
        profileImage: json["profile_image"],
        name: json["name"]?.toString(),
        hostelName: json["hostel_name"]?.toString(),
        roomNo: json["room_no"]?.toString(),
        email: json["email"]?.toString(),
        residentialAddress: json["residential_address"]?.toString(),
        currentlyPursuing: json["currently_pursuing"]?.toString(),
        currentlyStudyingYear:
            NotificationData._toInt(json["currently_studying_year"]),
        date: NotificationData._toDate(json["date"]),
        year: NotificationData._toInt(json["year"]),
        mobile: json["mobile"]?.toString(),
        alternativeMobile: json["alternative_mobile"]?.toString(),
        advisorGuide: json["advisor_guide"]?.toString(),
        bloodGroup: json["blood_group"]?.toString(),
        deposit: NotificationData._toInt(json["deposit"]),
        userId: NotificationData._toInt(json["user_id"]),
        createdAt: NotificationData._toDate(json["created_at"]),
        updatedAt: NotificationData._toDate(json["updated_at"]),
        profileImageUrl: json["profile_image"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registration_no": registrationNo,
        "college_name": collegeName,
        "profile_image": profileImage,
        "name": name,
        "hostel_name": hostelName,
        "room_no": roomNo,
        "email": email,
        "residential_address": residentialAddress,
        "currently_pursuing": currentlyPursuing,
        "currently_studying_year": currentlyStudyingYear,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "year": year,
        "mobile": mobile,
        "alternative_mobile": alternativeMobile,
        "advisor_guide": advisorGuide,
        "blood_group": bloodGroup,
        "deposit": deposit,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "profile_image": profileImageUrl,
        "user": user?.toJson(),
      };
}

class User {
  final int? id;
  final String? name;
  final String? email;
  final String? mobile;
  final String? fcmToken;
  final dynamic emailVerifiedAt;
  final int? roleId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.fcmToken,
    this.emailVerifiedAt,
    this.roleId,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: NotificationData._toInt(json["id"]),
        name: json["name"]?.toString(),
        email: json["email"]?.toString(),
        mobile: json["mobile"]?.toString(),
        fcmToken: json["fcm_token"]?.toString(),
        emailVerifiedAt: json["email_verified_at"],
        roleId: NotificationData._toInt(json["role_id"]),
        createdAt: NotificationData._toDate(json["created_at"]),
        updatedAt: NotificationData._toDate(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile": mobile,
        "fcm_token": fcmToken,
        "email_verified_at": emailVerifiedAt,
        "role_id": roleId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
