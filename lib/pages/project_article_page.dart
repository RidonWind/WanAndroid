import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/project_article_model.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/project_article_list_tile.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

class ProjectArticlePage extends StatefulWidget {
  final int id;
  const ProjectArticlePage({super.key, required this.id});

  @override
  State<ProjectArticlePage> createState() => _ProjectArticlePageState();
}

class _ProjectArticlePageState extends State<ProjectArticlePage>
    with AutomaticKeepAliveClientMixin {
  final List<ProjectArticleSeed> _projectArticleSeedList = [];

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  /// 是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;
  int _pageIndex = 1;

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getProjectArticleSeedList();

    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreProjectArticleList();
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
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        controller: _refreshController,
        onRefresh: getProjectArticleSeedList,
        onLoading: getMoreProjectArticleSeedList,
        child: ListView.builder(
            itemBuilder: listViewItemBuilder,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: _projectArticleSeedList.length),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'project',
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                //回到顶部时要执行的动画
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              }),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void getProjectArticleSeedList() async {
    _pageIndex = 1;
    int id = widget.id;
    apiService.getProjectArticleSeedList((ProjectArticleListModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        _refreshController.refreshCompleted(resetFooterState: true);
        setState(() {
          _projectArticleSeedList.clear();
          _projectArticleSeedList.addAll(model.data!.datas!);
        });
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      print(error.response);
    }, id, _pageIndex);
  }

  void getMoreProjectArticleSeedList() async {
    _pageIndex++;
    int id = widget.id;
    apiService.getProjectArticleSeedList((ProjectArticleListModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _projectArticleSeedList.addAll(model.data!.datas!);
          });
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
      }
    }, (DioException error) {
      _refreshController.loadFailed();
    }, id, _pageIndex);
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    ProjectArticleSeed item = _projectArticleSeedList[index];
    return ProjectArticleListTile(item: item);
  }
}
