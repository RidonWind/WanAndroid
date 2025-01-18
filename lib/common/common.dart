// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:flutter/material.dart';

class CON {
  ///JSON的成功代码
  static const int CODE_SUCCESS = 0;

  ///toast的背景色
  static const Color transparent_ba = Color(0xBA000000);

  ///文章的'置顶'文字与边框及'新'文字与边框的颜色
  static const Color COLOR_TOP_OR_FRESH = Color(0xFFF44336);

  ///文章的tags属性文字及边框的颜色
  static const Color COLOR_TAGS = Colors.cyan;

  ///文章作者或分享者,分享时间,数据来源文字的颜色
  static const Color COLOR_AUTHOR_DATA_CHAPTER = Color(0xFF757575);

  static const String KEY_DARK = 'dark_key';
  static const String KEY_COOKIES = 'cookies_key';
  static const String KEY_USERNAME = 'username_key';
  static const String KEY_THEME_COLOR = 'theme_color_key';

  static const String KEY_SAVE_USER_LOGIN = 'user/login';
  static const String KEY_SAVE_USER_REGISTER = 'user/register';
//----------------------------------------------------------
  static const Color app_main = Color(0xFF666666);
  static const Color app_bg = Color(0xfff5f5f5);

  static const Color transparent_80 = Color(0x80000000); //<!--204-->
  static const Color white_19 = Color(0X19FFFFFF);
  // static const Color transparent_ba = Color(0xBA000000);//用到放前面了

  static const Color text_dark = Color(0xFF333333);
  static const Color text_normal = Color(0xFF666666);
  static const Color text_gray = Color(0xFF999999);

  static const Color divider = Color(0xffe5e5e5);

  static const Color gray_33 = Color(0xFF333333); //51
  static const Color gray_66 = Color(0xFF666666); //102
  static const Color gray_99 = Color(0xFF999999); //153
  static const Color common_orange = Color(0XFFFC9153); //252 145 83
  static const Color gray_ef = Color(0XFFEFEFEF); //153

  static const Color gray_f0 = Color(0xfff0f0f0); //<!--204-->
  static const Color gray_f5 = Color(0xfff5f5f5); //<!--204-->
  static const Color gray_cc = Color(0xffcccccc); //<!--204-->
  static const Color gray_ce = Color(0xffcecece); //<!--206-->
  static const Color green_1 = Color(0xff009688); //<!--204-->
  static const Color green_62 = Color(0xff626262); //<!--204-->
  static const Color green_e5 = Color(0xffe5e5e5); //<!--204-->

  static const Color green_de = Color(0xffdedede);
}

Map<String, Color> circleAvatarMap = {
  'A': Colors.blueAccent,
  'B': Colors.blue,
  'C': Colors.cyan,
  'D': Colors.deepPurple,
  'E': Colors.deepPurpleAccent,
  'F': Colors.blue,
  'G': Colors.green,
  'H': Colors.lightBlue,
  'I': Colors.indigo,
  'J': Colors.blue,
  'K': Colors.blue,
  'L': Colors.lightGreen,
  'M': Colors.blue,
  'N': Colors.brown,
  'O': Colors.orange,
  'P': Colors.purple,
  'Q': Colors.black,
  'R': Colors.red,
  'S': Colors.blue,
  'T': Colors.teal,
  'U': Colors.purpleAccent,
  'V': Colors.black,
  'W': Colors.brown,
  'X': Colors.blue,
  'Y': Colors.yellow,
  'Z': Colors.grey,
  '#': Colors.blue,
};

Map<String, Color> themeColorMap = {
  'redAccent': Colors.redAccent,
  'gray': CON.gray_33,
  'blue': Colors.blue,
  'blueAccent': Colors.blueAccent,
  'cyan': Colors.cyan,
  'deepPurple': Colors.deepPurple,
  'deepPurpleAccent': Colors.deepPurpleAccent,
  'deepOrange': Colors.deepOrange,
  'green': Colors.green,
  'lime': Colors.lime,
  'indigo': Colors.indigo,
  'indigoAccent': Colors.indigoAccent,
  'orange': Colors.orange,
  'amber': Colors.amber,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
  'black': Colors.black,
};

class AppConfig {
  static const String appName = '玩Android';
  static const String version = '1.0.4';
}
