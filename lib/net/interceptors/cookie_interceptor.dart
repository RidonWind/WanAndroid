import 'dart:async';
import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:wan_andriod/common/common.dart';

/// Cookie 拦截器
class CookieInterceptor extends Interceptor {
  /// Cookie manager for http requests。Learn more details about
  /// CookieJar please refer to [cookie_jar](https://github.com/flutterchina/cookie_jar)
  final CookieJar cookieJar;

  CookieInterceptor(this.cookieJar);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    List<Cookie> cookies = await cookieJar.loadForRequest(options.uri);
    cookies.removeWhere((cookie) {
      if (cookie.expires != null) {
        return cookie.expires!.isBefore(DateTime.now());
      }
      return false;
    });
    String cookie = getCookies(cookies);
    if (cookie.isNotEmpty) options.headers[HttpHeaders.cookieHeader] = cookie;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    _saveCookies(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
    _saveCookies(err.response);
  }

  // @override
  // Future onResponse(Response response) async => _saveCookies(response);

  // @override
  // Future onError(DioError err) async => _saveCookies(err.response);

  _saveCookies(Response? response) {
    // ignore: unnecessary_null_comparison
    if (response != null && response.headers != null) {
      String? uri =
          response.realUri.toString(); //response.request.uri.toString();
      List<String>? cookies = response.headers[HttpHeaders.setCookieHeader];
      if (cookies != null &&
          (uri.contains(CON.KEY_SAVE_USER_LOGIN) ||
              uri.contains(CON.KEY_SAVE_USER_REGISTER))) {
        cookieJar.saveFromResponse(
          response.realUri, //response.request.uri,
          cookies.map((str) => Cookie.fromSetCookieValue(str)).toList(),
        );
      }
    }
  }

  static String getCookies(List<Cookie> cookies) {
    return cookies.map((cookie) => "${cookie.name}=${cookie.value}").join('; ');
  }
}
