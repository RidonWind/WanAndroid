import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/pages/drawer_page.dart';
import 'package:wan_andriod/pages/home_page.dart';
import 'package:wan_andriod/pages/project_page.dart';
import 'package:wan_andriod/pages/square_page.dart';
import 'package:wan_andriod/pages/system_page.dart';
import 'package:wan_andriod/pages/wechat_page.dart';
import 'package:wan_andriod/utils/utils.dart';

///首页
class Tabs extends StatefulWidget {
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

// 在Flutter开发中，AutomaticKeepAliveClientMixin 是一个非常有用的混入（Mixin），
// 它主要用于在需要保持页面状态的场景下使用，比如当你有一个需要频繁切换但又不希望每次切换都重新构建的页面时。
// AutomaticKeepAliveClientMixin 通常与 KeepAlive 组件一起使用。
//KeepAlive 组件是一个可以在其子组件不需要频繁重建时保持其状态（包括滚动位置、输入框内容等）的容器。
class _TabsState extends State<Tabs> with AutomaticKeepAliveClientMixin {
  // final用于声明一个只能赋值一次的变量。
  // late允许你推迟变量的初始化。
  // late final结合了两者的特性，允许你推迟初始化一个只能赋值一次的变量。

  //PageView的controller
  late final PageController pageController;

  ///当前选中的索引
  late int selectedIndex;

  //tabs的名字
  late final List<String> bottomBarTitles;
  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
    pageController = PageController();
    bottomBarTitles = ['首页', '广场', '公众号', '体系', '项目'];
  }

  /// 五个Tabs的内容
  List<Widget> tabPages = <Widget>[
    const HomePage(),
    const SquarePage(),
    const WechatPage(),
    const SystemPage(),
    const ProjectPage()
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //条件拦截返回操作‌：你可以在 onPop 回调中根据条件来决定是否拦截返回操作。例如，如果你的应用中有表单，你可能希望在用户未保存数据时阻止返回。
    //‌嵌套使用‌：在复杂的应用中，你可能需要在不同的层级上处理返回操作。PopScope 支持嵌套使用，这样你就可以在不同的层级上拦截返回操作。
    //与 WillPopScope 结合使用‌：WillPopScope 提供了一种方式来询问用户是否真的想要退出当前页面。你可以将 PopScope 和 WillPopScope 结合起来使用，以提供更丰富的用户体验。不过需要注意的是，从 Flutter 的某个版本开始（具体版本可能因时间而有所变化），WillPopScope 已经被标记为已废弃，并建议使用 PopScope 来代替。
    return PopScope(
        canPop: false, // 使用canPop提前禁用pop
        onPopInvokedWithResult: (didPop, result) async {
          // canPop被设置为false时。didPop参数表示返回导航是否成功。
          // `didPop`参数会告诉你路由是否成功地pop出
          print('onPopInvokedWithResult:didPop:$didPop result:$result');
          if (didPop) return;
          Get.defaultDialog(
            title: '提示',
            middleText: '确定退出应用吗？',
            textConfirm: '退出',
            textCancel: '再看一会',
            onConfirm: () {
              Get.offAllNamed('/');
            },
            onCancel: () {
              print('onCancel');
            },
          );
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(bottomBarTitles[selectedIndex]),
            //TabBar 是一个强大的组件，它允许开发者在应用中创建标签页导航。
            bottom: null, //这是没有用到标签页导航

            /*
              在Flutter开发中，AppBar 的 elevation 属性用于控制应用栏下方阴影的高度。这个属性接受一个 double 类型的值，表示阴影的高度，单位通常是逻辑像素（logical pixels）。
              elevation 属性对于创建具有立体感和视觉层次的UI界面非常有用。通过调整 elevation 的值，你可以改变应用栏阴影的明显程度，从而影响整个界面的视觉效果。
              默认情况下，AppBar 的 elevation 值可能会根据平台（iOS或Android）的不同而有所差异。在iOS上，由于设计风格的差异，应用栏可能不会显示明显的阴影。而在Android上，则通常会显示一个较为明显的阴影效果。
              如果你想要自定义应用栏的阴影效果，可以直接设置 elevation 属性
            */
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    if (selectedIndex == 1) {
                      //跳分享页面
                      Get.toNamed('/share_article_page');
                    } else {
                      //跳搜索页面
                      Get.toNamed('/hot_word_page');
                    }
                  },
                  icon: selectedIndex == 1
                      ? const Icon(Icons.add)
                      : const Icon(Icons.search))
            ],
          ),
          drawer: const DrawerPage(), //侧滑页面
          // body: tabPages[selectedIndex], //一会改成PageView
          body: PageView.builder(
            itemBuilder: (context, index) => tabPages[index],
            itemCount: tabPages.length,
            controller: pageController,
            /*在Flutter开发中，PageView 的 physics 属性用于确定页面滚动时的物理特性。这个属性允许你自定义滚动行为，比如滚动到边缘时的动画效果。
            PageView 的 physics 属性通常接受一个 ScrollPhysics 类型的值。Flutter 提供了几种预定义的 ScrollPhysics，比如：
            BouncingScrollPhysics：当滚动到边缘时，会有一个弹跳的效果，这是 iOS 的默认行为。
            ClampingScrollPhysics：当滚动到边缘时，会停止滚动并保持在边缘位置，不会超出边界，这是 Android 的默认行为。
            NeverScrollableScrollPhysics：设置后，页面将不可滚动。
          */
            // physics:const NeverScrollableScrollPhysics(), //开源代码里设置这个后PageView就不能手势滑动了
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                print('PageView onPageChanged index:$index');
                selectedIndex = index;
              });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              //选中文字颜色
              fixedColor: Theme.of(context).primaryColor,
              //如果底部有4个或者4个以上的菜单的时候就需要配置这个参数
              type: BottomNavigationBarType.fixed,
              //当前索引 第几个菜单选中
              currentIndex: selectedIndex,
              // 选择的处理事件 选中变化回调函数
              onTap: (index) {
                //更新状态
                // setState(() {
                //   print('bottomNavigationBar onTap index:$index');
                //   selectedIndex = index;
                // });
                pageController.jumpToPage(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: buildIcon(0, 'ic_home'),
                    label: bottomBarTitles[0]), //Icon(Icons.home),
                BottomNavigationBarItem(
                    icon: buildIcon(1, 'ic_square_line'),
                    label: bottomBarTitles[1]), //Icon(Icons.assignment),
                BottomNavigationBarItem(
                    icon: buildIcon(2, 'ic_wechat'),
                    label: bottomBarTitles[2]), //Icon(Icons.chat),
                BottomNavigationBarItem(
                    icon: buildIcon(3, 'ic_system'),
                    label: bottomBarTitles[3]), //Icon(Icons.assignment),
                BottomNavigationBarItem(
                    icon: buildIcon(4, 'ic_project'),
                    label: bottomBarTitles[4]), //Icon(Icons.book),
              ]),
        ));
  }

  ///tabs 图标
  Widget buildIcon(int index, String iconName) {
    return Image.asset(Utils.getImagePath(iconName),
        width: 22,
        height: 22,
        //选中显示主题色,没选中灰色
        color: index == selectedIndex
            ? Theme.of(context).primaryColor
            : Colors.grey.shade600);
  }

  //当 wantKeepAlive 返回 true 时，KeepAlive 组件会保持该组件的状态；
  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
    print('pageController.dispose();');
  }
}
