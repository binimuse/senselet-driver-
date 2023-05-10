// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../../../common/widgets/app_language_picker_dialog.dart';
import '../../../../constants/const.dart';
import '../../../../routes/app_pages.dart';
import '../../../../utils/constants.dart';
import '../../controllers/home_controller.dart';

class NavDrawer extends StatefulWidget {
  HomeController controller = Get.find<HomeController>();

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Colors.white,
        child: Container(
          height: double.infinity,
          child: Stack(
            children: [
              Divider(
                height: 1, // Thickness of the divider
                color: Colors.grey,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius:
                                25.0, // increase the radius to make the circle larger
                            backgroundColor: themeColor.withOpacity(0.1),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4.0),
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Text(
                            "Senselet Driver",
                            style: TextStyle(
                              color: const Color(0xff129797),
                              fontWeight: FontWeight.w400,
                              fontSize: 15.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 2.w,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => widget.controller.hasConstatFeched.value
                        ? Padding(
                            padding: EdgeInsets.all(1.h),
                            child: Container(
                              // width: 80.w,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [themeColor, themeColorFaded],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.account_box,
                                    size: 13.h,
                                    color: Colors.white,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.controller.driverModel.first
                                            .firstName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
                                      ),
                                      Text(
                                        widget.controller.driverModel.first
                                            .gender,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.sp),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  )
                                ],
                              ),
                            ),
                          )
                        : SizedBox()),
                    buildRow(
                        textcolors: Colors.grey,
                        colors: themeColorFaded,
                        context: context,
                        icon: FontAwesomeIcons.user,
                        title: "Profile",
                        onTap: () {}),
                    buildRow(
                        textcolors: Colors.grey,
                        colors: themeColorFaded,
                        context: context,
                        icon: FontAwesomeIcons.clockRotateLeft,
                        title: "History",
                        onTap: () {
                          Get.toNamed(Routes.ORDER_HISTORY);
                        }),
                    buildRow(
                        textcolors: Colors.grey,
                        colors: themeColorFaded,
                        context: context,
                        icon: FontAwesomeIcons.language,
                        title: "Change language".tr,
                        onTap: () {
                          Get.dialog(
                            const AppLanguagePickerDialog(),
                          );
                        }),
                    buildRow(
                        textcolors: Colors.grey,
                        colors: themeColorFaded,
                        context: context,
                        icon: FontAwesomeIcons.gear,
                        title: "Settings",
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => SettingsFourPage()));
                        }),
                    buildRow(
                        textcolors: Colors.grey,
                        colors: themeColorFaded,
                        context: context,
                        icon: FontAwesomeIcons.info,
                        title: "About",
                        onTap: () {}),
                    buildRow(
                        textcolors: Colors.grey,
                        colors: Colors.red,
                        context: context,
                        icon: FontAwesomeIcons.arrowRightFromBracket,
                        title: "Logout",
                        onTap: () {
                          Get.dialog(AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: const Text(
                              'Warning, Logging Out',
                              style: TextStyle(fontSize: 18, color: Colors.red),
                            ),
                            content: const Text(
                                'Are you sure you want to log out ?',
                                style: TextStyle(
                                    fontSize: 13, color: Colors.black)),
                            actions: [
                              cancelButton,
                              continueButton,
                            ],
                          ));
                        }),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget buildRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color colors,
    required Color textcolors,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 1.h,
            horizontal: 6.w,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: colors,
                    size: 6.w,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: textcolors,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp),
                  ),
                  const Spacer(),
                ],
              ),
              Divider()
            ],
          ),
        ),
      ),
    );
  }

  Widget cancelButton = TextButton(
      onPressed: () {
        // Navigator.pop();
        Get.back();
      },
      child: const Text('No', style: TextStyle(color: SOFT_BLUE)));

  Widget continueButton = TextButton(
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();

        final acc = await prefs.remove(Constants.userAccessTokenKey);
        final id = await prefs.remove(Constants.userId);
        final refreshTokenKey = await prefs.remove('refreshTokenKey');
        final verifyEmail = await prefs.remove(Constants.verifyEmail);

        if (acc && id && refreshTokenKey && verifyEmail) {
          Get.offAllNamed(Routes.SIGNIN);
        }
        // Navigator.pop(context);
      },
      child: const Text('Yes', style: TextStyle(color: SOFT_BLUE)));
}
