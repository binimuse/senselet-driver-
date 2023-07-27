import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/const.dart';
import '../../../../theme/app_assets.dart';
import '../../../../theme/custom_sizes.dart';
import '../../../account/controllers/account_controller.dart';
import '../../../home/data/Model/orderassignmodel.dart';
import '../../controllers/order_history_controller.dart';
import 'order_item.dart';

class OngoingPage extends GetView<OrderHistoryController> {
  const OngoingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.hasorderfetchedsub.value != true
        ? controller.shimmerLoading.buildShimmerContent()
        : Subscription(
            options: SubscriptionOptions(
              document: controller.subscriptionDocument,
            ),
            builder: (dynamic result) {
              if (result.hasException) {
                LinkException linkException = result.exception?.linkException;
                if (linkException is UnknownException &&
                    linkException.message.contains('JWTExpired')) {
                  final AccountController accountController =
                      Get.put(AccountController());
                  accountController.logout();
                  return SizedBox();
                } else {
                  return Text(result.exception.toString());
                }
              }

              if (result.isLoading) {
                return _buildLoadingWidget();
              }

              // Filter the orders based on the condition

              List<OrderAssignedHistory> assignedOrders = _filterAssignedOrders(
                      result.data!["order_assigned_histories"])
                  .map<OrderAssignedHistory>(
                      (order) => convertToOrderModel(order))
                  .toList();

              // If there are no "ASSIGNED" orders, display the Lottie animation
              if (assignedOrders.isEmpty) {
                return _buildEmptyOrdersWidget(context);
              } else {
                // Display the ListView.builder with the filtered orders
                return ListView.builder(
                  itemCount: assignedOrders.length,
                  itemBuilder: (context, index) {
                    controller.getOrderModel.assign(assignedOrders[index]);
                    return OrderItem(
                      order: assignedOrders[index],
                      history: false,
                      index: index,
                      controller: controller,
                    );
                  },
                );
              }
            },
          ));
  }

  OrderAssignedHistory convertToOrderModel(dynamic data) {
    return OrderAssignedHistory.fromMap(data);
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorWidget(String errorMessage) {
    return Text(errorMessage);
  }

  Widget _buildEmptyOrdersWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: CustomSizes.icon_size_18,
          height: CustomSizes.icon_size_18,
          child: Center(
            child: Lottie.asset(AppAssets.warningFaceLottie, fit: BoxFit.cover),
          ),
        ),
        Text(
          "No Order found",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                fontSize: 12.sp,
                color: themeColor,
                fontWeight: FontWeight.w400,
              ),
        ),
      ],
    );
  }

  List _filterAssignedOrders(List orders) {
    return orders.where((order) {
      return order["order"]["order_status"] == null ||
          order["order"]["order_status"] == "ASSIGNED";
    }).toList();
  }
}
