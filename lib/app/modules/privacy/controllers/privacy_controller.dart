import 'package:get/get.dart';

import '../../../constants/reusable/reusable.dart';

class PrivacyController extends GetxController {
  final count = 0.obs;
  final reusableWidget = ReusableWidget();

  void increment() => count.value++;
}
