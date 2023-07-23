import 'package:get/get.dart';
import 'package:inventory_app/data/model/user.dart';

class CUser extends GetxController {
  final Rx<User> _data = User().obs;
  User get data => _data.value;
  set data(User newData) {
    _data.value = newData;
  }
}
