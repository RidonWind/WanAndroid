import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/article_model.dart';
import 'package:wan_andriod/event/refresh_share_event.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/article_seed_list_tile.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

class SquarePage extends BaseWidget {
  const SquarePage({super.key});
  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _SquarePageState();
  }
}

class _SquarePageState extends BaseWidgetState<SquarePage> {
  ///页码,从0开始
  int _pageIndex = 0;

  ///首页文章列表数据
  List<ArticleSeed> _articleSeedList = [];

  /// 是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;

  /// 无限加载 控制器
  final RefreshController _refreshController = RefreshController();

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //不显示BaseWidget的AppBar因为Tabs已经显示tabbar了.不然就有两个appbar
    setAppBarVisible(false);

    // 注册刷新列表事件,在action点+按钮,提交文章后回到广场页面自动刷新列表
    registerRefreshEvent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    showLoading().then((onValue) {
      getSquareList();
    });

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreArticleList();
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
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        // footer: RefreshFooter2(builder: builder),
        controller: _refreshController,
        onRefresh: getSquareList,
        onLoading: getMoreSquareList,
        child: ListView.builder(
          itemBuilder: listViewItemBuilder,
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: _articleSeedList.length,
        ),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'square',
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                ///回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              }),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: const Text(''));
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getSquareList();
    });
  }

  /// 获取文章列表数据
  Future getSquareList() async {
    _pageIndex = 0;
    apiService.getSquareList((ArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent().then((onValue) {
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _articleSeedList.clear();
              _articleSeedList.addAll(model.data!.datas!);
            });
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

  /// 获取更多文章列表数据
  Future getMoreSquareList() async {
    _pageIndex++;
    apiService.getSquareList((ArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _articleSeedList.addAll(model.data!.datas!);
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

  /// ListView 中每一行的视图
  Widget? listViewItemBuilder(BuildContext context, int index) {
    ArticleSeed seed = _articleSeedList[index];
    return ArticleSeedListTile(articleSeed: seed);
  }

  /// 注册刷新列表事件
  void registerRefreshEvent() {
    //分享成功后会激发这个事件
    Application.eventBus?.on<RefreshShareEvent>().listen((onData) {
      showLoading().then((onValue) {
        getSquareList();
        _scrollController.animateTo(0,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      });
    });
  }
}
