import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/user_score_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

/// 我的积分页面
class ScorePage extends BaseWidget {
  const ScorePage({super.key});
  @override
  BaseWidgetState<BaseWidget> attachState() => _ScorePageState();
}

class _ScorePageState extends BaseWidgetState<ScorePage> {
  String myScore = Get.arguments ?? '----';

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// 是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;

  /// 页码，从1开始
  int _pageIndex = 1;

  final List<UserScoreSeed> _userScoreSeedList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getUserScoreSeedList();
    });

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreCollectionList();
      }
      if (_scrollController.offset < 200 && _isShowFloatingActionButton) {
        setState(() {
          _isShowFloatingActionButton = false;
        });
      } else if (_scrollController.offset >= 200 &&
          !_isShowFloatingActionButton) {
        setState(() {
          _isShowFloatingActionButton = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        controller: _refreshController,
        onRefresh: getUserScoreSeedList,
        onLoading: getMoreUserScoreSeedList,
        child: ListView.builder(
            itemCount: _userScoreSeedList.length + 1,
            itemBuilder: listViewItemBuilder,
            controller: _scrollController,
            physics: const BouncingScrollPhysics()),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              },
              heroTag: 'user_score',
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: const Text('积分明细'),
      elevation: 0.4,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              String title = '本站积分规则';
              String link = 'https://www.wanandroid.com/blog/show/2653';
              RouteUtil.toWebView(title, link);
            },
            icon: const Icon(Icons.help_outline))
      ],
    );
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getUserScoreSeedList();
    });
  }

  /// 获取用户积分列表
  void getUserScoreSeedList() async {
    _pageIndex = 1;
    apiService.getUserScoreSeedList((UserScoreModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _userScoreSeedList.clear();
            _userScoreSeedList.addAll(model.data!.datas!);
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      showError();
    }, _pageIndex);
  }

  void getMoreUserScoreSeedList() async {
    _pageIndex++;
    apiService.getUserScoreSeedList((UserScoreModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _userScoreSeedList.addAll(model.data!.datas!);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      _refreshController.loadFailed();
    }, _pageIndex);
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    //第一个位置给总积分
    if (index == 0) {
      return Container(
          height: 140,
          alignment: Alignment.center,
          color: Theme.of(context).primaryColor,
          child: Text(
            myScore,
            style: const TextStyle(fontSize: 40, color: Colors.white),
          ));
    }
    UserScoreSeed item = _userScoreSeedList[index - 1];
    return Column(
      children: <Widget>[
        //c1
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: <Widget>[
              //c1r1
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //c1r1c1
                  Text('${item.reason}',
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontSize: 16)),
                  //c1r1c2
                  Text(
                    '${item.desc}',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  )
                ],
              )),
              //c1r2
              Text(
                '+${item.coinCount}',
                style: const TextStyle(fontSize: 16, color: CON.COLOR_TAGS),
              ),
            ],
          ),
        ),
        //c2
        const Divider(height: 1),
      ],
    );
  }
}
