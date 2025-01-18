import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/navigation_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/color_util.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

/// 导航页面
class NavigationPage extends BaseWidget {
  const NavigationPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _NavigationPageState();
  }
}

class _NavigationPageState extends BaseWidgetState<NavigationPage> {
  final List<NavigationSeed> _navigationSeedList = [];

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  /// 是否显示悬浮按钮
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
      getNavigationSeedList();
    });
    _scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {}
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
        enablePullUp: false,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        controller: _refreshController,
        onRefresh: getNavigationSeedList,
        child: ListView.builder(
            itemBuilder: listViewItemBuilder,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: _navigationSeedList.length),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'navigation',
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                // 回到顶部时要执行的动画
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
      getNavigationSeedList();
    });
  }

  void getNavigationSeedList() async {
    apiService.getNavigationSeedList((NavigationModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.isNotEmpty) {
          showContent().then((onValue) {
            _refreshController.refreshCompleted();

            setState(() {
              _navigationSeedList.clear();
              _navigationSeedList.addAll(model.data!);
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
    });
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: <Widget>[
          //c1
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              _navigationSeedList[index].name ?? '',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          //c2
          Container(
            alignment: Alignment.centerLeft,
            child: itemChildView(_navigationSeedList[index].articles!),
          ),
          //c3
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget? itemChildView(List<NavigationArticleSeed> articles) {
    List<Widget> tiles = [];
    Widget content;
    for (var item in articles) {
      tiles.add(InkWell(
        onTap: () {
          RouteUtil.toWebView(item.title ?? '', item.link ?? '');
        },
        child: Chip(
          label: Text(
            item.title ?? '',
            style: TextStyle(
                fontSize: 12,
                color: ColorUtil.randomColor(),
                fontStyle: FontStyle.italic),
          ),
          labelPadding: const EdgeInsets.only(left: 3, right: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
      ));
    }
    content = Wrap(spacing: 2, alignment: WrapAlignment.start, children: tiles);
    return content;
  }
}
