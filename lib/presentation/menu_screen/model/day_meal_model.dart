import 'dart:convert';

DayMealModel dayMealModelFromJson(String str) =>
    DayMealModel.fromJson(json.decode(str));

String dayMealModelToJson(DayMealModel data) => json.encode(data.toJson());

class DayMealModel {
  int? stateCode;
  String? message;
  List<MealData>? data;

  DayMealModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory DayMealModel.fromJson(Map<String, dynamic> json) => DayMealModel(
        stateCode: json["state_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : (json["data"] is List
                ? List<MealData>.from(
                    json["data"].map((x) => MealData.fromJson(x)))
                : [MealData.fromJson(json["data"])]),
      );

  Map<String, dynamic> toJson() => {
        "state_code": stateCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class MealData {
  int? id;
  String? day;
  String? breakfast;
  String? lunch;
  String? dinner;
  DateTime? createdAt;
  DateTime? updatedAt;

  MealData({
    this.id,
    this.day,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.createdAt,
    this.updatedAt,
  });

  factory MealData.fromJson(Map<String, dynamic> json) => MealData(
        id: json["id"],
        day: json["day"],
        breakfast: json["breakfast"],
        lunch: json["lunch"],
        dinner: json["dinner"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "day": day,
        "breakfast": breakfast,
        "lunch": lunch,
        "dinner": dinner,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
