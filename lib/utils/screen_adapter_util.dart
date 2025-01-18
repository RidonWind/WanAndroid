import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 屏幕工具类
class ScreenAdapter {
  static init(context) {
    // ScreenUtil.instance = ScreenUtil(width: 720, height: 1280)..init(context);
    ScreenUtil.init(context, designSize: const Size(351.2, 780.5));
  }
}
