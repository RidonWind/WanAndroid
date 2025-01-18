import 'package:flutter/material.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/pages/knowledge_tree_page.dart';
import 'package:wan_andriod/pages/navigation_page.dart';

/// 体系页面
class SystemPage extends BaseWidget {
  const SystemPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _SystemPageState();
  }
}

class _SystemPageState extends BaseWidgetState<SystemPage>
    with TickerProviderStateMixin {
  final List<String> _list = ["体系", "导航"];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showContent();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    _tabController = TabController(length: _list.length, vsync: this);
    return Scaffold(
      body: Column(
        children: <Widget>[
          //c1
          Container(
            color: Theme.of(context).primaryColor,
            height: 50,
            child: TabBar(
                indicatorColor: Colors.white,
                labelStyle: const TextStyle(fontSize: 16),
                unselectedLabelStyle: const TextStyle(fontSize: 16),
                controller: _tabController,
                isScrollable: false,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: _list.map((value) {
                  return Tab(
                    text: value,
                  );
                }).toList()),
          ),
          //c2
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: const [KnowledgeTreePage(), NavigationPage()])),
        ],
      ),
    );
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: const Text(''),
    );
  }

  @override
  void onPressedErrorButtonToReloading() {}
}
