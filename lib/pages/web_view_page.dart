import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wan_andriod/utils/route_util.dart';
// import 'package:wechat_kit/wechat_kit.dart';
// import 'package:fluwx/fluwx.dart';
// import 'package:flutter_share/flutter_share.dart';

///加载网页页面
class WebViewPage extends StatefulWidget {
  //传值{'title':String,'url':String}
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  ///标题
  final String _title = Get.arguments['title'];

  ///链接
  final String _url = Get.arguments['url'];

  bool isLoad = true;
  late final WebViewController _webViewController;

  // late final StreamSubscription<WechatResp> _respSubs;
  // WechatAuthResp? _authResp;

  @override
  void initState() {
    super.initState();
    // _respSubs = WechatKitPlatform.instance.respStream().listen(_listenResp);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          print('加载进度:$progress%');
        },
        //开始加载
        onPageStarted: (String url) {
          setState(() {
            isLoad = true;
          });
        },
        //结束加载
        onPageFinished: (String url) {
          setState(() {
            isLoad = false;
          });
        },
        onHttpError: (HttpResponseError error) {
          print('-------------------------onHttpError:${error.response}');
        },
        onWebResourceError: (WebResourceError error) {
          print(
              '-------------------------onWebResourceError:${error.description}');
        },
        onNavigationRequest: (NavigationRequest request) {
          //点击网页里的链接,如果开头是xxx,则阻止访问,如果不是则允许访问
          if (request.url.startsWith('https://youtube.com')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
          /*AndroidManifest.xml文件中添加以下配置来允许明文网络流量：
          因为Android 9（Pie）及以上版本默认禁止了明文网络流量。不能用http://开头,必须用https://开头
          <application
            ***
            android:usesCleartextTraffic="true">
          */
        },
      ))
      ..loadRequest(Uri.parse(_url));
  }

  @override
  void dispose() {
    // _respSubs.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4, //给一点点阴影
        title: Text(_title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: isLoad
              ? const LinearProgressIndicator()
              : Container(), //加载的时候显示加载进度条
        ),
        actions: <Widget>[
          IconButton(
              tooltip: '用流量器打开',
              onPressed: () {
                RouteUtil.launchInBrowser(_url, title: _title);
              },
              //用浏览器打开
              icon: const Icon(
                Icons.language,
                size: 20.0,
              )),
          IconButton(
              tooltip: '分享',
              onPressed: () async {
                final result = await Share.share('$_title:$_url');
                if (result.status == ShareResultStatus.success) {
                  T.show('感谢您的分享');
                }
              },
              //分享
              icon: const Icon(
                Icons.share,
                size: 20.0,
              )),
          /*
           PopupMenuButton(
            padding: const EdgeInsets.all(0.0),
            onSelected: onPopSelected,
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
               PopupMenuItem<String>(
                  value: "browser",
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      dense: false,
                      title: Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.language,
                              color: Colors.grey,
                              size: 22.0,
                            ),
                            GapsUtil.gapH10,
                            const Text('浏览器打开')
                          ],
                        ),
                      ))),
              PopupMenuItem<String>(
                  value: "share",
                  child: ListTile(
                      contentPadding: const EdgeInsets.all(0.0),
                      dense: false,
                      title: Container(
                        alignment: Alignment.center,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.share,
                              color: Colors.grey[600],
                              size: 22.0,
                            ),
                            GapsUtil.gapH10,
                            const Text('分享')
                          ],
                        ),
                      ))),
            ],
          )*/
        ],
      ),
      body: WebViewWidget(controller: _webViewController),
    );
  }

  // void onPopSelected(String value) {
  //   switch (value) {
  //     case "browser":
  //       RouteUtil.launchInBrowser(_url, title: _title);
  //       break;
  //     case "share":
  //       //  Share.share('$_title : $_url');
  //       break;
  //     default:
  //       break;
  //   }
  // }
}
