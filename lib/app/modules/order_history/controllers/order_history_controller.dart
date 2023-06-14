// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Services/graphql_conf.dart';
import '../../../common/graphql_common_api.dart';
import '../../../common/widgets/custom_snack_bars.dart';
import '../../../constants/reusable/reusable.dart';
import '../../../constants/reusable/shimmer_loading.dart';
import '../../../utils/constants.dart';
import '../../home/data/Model/orderassignmodel.dart';

import '../data/Model/cancellationreason.dart';
import '../data/Mutattion/cancelorder.dart';
import '../data/Mutattion/getcanclereson_query.dart';
import '../data/Mutattion/order_history_query_mutation.dart';

class OrderHistoryController extends GetxController {
  final shimmerLoading = ShimmerLoading();
  final reusableWidget = ReusableWidget();
  late final subscriptionDocument;
  var startloadingUser = false.obs;
  var hasorderfetched = false.obs;
  var hasorderfetchedsub = false.obs;
  var showError = false.obs;
  int errorCount = 0;
  final count = 0.obs;

  var lname = '';
  late int price;
  late int amount;

  @override
  void onInit() {
    super.onInit();
    getcancellation_reasons();
    getSubscription();
  }

  @override
  void onClose() {}
  void increment() => count.value++;

  OrderHistoryQueryMutation orderHistoryQueryMutation =
      OrderHistoryQueryMutation();

  RxList<OrderAssignedHistory> getOrderModel =
      List<OrderAssignedHistory>.of([]).obs;

  final Rx<CurrentOrderPage> currentOrderPage =
      Rx<CurrentOrderPage>(CurrentOrderPage.ON_GOING);

  void changePage(CurrentOrderPage page) {
    currentOrderPage(page);
  }

  void getSubscription() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString(Constants.vehiclesId) != null) {
      subscriptionDocument = gql(orderHistoryQueryMutation
          .getMyOrdersHistorysub(prefs.getString(Constants.vehiclesId)!));
      hasorderfetchedsub(true);
      if (subscriptionDocument != null) {
        hasorderfetchedsub(true);
      } else {
        hasorderfetchedsub(false);
      }
    }
  }

  RxList<CancellationReasonModel> cancellationReasonModel =
      List<CancellationReasonModel>.of([]).obs;

  GraphQLCommonApi graphQLCommonApi = GraphQLCommonApi();
  void getcancellation_reasons() async {
    try {
      final result = await graphQLCommonApi
          .mutation(GetCancellationreasonsQuery.getcancellationreasons(), {});

      if (result != null) {
        cancellationReasonModel.value = (result['cancellation_reasons'] as List)
            .map((e) => CancellationReasonModel.fromJson(e))
            .toList();
      }
    } on Exception {}
  }

  var startcancelOrder = false.obs;
  var isOrdercanceled = false.obs;
  GraphQLCommonApi graphQLCommonApiordercancel =
      GraphQLCommonApi(configurationRole: ConfigurationRole.Canceller);
  cancelOrder(
    BuildContext context,
    String cancellation_reason,
    String order_assign_id,
    String order_id,
  ) async {
    startcancelOrder(true);

    try {
      await graphQLCommonApiordercancel.mutation(
        CancleOrdermuatation.cancleOrdermuatation,
        <String, dynamic>{
          'id': order_assign_id,
          'oid': order_id,
          'cancellation_reason': cancellation_reason,
        },
      );

      isOrdercanceled(true);
      ShowCommonSnackBar.awesomeSnackbarSucess(
          "Sucess", "Order canceled", context);
    } on Exception catch (e) {
      print(e);
      isOrdercanceled(false);
      startcancelOrder(false);
      ShowCommonSnackBar.awesomeSnackbarfailure(
          "Error", "something went wrong", context);
    }
  }
}

// ignore: constant_identifier_names
enum CurrentOrderPage { ON_GOING, HISTORY }
