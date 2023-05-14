import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/const.dart';
import '../../../theme/custom_sizes.dart';
import '../controllers/notification_page_controller.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationPageView extends GetView<NotificationPageController> {
  const NotificationPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controller.updatenotificationstatus();
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(),
        backgroundColor: const Color(0xffF6FBFB),
        body: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CustomSizes.mp_w_4,
          ),
          child: Column(
            children: [
              SizedBox(
                height: CustomSizes.mp_v_2,
              ),
              Subscription(
                  options: SubscriptionOptions(
                    document: controller.subscriptionDocument,
                  ),
                  builder: (dynamic result) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return Expanded(
                        child: Center(
                          child:
                              controller.shimmerLoading.buildShimmerContent(),
                        ),
                      );
                    }

                    return Expanded(
                      child: buildNotificationsContainer(
                          context,
                          "${result.data!["notifications"].length}  Notifications",
                          result),
                    );
                  }),
              SizedBox(
                height: CustomSizes.mp_v_2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 9.h,
      automaticallyImplyLeading: false,
      leading: IconButton(
        onPressed: () {
          Get.back();
          controller.updatenotificationstatus();
        },
        icon: const Icon(
          Icons.chevron_left,
          color: Colors.black87,
          size: 35,
        ),
      ),
      title: Text(
        "Notifications",
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: 15.sp, color: Colors.black),
      ),
      centerTitle: false,
      backgroundColor: Colors.white,
      shadowColor: Colors.transparent,
    );
  }

  Material buildNotificationsContainer(
      BuildContext context, String title, result) {
    return Material(
      borderRadius: BorderRadius.circular(CustomSizes.radius_6),
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Padding(
        padding: EdgeInsets.all(CustomSizes.mp_w_4),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(CustomSizes.mp_w_2),
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(CustomSizes.radius_6),
                  ),
                  child: Icon(
                    FontAwesomeIcons.bell,
                    size: CustomSizes.icon_size_4,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: CustomSizes.mp_w_4,
                ),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: themeColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                ),
              ],
            ),
            SizedBox(
              height: CustomSizes.mp_v_1,
            ),
            const Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: CustomSizes.mp_v_1,
            ),
            Expanded(
              child: controller.loadingNotification.isFalse
                  ? controller.shimmerLoading.buildShimmerContent()
                  : ListView.separated(
                      itemCount: result.data!["notifications"].length,
                      itemBuilder: (context, index) {
                        return buildNotificationItem(
                            context,
                            result.data!["notifications"][index]["body"],
                            result.data!["notifications"][index]["title"],
                            result.data!["notifications"][index]["created_at"]);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return buildNotifictaionItemSeparator();
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Align buildNotifictaionItemSeparator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: CustomSizes.mp_w_4 * 1.2),
        height: CustomSizes.icon_size_8,
        child: VerticalDivider(
          color: Colors.black.withOpacity(0.3),
        ),
      ),
    );
  }

  Row buildNotificationItem(
      BuildContext context, String body, String title, String createdAt) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              borderRadius: BorderRadius.circular(
                CustomSizes.radius_6,
              ),
              color: themeColor.withOpacity(0.5),
              child: Padding(
                padding: EdgeInsets.all(CustomSizes.mp_w_4 * 1.1),
                child: Icon(
                  FontAwesomeIcons.solidBell,
                  size: CustomSizes.icon_size_4 * 1.2,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              right: -CustomSizes.icon_size_2 * 1.4,
              top: -CustomSizes.icon_size_2 * 0.4,
              child: CircleAvatar(
                radius: CustomSizes.icon_size_4 * 0.8,
                backgroundColor: Colors.grey,
                child: Icon(
                  Icons.message_rounded,
                  size: CustomSizes.icon_size_2 * 1.3,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: CustomSizes.mp_w_6,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: CustomSizes.font_9,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              SizedBox(
                height: CustomSizes.mp_v_1 / 2,
              ),
              Text(
                body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.black,
                      fontSize: CustomSizes.font_9,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(
                height: CustomSizes.mp_v_1 / 2,
              ),
              Text(
                timeago.format(DateTime.parse(createdAt.toString())),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                      fontSize: CustomSizes.font_9,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
