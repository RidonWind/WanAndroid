import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_andriod/common/common.dart';

/// Toast 简单封装
class T {
  static show(String msg,
      {Toast toastLength = Toast.LENGTH_SHORT,
      ToastGravity gravity = ToastGravity.CENTER,
      int timeInSecForIosWeb = 3,
      Color backgroundColor = CON.transparent_ba,
      Color textColor = Colors.white,
      double fontSize = 16.0}) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: toastLength,
        gravity: gravity,
        timeInSecForIosWeb: timeInSecForIosWeb,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16.0);
  }
}
