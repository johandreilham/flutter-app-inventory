import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_method/d_method.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:inventory_app/config/app_color.dart';
import 'package:inventory_app/controller/c_user.dart';
import 'package:inventory_app/data/source/source_user.dart';
import 'package:inventory_app/page/dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();
  final cUser = Get.put(CUser());

  void login() async {
    bool success = await SourceUser.login(
      controllerEmail.text,
      controllerPassword.text,
    );

    if (success == true) {
      DInfo.dialogSuccess(context, 'Login Success');
      DInfo.closeDialog(context, actionAfterClose: () {
        if (cUser.data.level == "Employee" &&
            controllerPassword.text == '123456') {
          DMethod.printTitle("Level User", cUser.data.level ?? '');
          changePassword();
        } else {
          Get.off(() => DashboardPage());
        }
      });
    } else {
      DInfo.dialogError(context, 'Login Failed');
      DInfo.closeDialog(context);
    }
  }

  changePassword() async {
    final controller = TextEditingController();

    bool yes = await Get.dialog(
      AlertDialog(
        title: Text('Change Your Password'),
        content: DInput(
          controller: controller,
          title: 'New Password',
          hint: "79djd8",
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Change'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    if (yes) {
      bool success = await SourceUser.changePassword(
        cUser.data.idUser.toString(),
        controller.text,
      );
      if (success == true) {
        DInfo.dialogSuccess(context, 'Change Password Success');
        DInfo.closeDialog(context, actionAfterClose: () {
          Get.off(() => DashboardPage());
        });
      } else {
        DInfo.dialogError(context, 'Change Password Failed');
        DInfo.closeDialog(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        //agar responsive ketika membuka keyboard
        child: LayoutBuilder(builder: (context, boxConstrains) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: boxConstrains.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DView.spaceHeight(
                          MediaQuery.of(context).size.height * 0.15),
                      Text(
                        'Application \nInventory',
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(color: Colors.white),
                      ),
                      DView.spaceHeight(8),
                      Container(
                        height: 6,
                        width: 220,
                        decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    ],
                  ),
                  DView.spaceHeight(MediaQuery.of(context).size.height * 0.15),
                  Column(
                    children: [
                      input(controllerEmail, Icons.email, 'Email'),
                      DView.spaceHeight(),
                      input(
                          controllerPassword, Icons.vpn_key, 'Password', true),
                      DView.spaceHeight(),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () => login(),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                      DView.spaceHeight(
                          MediaQuery.of(context).size.height * 0.15),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget input(TextEditingController controller, IconData icon, String hint,
      [bool obsecure = false]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          fillColor: AppColor.input,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(6)),
          prefixIcon: Icon(
            icon,
            color: AppColor.primary,
          ),
          hintText: hint),
      obscureText: obsecure,
    );
  }
}
