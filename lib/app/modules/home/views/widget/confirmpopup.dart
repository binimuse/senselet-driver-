import 'package:flutter/material.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../../../constants/const.dart';

class ConfirmPopup extends StatelessWidget {
  final Function()? onConfirm;

  const ConfirmPopup({Key? key, this.onConfirm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConfirmationSlider(
      iconColor: themeColor,
      foregroundColor: themeColor,
      backgroundColorEnd: themeColor,
      text: 'Slide to start',
      onConfirmation: () => onConfirm,
    );
  }
}
