import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/event/refresh_share_event.dart';
import 'package:wan_andriod/utils/gaps_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/loading_dialog.dart';

/// 分享文章页面
class ShareArticlePage extends StatefulWidget {
  const ShareArticlePage({super.key});

  @override
  State<ShareArticlePage> createState() => _ShareArticlePageState();
}

class _ShareArticlePageState extends State<ShareArticlePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _linkFocusNode = FocusNode();

  String title = '';
  String link = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.4,
          title: const Text('分享文章'),
          actions: <Widget>[
            InkWell(
              onTap: () {
                shareArticle();
              },
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: const Text('分享'),
              ),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              //c1
              const Text(
                '文章标题',
                style: TextStyle(fontSize: 16),
              ),
              //c2
              GapsUtil.gapH10,
              //c3
              TextField(
                focusNode: _titleFocusNode,
                autofocus: false,
                controller: _titleController,
                decoration: const InputDecoration.collapsed(hintText: '100字以内'),
                maxLines: 3,
              ),
              //c4
              GapsUtil.gapH10,
              //c5
              const Text('文章链接', style: TextStyle(fontSize: 16)),
              //c6
              GapsUtil.gapH10,
              //c7
              TextField(
                  focusNode: _linkFocusNode,
                  autofocus: false,
                  controller: _linkController,
                  decoration: const InputDecoration.collapsed(
                      hintText: '例如: https://www.wanandroid.com'),
                  maxLines: 3),
              //c8
              Expanded(flex: 1, child: Container()),
              //c9
              const Text(
                '1. 只要是任何好文都可以分享哈，并不一定要是原创！投递的文章会进入广场 tab;'
                '\n2. CSDN，掘金，简书等官方博客站点会直接通过，不需要审核;'
                '\n3. 其他个人站点会进入审核阶段，不要投递任何无效链接，测试的请尽快删除，否则可能会对你的账号产生一定影响;'
                '\n4. 目前处于测试阶段，如果你发现500等错误，可以向我提交日志，让我们一起使网站变得更好。'
                '\n5. 由于本站只有我一个人开发与维护，会尽力保证24小时内审核，当然有可能哪天太累，会延期，请保持佛系...',
                style: TextStyle(fontSize: 12),
              ),
              //c10
              GapsUtil.gapH10,
              //c11
              GapsUtil.gapH10,
            ],
          ),
        ),
      ),
    );
  }

  ///这里把异步去掉了 还没
  void shareArticle() {
    title = _titleController.text;
    link = _linkController.text;
    if (title.isEmpty) {
      T.show('请输入文章标题');
      return;
    }
    if (link.isEmpty) {
      T.show('请输入文章链接');
      return;
    }
    showLoading(context);
    // Map params = {'title': title, 'link': link};
    apiService.shareArticle((BaseModel model) {
      dismissLoading(context);
      if (model.errorCode == CON.CODE_SUCCESS) {
        //分享成功后自动回到上一页面,并激发事件
        T.show('分享成功');
        Get.back();
        Application.eventBus?.fire(RefreshShareEvent());
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissLoading(context);
    }, title, link);
  }

  /// 显示Loading
  void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const LoadingDialog(
            outsideDismiss: false,
            loadingText: '正在提交...',
          );
        });
  }

  /// 隐藏Loading
  void dismissLoading(BuildContext context) {
    Get.back();
  }
}
