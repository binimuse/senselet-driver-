import 'package:get/get.dart';

import '../../../constants/reusable/reusable.dart';

class TermsController extends GetxController {
  final count = 0.obs;
  final reusableWidget = ReusableWidget();

  void increment() => count.value++;
}
