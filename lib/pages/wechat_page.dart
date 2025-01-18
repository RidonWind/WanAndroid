import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/wechat_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/wechat_seed_list_view.dart';

/// 公众号页面
class WechatPage extends BaseWidget {
  const WechatPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _WechatPageState();
  }
}

class _WechatPageState extends BaseWidgetState<WechatPage>
    with TickerProviderStateMixin {
  //TabController的vsync:this需要
  List<WechatSeed> _chapterSeedList = [];
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getWechatChapterSeedList();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    _tabController =
        TabController(length: _chapterSeedList.length, vsync: this);
    return Scaffold(
      body: Column(
        children: <Widget>[
          //c1 tabbar
          Container(
            height: 50,
            color: Theme.of(context).primaryColor,
            child: TabBar(
                indicatorColor: Colors.white,
                labelStyle: const TextStyle(fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                controller: _tabController,
                isScrollable: true, //这条是必须的.内容大于宽度不加就不显示
                tabs: _chapterSeedList.map((WechatSeed seed) {
                  return Tab(text: seed.name);
                }).toList()),
          ),
          //c2 显示列表
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: _chapterSeedList.map((WechatSeed seed) {
                    //这里不是返回很多ListTile,而是一个包含很多ListTile的ListView
                    return WechatSeedListView(id: seed.id!);
                  }).toList()))
        ],
      ),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(title: const Text(''));
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((onValue) {
      getWechatChapterSeedList();
    });
  }

  Future getWechatChapterSeedList() async {
    apiService.getWeChatChapterSeedList((WechatModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.isNotEmpty) {
          showContent();
          setState(() {
            _chapterSeedList.clear();
            _chapterSeedList.addAll(model.data!);
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
}
