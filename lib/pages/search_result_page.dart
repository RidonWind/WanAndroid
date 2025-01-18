import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';
import 'package:wan_andriod/data/model/article_model.dart';
import 'package:wan_andriod/widget/search_article_seed_list_tile.dart';
import 'package:wan_andriod/utils/toast_util.dart';

/// 热词搜索页面
class SearchResultPage extends BaseWidget {
  const SearchResultPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _SearchResultPageState();
  }
}

class _SearchResultPageState extends BaseWidgetState<SearchResultPage> {
  final String _keyword = Get.arguments;
  bool _isShowFloatingActionButton = false;
  int _pageIndex = 0;
  // ignore: prefer_final_fields
  List<ArticleSeed> _searchArticleSeedList = <ArticleSeed>[];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final ScrollController _scrollController = ScrollController();
  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getSearchArticleList();
    });

    _scrollController.addListener(() {
      ///如果滑动到底部,加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //getMoreArticleList()
      }
      if (_scrollController.offset < 200 && _isShowFloatingActionButton) {
        //如果偏移小于200且显示FAB,那就不显示
        setState(() {
          _isShowFloatingActionButton = false;
        });
      } else if (_scrollController.offset >= 200 &&
          !_isShowFloatingActionButton) {
        //如果偏移大于200且不显示FAB,那就显示
        setState(() {
          _isShowFloatingActionButton = true;
        });
      }
    });
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        onRefresh: getSearchArticleList,
        onLoading: getMoreSearchArticleList,
        child: ListView.builder(
          itemBuilder: listViewItemBuilder,
          // physics: const AlwaysScrollableScrollPhysics(),
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: _searchArticleSeedList.length,
        ),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              onPressed: () {
                //回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              },
              heroTag: 'hot',
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }

  Widget listViewItemBuilder(BuildContext context, int index) {
    ArticleSeed seed = _searchArticleSeedList[index];
    return SearchArticleSeedListTile(articleSeed: seed);
  }

  @override
  AppBar attachAppBar() {
    return AppBar(elevation: 0.4, title: Text(_keyword));
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading();
    getSearchArticleList();
  }

  Future getSearchArticleList() async {
    _pageIndex = 0; //这里获取的列表要显示在置顶文章之后,所以要重设索引为0
    apiService.getSearchArticleList((ArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent().then((onValue) {
            // 数据加载完成的逻辑中直接调用,并在调用之后更新 UI 或执行其他操作。
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _searchArticleSeedList.clear();
              _searchArticleSeedList.addAll(model.data?.datas ?? []);
            });
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show('${model.errorMsg}');
      }
    }, (error) => showError(), _pageIndex, _keyword);
  }

  Future getMoreSearchArticleList() async {
    _pageIndex++;
    apiService.getSearchArticleList((ArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _searchArticleSeedList.addAll(model.data?.datas ?? []);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show('${model.errorMsg}');
      }
    }, (error) => _refreshController.loadFailed(), _pageIndex, _keyword);
  }
}
