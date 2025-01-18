import 'package:flutter/material.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/event/refresh_todo_event.dart';
import 'package:wan_andriod/pages/todo_complete_page.dart';
import 'package:wan_andriod/pages/todo_list_page.dart';
import 'package:wan_andriod/utils/theme_util.dart';

/// TODO 页面
class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage>
    with AutomaticKeepAliveClientMixin {
  int _selectedIndex = 0; //当前选中的索引
  final List bottomBarTitles = ['代办', '已完成'];
  int _todoSelectedIndex = 0;
  final List todoTypeList = ["只用这一个", "工作", "学习", "生活"];
  final PageController _pageController = PageController();

  List<Widget> pages = <Widget>[const TodoListPage(), const TodoCompletePage()];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(todoTypeList[_todoSelectedIndex]),
        elevation: 0.4,
        bottom: null,
        actions: <Widget>[
          //隐藏的弹出菜单
          PopupMenuButton<int>(
            icon: const Icon(Icons.swap_horiz),
            itemBuilder: (context) {
              return <PopupMenuItem<int>>[
                selectView(todoTypeList[0], 0),
                selectView(todoTypeList[1], 1),
                selectView(todoTypeList[2], 2),
                selectView(todoTypeList[3], 3),
              ];
            },
            //value就是PopupMenuItem的value值,选择第几个PopupMenuItem,返回对应的value
            onSelected: (int index) {
              setState(() {
                _todoSelectedIndex = index;
              });
              //点选项后通知刷新Todo页面
              Application.eventBus?.fire(RefreshTodoEvent(index));
            },
          )
        ],
      ),
      body: PageView.builder(
          itemBuilder: (context, index) {
            return pages[index];
          },
          itemCount: pages.length,
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          }),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.description), label: bottomBarTitles[0]),
          BottomNavigationBarItem(
              icon: const Icon(Icons.check_circle), label: bottomBarTitles[1])
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
      ),
    );
  }

  PopupMenuItem<int> selectView(String text, int index) {
    return PopupMenuItem<int>(
        value: index,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  color: index == _todoSelectedIndex
                      ? Colors.cyan
                      : ThemeUtils.dark
                          ? Colors.white
                          : Colors.black),
            )
          ],
        ));
  }
}
