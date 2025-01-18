import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as g;
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/net/dio_manager.dart';
import 'package:wan_andriod/utils/sp_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';

/// WanAndroid 统一接口返回格式错误检测
class WanAndroidErrorInterceptor extends InterceptorsWrapper {
  @override
  // ignore: unnecessary_overrides
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    String errorMsg = DioManager.handleError(err);
    T.show(errorMsg);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    var data = response.data;

    if (data is String) {
      data = json.decode(data);
    }
    if (data is Map) {
      int errorCode =
          data['errorCode'] ?? 0; // 表示如果data['errorCode']为空的话把 0赋值给errorCode
      String errorMsg = data['errorMsg'] ?? '请求失败[$errorCode]';
      if (errorCode == 0) {
        // 正常
        return;
      } else if (errorCode == -1001 /*未登录错误码*/) {
        User().clearUserInfo();
        // dio.clear(); // 调用拦截器的clear()方法来清空等待队列。
        SPUtil.clear();
        goLogin();
        // return dio.reject(errorMsg); // 完成和终止请求/响应
      } else {
        T.show(errorMsg);
        // return dio.reject(errorMsg); // 完成和终止请求/响应
      }
    }
  }

  void goLogin() {
    /// 在拿不到context的地方通过navigatorKey进行路由跳转：
    /// https://stackoverflow.com/questions/52962112/how-to-navigate-without-context-in-flutter-app
    // navigatorKey.currentState.pushNamed(RouterName.login);
    g.Get.toNamed('/login_page');
  }
}
