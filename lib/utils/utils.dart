// import 'package:flutter/material.dart';

class Utils {
  static String getImagePath(String name, {String format = 'png'}) {
    //'assets/images/ic_launcher_news.png'
    return 'assets/images/$name.$format';
  }
}
