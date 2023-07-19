// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/const.dart';
import '../../../constants/reusable/keyboard.dart';
import '../controllers/profile_page_controller.dart';

class ProfilePageView extends GetView<ProfilePageController> {
  @override
  Widget build(BuildContext context) {
    return Form(
        key: controller.editprofilekey2,
        child: Scaffold(
            backgroundColor: const Color(0xffEBF5F4),
            appBar: controller.reusableWidget.buildAppforpages(context, false),
            body: Obx(
              () => controller.hasuserFeched.value != true
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        children: [
                          SizedBox(
                            height: 3.h,
                          ),
                          TextFormField(
                              controller: controller.first_name,
                              cursorColor: themeColor,
                              validator: (value) {
                                return controller.validateName(value!);
                              },
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                suffixIcon: null,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 3),
                                labelText: "First Name".tr,
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText:
                                    controller.getUserModel.first.firstName,
                                hintStyle: TextStyle(
                                  color: const Color(0xff757A80),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          SizedBox(
                            height: 3.h,
                          ),
                          TextFormField(
                              controller: controller.last_name,
                              cursorColor: themeColor,
                              validator: (value) {
                                return controller.validateName(value!);
                              },
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                suffixIcon: null,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 3),
                                labelText: "Last Name".tr,
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText:
                                    controller.getUserModel.first.fatherName,
                                hintStyle: TextStyle(
                                  color: const Color(0xff757A80),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          SizedBox(
                            height: 3.h,
                          ),
                          TextFormField(
                              enabled: false,
                              cursorColor: themeColor,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                suffixIcon: null,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 3),
                                labelText: "Email".tr,
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: controller.getUserModel.first.email,
                                hintStyle: TextStyle(
                                  color: const Color(0xff757A80),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          SizedBox(
                            height: 3.h,
                          ),
                          TextFormField(
                              controller: controller.phonenumber,
                              cursorColor: themeColor,
                              validator: (value) {
                                return controller.validatephone(value!);
                              },
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              decoration: InputDecoration(
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                border: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: themeColor),
                                ),
                                suffixIcon: null,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 3),
                                labelText: "Phone".tr,
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText:
                                    controller.getUserModel.first.phoneNumber,
                                hintStyle: TextStyle(
                                  color: const Color(0xff757A80),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              )),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            "Gender",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Material(
                            shadowColor: Colors.black38,
                            borderRadius: BorderRadius.circular(16.0),
                            elevation: 1,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                hintText: controller.getUserModel.first.gender
                                    .toString(),
                                hintStyle: TextStyle(
                                  color: const Color(0xffD6D6D6),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: themeColor.withOpacity(0.4),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: themeColor,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.w,
                                  horizontal: 2.7.w,
                                ),
                              ),
                              isExpanded: true,
                              hint: Text(
                                controller.getUserModel.first.gender.toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontFamily: 'WorkSans',
                                ),
                              ),
                              value: controller.selectedGender.value,
                              onChanged: (newValue) {
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                controller.selectedGender.value =
                                    newValue.toString();
                              },
                              items: controller.gender.map((gender) {
                                return DropdownMenuItem(
                                  child: Text(gender),
                                  value: gender,
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null) {
                                  return "Please select your gender";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          Text(
                            "Birthdate",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          Material(
                            shadowColor: Colors.black38,
                            borderRadius: BorderRadius.circular(6.0),
                            elevation: 2,
                            child: TextFormField(
                              controller: controller.dob,
                              onTap: () {
                                KeyboardUtil.hideKeyboard(context);
                                _selectDate(context);
                              },
                              onChanged: (newValue) {
                                KeyboardUtil.hideKeyboard(context);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              onSaved: (newValue) {
                                KeyboardUtil.hideKeyboard(context);
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                              },
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.none,
                              ),
                              decoration: InputDecoration(
                                hintText:
                                    controller.getUserModel.first.birthdate,
                                hintStyle: TextStyle(
                                  color: const Color(0xff757A80),
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                                alignLabelWithHint: true,
                                fillColor: Colors.white,
                                border: InputBorder.none,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: themeColor.withOpacity(0.4),
                                  ),
                                ),
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  borderSide: BorderSide(
                                    color: themeColor,
                                  ),
                                ),
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 5.w,
                                  horizontal: 2.7.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 3.w,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [themeColor, themeColorFaded],
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ElevatedButton(
                                    onPressed: () {
                                      KeyboardUtil.hideKeyboard(context);
                                      if (controller.checkReg()) {
                                        controller.editprofilekey2.currentState!
                                            .save();
                                        controller.updateProfile(context);
                                      } else {
                                        print("object");
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 2.3.h),
                                    ),
                                    child: Obx(
                                      () =>
                                          controller.startupdaeingUser.value !=
                                                  false
                                              ? const CircularProgressIndicator(
                                                  color: Colors.white)
                                              : Text(
                                                  'Save Change',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                    )),
                              ))
                        ],
                      ),
                    ),
            )));
  }

  bool showPassword = false;
  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(
                      Icons.photo_library,
                      color: SOFT_BLUE,
                    ),
                    title: const Text(
                      'Photo Library',
                    ),
                    onTap: () {
                      // controller.getImage(ImageSource.gallery, context);
                      // Navigator.of(context).pop();
                      // _showAlertDialog(context);
                    }),
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                    color: SOFT_BLUE,
                  ),
                  title: const Text('Camera'),
                  onTap: () {
                    // controller.getImage(ImageSource.camera, context);
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  DateTime selectedDate = DateTime.now();
  String? formattedDates;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: themeColor,
                onPrimary: Colors.white,
                surface: Colors.pink,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.black,
            ),
            child: child!,
          );
        },
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;

      formattedDates = DateFormat('yyyy-MM-dd').format(selectedDate);
      // controller.realdate.value = DateFormat.yMd().format(selectedDate);
    }
    controller.dob.text = formattedDates.toString();
    controller.update();
  }
}
