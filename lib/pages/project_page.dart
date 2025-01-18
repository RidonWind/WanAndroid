import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/project_tree_model.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/pages/project_article_page.dart';
import 'package:wan_andriod/utils/toast_util.dart';

class ProjectPage extends BaseWidget {
  const ProjectPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _ProjectPageState();
  }
}

class _ProjectPageState extends BaseWidgetState<ProjectPage>
    with TickerProviderStateMixin {
  final List<ProjectTreeSeed> _projectTreeSeedList = [];
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
      getProjectTreeSeedList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    _tabController =
        TabController(length: _projectTreeSeedList.length, vsync: this);
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
                isScrollable: true,
                tabs: _projectTreeSeedList.map((ProjectTreeSeed item) {
                  return Tab(text: item.name);
                }).toList()),
          ),
          //c2
          Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: _projectTreeSeedList.map((ProjectTreeSeed item) {
                    return ProjectArticlePage(id: item.id!);
                  }).toList())),
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
      getProjectTreeSeedList();
    });
  }

  void getProjectTreeSeedList() async {
    apiService.getProjectTreeSeedList((ProjectTreeModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.isNotEmpty) {
          showContent();
          setState(() {
            _projectTreeSeedList.clear();
            _projectTreeSeedList.addAll(model.data!);
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
