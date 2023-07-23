import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_app/config/app_color.dart';
import 'package:inventory_app/config/session.dart';
import 'package:inventory_app/controller/c_user.dart';
import 'package:inventory_app/login/login_page.dart';
import 'package:inventory_app/page/dashboard_page.dart';

import 'data/model/user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Session.getUser();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final cUser = Get.put(CUser());

    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
            primaryColor: AppColor.primary,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(backgroundColor: AppColor.primary),
            colorScheme:
                ColorScheme.dark().copyWith(primary: AppColor.primary)),
        home: Obx(() {
          if (cUser.data.idUser == null) return const LoginPage();
          return const DashboardPage();
        }));
  }
}
