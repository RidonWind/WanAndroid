import 'package:get/get.dart';
//开源代码是把所有页面放到index.dart里,
//在index.dart里用export 'login_screen.dart';
//当你在一个Dart文件中使用export 'some_other_file.dart';时，
//你实际上是在告诉Dart编译器：“我想让这个库的使用者能够访问some_other_file.dart中定义的所有公开成员。”
// import 'package:flutter_wanandroid/ui/index.dart';
/*
  import: 只能当前文件中使用,例如A通过"import"引用B,B通过"import"引用C,那么B中可以使用C,在A中是无法使用C的
  export: 只能在引用的文件中使用,例如A通过"import"引用B,B通过"export"引用C,那么在B中是无法使用C的,只能在A中使用B,C
  part: 这种方式需要一些标识,例如B通过"part"引用C,A通过"import"引用B,这个时候需要在B中声明一个库名:"library test;",C中需要标识一下我是哪个库的一部分"part of test;",这样的方式不光是A中可以使用C,B中同样可以使用
其实到这里我们可以将上边的分为两个阵营:
  1.import 专注于自己,我自己需要什么,就import什么
  2.export/part 专注于引用我(import我)的文件,不同点是我是不是需要使用,如果需要就用part,不需要就用export
*/
import 'package:wan_andriod/pages/splash_page.dart';
import 'package:wan_andriod/pages/tabs.dart';
import 'package:wan_andriod/pages/hot_word_page.dart';
import 'package:wan_andriod/pages/share_article_page.dart';
import 'package:wan_andriod/pages/web_view_page.dart';
import 'package:wan_andriod/pages/search_result_page.dart';
import 'package:wan_andriod/pages/rank_page.dart';
import 'package:wan_andriod/pages/login_page.dart';
import 'package:wan_andriod/pages/score_page.dart';
import 'package:wan_andriod/pages/collect_page.dart';
import 'package:wan_andriod/pages/setting_page.dart';
import 'package:wan_andriod/pages/share_page.dart';
import 'package:wan_andriod/pages/todo_page.dart';
import 'package:wan_andriod/pages/knowledge_detail_page.dart';
import 'package:wan_andriod/pages/todo_add_or_edit_page.dart';
import 'package:wan_andriod/pages/qr_code_page.dart';
import 'package:wan_andriod/pages/about_page.dart';

//新增加的GetPage()放在最前面
class PageRoutes {
  static final routes = [
    //关于页面
    GetPage(name: '/about_page', page: () => const AboutPage()),
    //扫码页面
    GetPage(name: '/qr_code_page', page: () => const QrCodePage()),
    //Todo添加或编辑页面,
    //参数 'todoType': todoType,  待办类型：0:只用这一个  1:工作  2:学习  3:生活 'editKey': 0 // 编辑类型：0:新增  1:编辑  2:查看 'seed':TodoSeed
    GetPage(
        name: '/todo_add_or_edit_page', page: () => const TodoAddOrEditPage()),
    //知识树详情页,参数seed.id
    GetPage(
        name: '/knowledge_detail_page',
        page: () => const KnowledgeDetailPage()),
    //todo页面
    GetPage(name: '/todo_page', page: () => const TodoPage()),
    //设置页面
    GetPage(name: '/setting_page', page: () => const SettingPage()),
    //分享页面
    GetPage(name: '/share_page', page: () => const SharePage()),
    //收藏页面
    GetPage(name: '/collect_page', page: () => const CollectPage()),
    //积分页面
    GetPage(name: '/score_page', page: () => const ScorePage()),
    //登录页面
    GetPage(name: '/login_page', page: () => const LoginPage()),
    //等级页面
    GetPage(name: '/rank_page', page: () => const RankPage()),
    //传值String seed.name
    GetPage(name: '/search_result_page', page: () => const SearchResultPage()),
    //传值{'title':String,'url':String}
    GetPage(name: '/web_view_page', page: () => const WebViewPage()),
    GetPage(name: '/share_article_page', page: () => const ShareArticlePage()),
    GetPage(name: '/hot_word_page', page: () => const HotWordPage()),
    GetPage(name: '/tabs', page: () => const Tabs()),
    GetPage(name: '/', page: () => const SplashPage()),
  ];
}
