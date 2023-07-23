import 'package:get/get.dart';
import 'package:inventory_app/data/model/user.dart';
import 'package:inventory_app/data/source/source_product.dart';
import 'package:inventory_app/data/source/source_user.dart';

class CDashboard extends GetxController {
  final RxInt _product = 0.obs;
  int get product => _product.value;
  setProduct() async {
    _product.value = await SourceProduct.count();
  }

  final RxInt _employee = 0.obs;
  int get employee => _employee.value;
  setEmployee() async {
    _employee.value = await SourceUser.count();
  }

  @override
  void onInit() {
    setProduct();
    setEmployee();
    super.onInit();
  }
}
