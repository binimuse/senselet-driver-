import 'package:get/get.dart';

import '../../../constants/reusable/reusable.dart';

class SettingController extends GetxController {
  final count = 0.obs;
  var isActive = false.obs;
  final reusableWidget = ReusableWidget();
  void increment() => count.value++;
}
