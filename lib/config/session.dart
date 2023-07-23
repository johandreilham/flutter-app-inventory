import 'dart:convert';

import 'package:get/get.dart';
import 'package:inventory_app/controller/c_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user.dart';

class Session {
  static Future<User> getUser() async {
    User user = User();
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? stringuser = pref.getString("user");
    if (stringuser != null) {
      user = User.fromJson(jsonDecode(stringuser));
    }

    final cUser = Get.put(CUser());
    cUser.data = user;
    return user;
  }

  static Future<bool> saveUser(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool success = await pref.setString('user', jsonEncode(user.toJson()));

    final cUser = Get.put(CUser());
    if (success) cUser.data = user;
    return success;
  }

  static Future<bool> clearUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    bool success = await pref.remove('user');

    final cUser = Get.put(CUser());
    cUser.data = User();
    return success;
  }
}
