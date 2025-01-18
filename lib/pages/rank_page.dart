import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/rank_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

/// 积分排行榜页面
class RankPage extends BaseWidget {
  const RankPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() => _RankPageState();
}

class _RankPageState extends BaseWidgetState<RankPage> {
  /// listview 控制器
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// 页码，从1开始
  int page = 1;
  List<RankSeed> rankSeedList = [];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getRankList();
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
          onRefresh: getRankList,
          onLoading: getMoreRankList,
          child: ListView.builder(
            itemCount: rankSeedList.length,
            itemBuilder: listViewItemBuilder,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
          )),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: const Text("积分排行榜"),
      elevation: 0.4,
    );
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getRankList();
    });
  }

  /// 获取积分排行榜列表
  void getRankList() async {
    page = 1;
    apiService.getRankList((RankModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            rankSeedList.clear();
            rankSeedList.addAll(model.data!.datas!);
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
    }, page);
  }

  /// 获取更多积分排行榜列表
  void getMoreRankList() async {
    page++;
    apiService.getRankList((RankModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            rankSeedList.addAll(model.data!.datas!);
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
    }, page);
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    RankSeed item = rankSeedList[index];

    return Column(
      children: <Widget>[
        //c1
        Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
          child: Row(
            children: <Widget>[
              //c1r1
              Container(
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(
                    (index + 1).toString(),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  )),
              //c1r2
              Expanded(
                child:
                    Text(item.username!, style: const TextStyle(fontSize: 16)),
              ),
              //c1r3
              Text(
                item.coinCount.toString(),
                style: const TextStyle(fontSize: 14, color: Colors.cyan),
              )
            ],
          ),
        ),
        //c2
        const Divider(height: 1)
      ],
    );
  }
}
