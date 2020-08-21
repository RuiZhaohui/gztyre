import 'dart:convert';

import 'package:gztyre/api/model/FunctionPosition.dart';
import 'package:gztyre/api/model/UserInfo.dart';
import 'package:gztyre/api/model/WorkShift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
class Global {
  static SharedPreferences prefs;
  /// 功能位置
  static FunctionPosition functionPosition = FunctionPosition();
  /// 用户信息
  static UserInfo userInfo = UserInfo();
  /// 工作中心
  static WorkShift workShift = WorkShift();
  static List<String> maintenanceGroup = new List();
  static String token = "";
  static String username = "";
  static String password = "";
  static String JPUSH_APP_KEY = "157d1e078648f63c8c6c9030";
  static JPush jPush;

  // 是否为release版
  static bool get isRelease => bool.fromEnvironment("dart.vm.product");

  // 支持图片格式
  static List<String> picType = ["png", "jpg", "jpeg", "bmp", "gif"];
  // 支持视频格式
  static List<String> videoType = ["mp4", "avi", "mpeg4"];
  // 支持音频格式
  static List<String> audioType = ["wav", "mp3"];

  // 环境
  // 生产后台
  static String url = "http://pmapp.gztyre.com:8080";
  static String sapUrl = "http://pmerp.gztyre.com:8000/sap/bc/srt/rfc/sap";
  static Map<String, String> secret = {"Authorization": "Basic UE1BUFAtRVJQOlBtYXBwKzY2Ng=="};
  static String type = "prod";
  static String version = "20200821v2";
  // 开发后台
//  static String url = "http://192.168.6.211:8070";
//  static String sapUrl = "http://61.159.128.211:8005/sap/bc/srt/rfc/sap";
//  static Map<String, String> secret = {"Authorization": "Basic RGV2MDM6MTIzNDU2"};
//  static String version = "20200805";
//  static String type = "dev";

  //初始化全局信息，会在APP启动时执行
  static Future init() async {
    jPush = new JPush();
    prefs = await SharedPreferences.getInstance();
    var _userInfo = prefs.getString("userInfo");
    var _workShift = prefs.getString("workShift");
    maintenanceGroup = prefs.getStringList("maintenanceGroup");
    token = prefs.getString("token");
    username = prefs.getString("username");
    password = prefs.getString("password");
    if (_userInfo != null) {
      try {
        userInfo = UserInfo.formJson(jsonDecode(_userInfo));
      } catch (e) {
        print(e);
      }
    }
    if (_workShift != null) {
      try {
        workShift = WorkShift.formJson(jsonDecode(_workShift));
      } catch (e) {
        print(e);
      }
    }
  }

  // 持久化Profile信息
  static saveUserInfo(UserInfo userInfo) async {
    Global.userInfo = userInfo;
    await prefs.setString("userInfo", jsonEncode(userInfo.toJson()));
  }
  static saveWorkShift(WorkShift workShift) async {
    Global.workShift = workShift;
    await prefs.setString("workShift", jsonEncode(workShift.toJson()));
  }
  static saveMaintenanceGroup(List<String> maintenanceGroup) async {
    Global.maintenanceGroup = maintenanceGroup;
    await prefs.setStringList("maintenanceGroup", maintenanceGroup);
  }

  static saveToken(String token) async {
    Global.token = token;
    await prefs.setString("token", token);
  }

  static saveUsername(String username) async {
    Global.username = username;
    await prefs.setString("username", username);
  }

  static savePassword(String password) async {
    Global.password = password;
    await prefs.setString("password", password);
  }

  static logout() async {
    await prefs.remove("userInfo");
    await prefs.remove("workShift");
    await prefs.remove("maintenanceGroup");
    await prefs.remove("token");
  }

}
