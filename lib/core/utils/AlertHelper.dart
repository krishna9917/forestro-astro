import 'package:flutter/material.dart';
import 'package:fore_astro_2/core/theme/Colors.dart';
import 'package:quickalert/quickalert.dart';

showAlertPopup(BuildContext context,
    {required String title,
    required String text,
    required QuickAlertType type,
    bool showCancelBtn = false,
    void Function()? onConfirmBtnTap,
    String cancelBtnText = 'Cancel',
    String confirmBtnText = 'Okay',
    bool barrierDismissible = true,
    bool disableBackBtn = false,
    bool showConfirmBtn = true,
    void Function()? onCancelBtnTap}) async {
  QuickAlert.show(
    context: context,
    type: type,
    title: title,
    text: text,
    showCancelBtn: showCancelBtn,
    animType: QuickAlertAnimType.slideInUp,
    showConfirmBtn: showConfirmBtn,
    barrierDismissible: barrierDismissible,
    disableBackBtn: disableBackBtn,
    cancelBtnText: cancelBtnText,
    confirmBtnText: confirmBtnText,
    onCancelBtnTap: onCancelBtnTap,
    onConfirmBtnTap: onConfirmBtnTap,
    confirmBtnColor: AppColor.primary,
    headerBackgroundColor: Colors.white,
  );
}
