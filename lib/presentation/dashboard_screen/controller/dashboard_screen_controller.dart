

import 'dart:convert';

import 'package:get/get.dart';
import 'package:pg_managment/ApiServices/api_service.dart';
import 'package:pg_managment/core/utils/app_network_urls.dart';
import 'package:pg_managment/core/utils/pref_utils.dart';
import 'package:pg_managment/core/utils/string_constant.dart';

class DashboardScreenController extends GetxController {

Rx<ConfigModel> model = ConfigModel().obs;


@override
void onInit() {

  getConfig();
  super.onInit();
}

  Future<void> getConfig() async {

    await ApiService().callGetApi(
        body: {},
        headerWithToken: true,
        showLoader: false,
        url:
        NetworkUrls.getConfigUrl).then(
            (value) async {
          if (value != null && value.statusCode == 200) {
            model.value = ConfigModel.fromJson(value.body);
            if(model.value.data!=null &&model.value.data!.isNotEmpty) {

              for(var item in model.value.data!){
                if(item.configKey=='total_day') {
                  PrefUtils.setString(StringConstants.totalDays,
                  item.configValue ?? '');
                }   if(item.configKey=='eaten_day') {
                  PrefUtils.setString(StringConstants.eatenDays,
                  item.configValue ?? '');
                } if(item.configKey=='penalty') {
                  PrefUtils.setString(StringConstants.penalty,
                  item.configValue ?? '');
                }
                if(item.configKey=='feast_guest') {
                  PrefUtils.setString(StringConstants.feastGuest,
                      item.configValue ?? '');
                }
                if(item.configKey=='simple_guest') {
                  PrefUtils.setString(StringConstants.simpleGuest,
                      item.configValue ?? '');
                }}

            }
          }
        });
  }



}


ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  final int? stateCode;
  final String? message;
  final List<Datum>? data;

  ConfigModel({
    this.stateCode,
    this.message,
    this.data,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
    stateCode: json["state_code"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "state_code": stateCode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  final int? id;
  final String? configKey;
  final String? configValue;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Datum({
    this.id,
    this.configKey,
    this.configValue,
    this.createdAt,
    this.updatedAt,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    configKey: json["config_key"],
    configValue: json["config_value"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "config_key": configKey,
    "config_value": configValue,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
