import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 自定义 FooterView
class RefreshFooter2 extends CustomFooter {
  //源代码里没有这码,在调用时直接RefreshFooter2(),加了requied后成了RefreshFooter2(builder: builder)
  const RefreshFooter2({super.key, required super.builder});

  @override
  double get height => 40;
  @override
  FooterBuilder get builder {
    // super.builder;
    return (context, mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = const Text("上拉加载更多~"); //
      } else if (mode == LoadStatus.loading) {
        body = const Wrap(
          spacing: 6,
          children: <Widget>[
            CupertinoActivityIndicator(),
            Text("加载中..."),
          ],
        );
      } else if (mode == LoadStatus.failed) {
        body = const Text("加载失败，点击重试~");
      } else {
        body = const Text("没有更多数据了~");
      }
      return SizedBox(
        height: 40,
        child: Center(child: body),
      );
    };
  }
}
