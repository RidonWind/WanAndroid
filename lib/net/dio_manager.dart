import 'dart:io';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:wan_andriod/net/interceptors/cookie_interceptor.dart';
import 'package:wan_andriod/net/interceptors/wan_android_error_interceptor.dart';
import 'package:wan_andriod/data/api/apis.dart';
import 'package:path_provider/path_provider.dart';

/**
 * 您首先定义了一个私有的 _dio 变量，它是 Dio 类型的一个实例。
然后，您定义了一个公共的 getter 方法 dio，它返回 _dio 实例。
这种做法的好处是，您可以在类的其他地方使用 _dio 进行网络请求，而外部代码则通过 dio getter 方法来访问这个 Dio 实例，从而保证了封装性和对 _dio 实例的控制。
 */
///使用默认配置
Dio _dio = Dio();

Dio get dio => _dio;

///dio配置
class DioManager {
  static Future init() async {
    dio.options.baseUrl = Apis.BASE_HOST;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.sendTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );
    //TODO 网络环境监听 添加请求拦截器
    dio.interceptors.add(LogInterceptor());
    dio.interceptors.add(WanAndroidErrorInterceptor());
    // dio.interceptors.add(CookieInterceptor2());

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = '${tempDir.path}/dioCookie';
    print('DioUtil : http cookie path = $tempPath');
    CookieJar cj =
        PersistCookieJar(storage: FileStorage(tempPath), ignoreExpires: true);
    dio.interceptors.add(CookieInterceptor(cj));
  }

  static String handleError(error, {String defaultErrorStr = '未知错误~'}) {
    // 定义一个命名参数的方法
    String? errStr;
    if (error is DioException) {
      DioException e = error;
      if (e.type == DioExceptionType.connectionTimeout) {
        errStr = '连接超时~';
      } else if (e.type == DioExceptionType.sendTimeout) {
        errStr = '请求超时~';
      } else if (e.type == DioExceptionType.receiveTimeout) {
        errStr = '响应超时~';
      } else if (e.type == DioExceptionType.cancel) {
        errStr = '请求取消~';
      } else if (e.type == DioExceptionType.badResponse) {
        int? statusCode = e.response?.statusCode;
        String? msg = error.response?.statusMessage;

        /// TODO 异常状态码的处理
        switch (statusCode) {
          case 500:
            errStr = '服务器异常~';
            break;
          case 404:
            errStr = '未找到资源~';
            break;
          default:
            errStr = '$msg[$statusCode]';
            break;
        }
      } else if (e.type == DioExceptionType.connectionError) {
        errStr = '${error.message}';
        if (e.error is SocketException) {
          errStr = '网络连接超时~';
        }
      } else {
        errStr = '未知错误~';
      }
    }
    return errStr ?? defaultErrorStr;
  }
}
