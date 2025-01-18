import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/knowledge_detail_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/knowledge_detail_list_tile.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

class KnowledgeArticlePage extends BaseWidget {
  final int id;
  const KnowledgeArticlePage({super.key, required this.id});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _KnowledgeArticlePageState();
  }
}

class _KnowledgeArticlePageState extends BaseWidgetState<KnowledgeArticlePage> {
  final List<KnowledgeDetailChild> _knowledgeDetailChildrenList = [];
  //listview的控制器
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int _pageIndex = 0;

  ///是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;
  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getKnowledgeDetailSeedList();
    });

    ///显示FAB点击回到顶部
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreKnowledgeDetailList();
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
  Widget attachContentBuildWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        controller: _refreshController,
        onRefresh: getKnowledgeDetailSeedList,
        onLoading: getMoreKnowledgeDetailSeedList,
        child: ListView.builder(
            itemBuilder: listViewItemBuilder,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: _knowledgeDetailChildrenList.length),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'knowledge_detail',
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
      title: const Text(''),
    );
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getKnowledgeDetailSeedList();
    });
  }

  void getKnowledgeDetailSeedList() async {
    _pageIndex = 0;
    int id = widget.id;
    apiService.getKnowledgeDetailList((KnowledgeDetailModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _knowledgeDetailChildrenList.clear();
            _knowledgeDetailChildrenList.addAll(model.data!.datas!);
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
    }, _pageIndex, id);
  }

  void getMoreKnowledgeDetailSeedList() async {
    _pageIndex++;
    int id = widget.id;
    apiService.getKnowledgeDetailList((KnowledgeDetailModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _knowledgeDetailChildrenList.addAll(model.data!.datas!);
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
    }, _pageIndex, id);
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    KnowledgeDetailChild item = _knowledgeDetailChildrenList[index];
    return KnowledgeDetailListTile(item: item);
  }
}
