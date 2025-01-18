import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/share_article_model.dart';
import 'package:wan_andriod/event/refresh_share_event.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/loading_dialog.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';
import 'package:wan_andriod/widget/share_article_seed_list_tile.dart';

/// 我的分享
class SharePage extends BaseWidget {
  const SharePage({super.key});
  @override
  BaseWidgetState<BaseWidget> attachState() => _SharePageState();
}

class _SharePageState extends BaseWidgetState<SharePage> {
  // with SingleTickerProviderStateMixin {
  List<ShareArticleSeed> _shareSeedList = [];

  /// 是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;

  /// 页码，从1开始
  int _pageIndex = 1;

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// 滑动删除控制器
  // late final SlidableController _slidableController = SlidableController(this);
  @override
  void initState() {
    super.initState();
    //注册刷新事件,在点action + 后进入分享页面,分享成功后会直接返回,激发刷新列表事件
    registerRefreshEvent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getShareSeedList();
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
        onRefresh: getShareSeedList,
        onLoading: getMoreShareSeedList,
        child: ListView.builder(
            itemCount: _shareSeedList.length,
            itemBuilder: listViewItemBuilder,
            controller: _scrollController,
            physics: const BouncingScrollPhysics()),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'share_page',
              onPressed: () {
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              },
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: const Text('我的分享'),
      elevation: 0.4,
      actions: <Widget>[
        IconButton(
            onPressed: () {
              Get.toNamed('/share_article_page');
            },
            icon: const Icon(Icons.add))
      ],
    );
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getShareSeedList();
    });
  }

  /// 注册刷新列表事件
  void registerRefreshEvent() {
    Application.eventBus?.on<RefreshShareEvent>().listen((event) {
      showLoading().then((onValue) {
        getShareSeedList();
      });
    });
  }

  /// 获取分享文章列表
  void getShareSeedList() async {
    _pageIndex = 1;
    apiService.getShareArticleSeedList((ShareArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        List<ShareArticleSeed>? list = model.data?.shareArticles?.datas;
        if (list!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _shareSeedList.clear();
            _shareSeedList.addAll(list);
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

  /// 获取更多文章列表
  void getMoreShareSeedList() async {
    _pageIndex++;
    apiService.getShareArticleSeedList((ShareArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        List<ShareArticleSeed>? list = model.data?.shareArticles?.datas;
        if (list!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _shareSeedList.addAll(list);
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
    ShareArticleSeed item = _shareSeedList[index];
    return ShareArticleSeedListTile(
        item: item,
        deleteItemCallback: (int id) {
          deleteShareArticle(id, index);
        });
  }

  /// 删除已分享的文章
  void deleteShareArticle(int id, int index) async {
    showLoadingDialog();
    apiService.deleteShareArticle((BaseModel model) {
      dismissLoadingDialog();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('已删除分享的文章');
        setState(() {
          _shareSeedList.removeAt(index);
        });
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissLoadingDialog();
    }, id);
  }

  void showLoadingDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const LoadingDialog(
              outsideDismiss: false, loadingText: 'loading...');
        });
  }

  void dismissLoadingDialog() {
    Get.back();
  }
}
