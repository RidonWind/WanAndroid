import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/data/model/knowledge_tree_model.dart';
import 'package:wan_andriod/pages/knowledge_article_page.dart';

/// 知识体系详情页面
class KnowledgeDetailPage extends StatefulWidget {
  const KnowledgeDetailPage({super.key});

  @override
  State<KnowledgeDetailPage> createState() => _KnowledgeDetailPageState();
}

class _KnowledgeDetailPageState extends State<KnowledgeDetailPage>
    with TickerProviderStateMixin {
  late KnowledgeTreeSeed _seed;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _seed = Get.arguments;
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = TabController(length: _seed.children!.length, vsync: this);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: Text('${_seed.name}'),
        bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 16),
            unselectedLabelStyle: const TextStyle(fontSize: 16),
            controller: _tabController,
            isScrollable: true,
            tabs: _seed.children!.map((KnowledgeTreeChildSeed item) {
              return Tab(
                text: item.name,
              );
            }).toList()),
      ),
      body: TabBarView(
          controller: _tabController,
          children: _seed.children!.map((item) {
            return KnowledgeArticlePage(id: item.id!);
          }).toList()),
    );
  }
}
