import 'package:d_info/d_info.dart';
import 'package:d_view/d_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:inventory_app/config/app_color.dart';
import 'package:inventory_app/config/session.dart';
import 'package:inventory_app/controller/c_dashboard.dart';
import 'package:inventory_app/controller/c_user.dart';
import 'package:inventory_app/login/login_page.dart';
import 'package:inventory_app/page/employee/employee_page.dart';
import 'package:inventory_app/page/product/product_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final cUser = Get.put(CUser());
  final cDashboard = Get.put(CDashboard());

  logout() async {
    bool? yes = await DInfo.dialogConfirmation(
        context, 'Logout', 'You sure to logout?');
    if (yes!) {
      Session.clearUser();
      Get.off(() => const LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Page'),
        actions: [
          IconButton(onPressed: () => logout(), icon: Icon(Icons.logout))
        ],
      ),
      body: ListView(
        children: [
          profileCard(textTheme),
          Padding(
            padding: const EdgeInsets.all(16),
            child: DView.textTitle('Menu'),
          ),
          GridView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 110,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            children: [
              menuProduct(textTheme),
              Obx(() {
                if (cUser.data.level == 'admin') {
                  return menuEmpleyee(textTheme);
                } else {
                  return const SizedBox();
                }
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget menuProduct(TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const ProductPage())
            ?.then((value) => cDashboard.setProduct());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColor.input, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product',
              style: textTheme.titleLarge,
            ),
            Row(
              children: [
                Obx(() {
                  return Text(
                    cDashboard.product.toString(),
                    style: textTheme.headlineMedium!.copyWith(
                      color: Colors.white,
                    ),
                  );
                }),
                DView.spaceWidth(8),
                const Text(
                  'Item',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget menuEmpleyee(TextTheme textTheme) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const EmployeePage())
            ?.then((value) => cDashboard.setEmployee());
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: AppColor.input, borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employee',
              style: textTheme.titleLarge,
            ),
            Obx(() {
              return Text(
                cDashboard.employee.toString(),
                style: textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Container profileCard(TextTheme textTheme) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: AppColor.primary, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            return Text(
              "Wellcome ${cUser.data.name}!",
              style: textTheme.headlineSmall,
            );
          }),
          DView.spaceHeight(8),
          Obx(() {
            return Text(
              cUser.data.email ?? '',
              style: textTheme.titleMedium,
            );
          }),
          DView.spaceHeight(12),
          Obx(() {
            return Text(
              "Level : ${cUser.data.level}",
              style: textTheme.bodyMedium,
            );
          }),
        ],
      ),
    );
  }
}
