import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/utils/toast_util.dart';

///路由工具类
class RouteUtil {
  ///跳转到 WebView 打开
  static void toWebView(String title, String link) async {
    // link =
    //     'https://file-history.liqucn.com/c9c37ce0ff905fdb1514eb1849a0f37f/676a2639/upload/2024/294/d/com.iflytek.inputmethod_15379_liqucn.com.apk';
    if (link.isEmpty) return;
    if (link.endsWith('.apk')) {
      //如果是安卓安装包,转到浏览器下载
      launchInBrowser(link, title: title);
    } else {
      Get.toNamed('/web_view_page', arguments: {'title': title, 'url': link});
    }
  }

  static void launchInBrowser(String link, {String? title}) async {
    //检查设备上的应用程序能否加载这个置顶url
    if (await canLaunchUrl(Uri.parse(link))) {
      //有应用程序可以直接加载url时
      T.show('跳转到应用');
      await launchUrl(Uri.parse(link));
    } else {
      //没有应用程序可以加载时
      T.show('跳转到网页');
      await launchUrl(Uri.parse(link));
    }
  }

  /// 跳转页面
  static void push(BuildContext? context, Widget? page) async {
    if (context == null || page == null) return;
    await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => page,
        ));
  }
}
