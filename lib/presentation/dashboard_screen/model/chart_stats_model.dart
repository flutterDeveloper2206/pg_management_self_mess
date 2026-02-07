import 'dart:convert';

ChartStatsModel chartStatsModelFromJson(String str) =>
    ChartStatsModel.fromJson(json.decode(str));

String chartStatsModelToJson(ChartStatsModel data) =>
    json.encode(data.toJson());

class ChartStatsModel {
  int? stateCode;
  String? message;
  List<ChartData>? data;

  ChartStatsModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory ChartStatsModel.fromJson(Map<String, dynamic> json) =>
      ChartStatsModel(
        stateCode: json["state_code"],
        message: json["message"],
        data: json["data"] == null
            ? []
            : List<ChartData>.from(
                json["data"]!.map((x) => ChartData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "state_code": stateCode,
        "message": message,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class ChartData {
  String? monthName;
  int? expense;
  int? income;
  int? profit;

  ChartData({
    this.monthName,
    this.expense,
    this.income,
    this.profit,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        monthName: json["month_name"],
        expense: json["expense"],
        income: json["income"],
        profit: json["profit"],
      );

  Map<String, dynamic> toJson() => {
        "month_name": monthName,
        "expense": expense,
        "income": income,
        "profit": profit,
      };
}
