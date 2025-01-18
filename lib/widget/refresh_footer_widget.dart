import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///自定义 SmartRefresher的footer
class RefreshFooterWidget {
  //自定义下滑加载显示 SmartRefresher footer
  static CustomFooter customFooter() {
    return CustomFooter(
      builder: (context, mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text("上拉加载更多~");
          print("上拉加载更多~");
        } else if (mode == LoadStatus.loading) {
          body = const Wrap(
            spacing: 6,
            children: <Widget>[
              CupertinoActivityIndicator(),
              Text("加载中..."),
            ],
          );
          print('加载中...');
        } else if (mode == LoadStatus.failed) {
          body = const Text("加载失败，点击重试~");
          print("加载失败，点击重试~");
        } else {
          body = const Text("我也是有底线的哦~");
          print("我也是有底线的哦~");
        }
        return SizedBox(
          height: 40,
          child: Center(child: body),
        );
      },
    );
  }
}
