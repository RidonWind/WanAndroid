import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/knowledge_tree_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

/// 知识体系页面
class KnowledgeTreePage extends BaseWidget {
  const KnowledgeTreePage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _KnowledgeTreePageState();
  }
}

class _KnowledgeTreePageState extends BaseWidgetState<KnowledgeTreePage> {
  /// 是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;
  List<KnowledgeTreeSeed> _knowledgeTreeSeedList = [];

  ///ListView控制器
  ScrollController _scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getKnowledgeTreeSeedList();
    });

    ///滑动下去显示向上箭头回到顶部
    _scrollController.addListener(() {
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
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: false, //默认就是false
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(), //上拉不生效,这段没用
        onRefresh: getKnowledgeTreeSeedList,
        controller: _refreshController,
        child: ListView.builder(
          itemBuilder: listViewItemBuilder,
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: _knowledgeTreeSeedList.length,
        ),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'knowledge',
              child: const Icon(Icons.arrow_upward),
              onPressed: () {
                ///回到顶部要执行的动画
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              }),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: const Text(""));
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getKnowledgeTreeSeedList();
    });
  }

  void getKnowledgeTreeSeedList() async {
    apiService.getKnowledgeTreeSeedList((KnowledgeTreeModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.isNotEmpty) {
          showContent().then((onValue) {
            _refreshController.refreshCompleted();
            setState(() {
              _knowledgeTreeSeedList.clear();
              _knowledgeTreeSeedList.addAll(model.data!);
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
      print(error.response);
      showError();
    });
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    KnowledgeTreeSeed seed = _knowledgeTreeSeedList[index];
    return InkWell(
      onTap: () {
        ///点击进入知识树详情页,参数seed.id
        Get.toNamed('/knowledge_detail_page', arguments: seed);
      },
      child: Column(
        children: [
          //c1
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //c1r1
              Expanded(
                  child: Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //c1r1c1
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${seed.name}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    //c1r1c2
                    Container(
                      alignment: Alignment.centerLeft,
                      child: itemChildrenView(seed.children),
                    )
                  ],
                ),
              )),
              //c1r2
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
          //c2
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget? itemChildrenView(List<KnowledgeTreeChildSeed>? children) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    for (var item in children!) {
      tiles.add(Text(
        item.name!,
        style: const TextStyle(color: CON.COLOR_AUTHOR_DATA_CHAPTER),
      ));
    }
    return Wrap(
        spacing: 10,
        runSpacing: 6,
        alignment: WrapAlignment.start,
        children: tiles);
  }
}
