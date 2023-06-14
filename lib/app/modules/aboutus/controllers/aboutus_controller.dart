import 'package:get/get.dart';

import '../../../constants/reusable/reusable.dart';

class AboutusController extends GetxController {
  final reusableWidget = ReusableWidget();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
