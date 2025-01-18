import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/collect_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/collect_seed_list_tile.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

/// 收藏页面
class CollectPage extends BaseWidget {
  const CollectPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _CollectPageState();
  }
}

class _CollectPageState extends BaseWidgetState<CollectPage> {
  final List<CollectArticleSeed> _collectArticleSeedList = [];

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// 页码，从0开始
  int _pageIndex = 0;

  /// 是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getCollectSeedList();
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
    _refreshController.dispose();
    _scrollController.dispose();
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
        onRefresh: getCollectSeedList,
        onLoading: getMoreCollectSeedList,
        child: ListView.builder(
            itemCount: _collectArticleSeedList.length,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemBuilder: listViewItemBuilder),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'collect',
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
  AppBar attachAppBar() {
    return AppBar(
      title: const Text('我的收藏'),
      elevation: 0.4,
    );
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getCollectSeedList();
    });
  }

  void getCollectSeedList() async {
    _pageIndex = 0;
    apiService.getCollectSeedList((CollectModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _collectArticleSeedList.clear();
            _collectArticleSeedList.addAll(model.data!.datas!);
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

  void getMoreCollectSeedList() async {
    _pageIndex++;
    apiService.getCollectSeedList((CollectModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _collectArticleSeedList.addAll(model.data!.datas!);
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
    CollectArticleSeed item = _collectArticleSeedList[index];
    return CollectSeedListTile(
      item: item,
      isCancelCollectCallback: (isCancelCollect) {
        //取消收藏时移除
        if (isCancelCollect) {
          setState(() {
            _collectArticleSeedList.removeAt(index);
          });
        }
      },
    );
  }
}
