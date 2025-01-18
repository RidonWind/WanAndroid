import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/wechat_article_model.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';
import 'package:wan_andriod/widget/wechat_article_seed_list_tile.dart';

class WechatSeedListView extends StatefulWidget {
  final int id;
  const WechatSeedListView({super.key, required this.id});

  @override
  State<WechatSeedListView> createState() => _WechatSeedListViewState();
}

class _WechatSeedListViewState extends State<WechatSeedListView>
    with AutomaticKeepAliveClientMixin {
  int _page = 1;
  List<WechatArticleSeed> _wechatArticleSeedList = [];
  bool _isShowFloatingActionButton = false;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); //加了with AutomaticKeepAliveClientMixin后系统要求call super
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        controller: _refreshController,
        onRefresh: getWechatArticleSeedList,
        onLoading: getMoreWechatArticleSeedList,
        child: ListView.builder(
          itemBuilder: listViewItemBuilder,
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: _wechatArticleSeedList.length,
        ),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'wechat',
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                /// 回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getWechatArticleSeedList() async {
    _page = 1;
    int id = widget.id;
    apiService.getWechatArticleSeedList((WechatArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        _refreshController.refreshCompleted(resetFooterState: true);
        setState(() {
          _wechatArticleSeedList.clear();
          _wechatArticleSeedList.addAll(model.data!.datas!);
        });
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {}, id, _page);
  }

  void getMoreWechatArticleSeedList() async {
    _page++;
    int id = widget.id;
    apiService.getWechatArticleSeedList((WechatArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _wechatArticleSeedList.addAll(model.data!.datas!);
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
    }, id, _page);
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    WechatArticleSeed seed = _wechatArticleSeedList[index];
    return WechatArticleSeedListTile(seed: seed);
  }
}
