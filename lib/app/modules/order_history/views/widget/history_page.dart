import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../controllers/order_history_controller.dart';
import 'order_item.dart';

class HistoryPage extends GetView<OrderHistoryController> {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (controller.hasorderfetchedsub.value != true)
          ? controller.shimmerLoading.buildShimmerContent()
          : Subscription(
              options: SubscriptionOptions(
                document: controller.subscriptionDocument,
              ),
              builder: (dynamic result) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                    itemCount: controller.getOrderModel.length,
                    itemBuilder: (context, index) {
                      if (result.data!["orders"][index]["order_status"] ==
                          "ASSIGNED") {
                        return OrderItem(
                            order: controller.getOrderModel.elementAt(index),
                            history: true,
                            index: index,
                            controller: controller,
                            status: result.data!["users_by_pk"]["orders"][index]
                                ["status"]);
                      } else {
                        return const SizedBox();
                      }
                    });
              }),
    );
  }
}
