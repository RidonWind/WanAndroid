import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/todo_model.dart';
import 'package:wan_andriod/event/refresh_todo_event.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/loading_dialog.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';
import 'package:wan_andriod/widget/todo_seed_list_tile.dart';

/// 'TODO 已完成列表页面
class TodoCompletePage extends BaseWidget {
  const TodoCompletePage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() => _TodoCompletePageState();
}

class _TodoCompletePageState extends BaseWidgetState<TodoCompletePage> {
  /// 待办类型：0:只用这一个  1:工作  2:学习  3:生活
  int todoType = 0;
  int page = 1;
  List<TodoSeed> todoSeedList = [];

  /// listview 控制器
  final ScrollController _scrollController = ScrollController();

  /// 是否显示悬浮按钮
  final bool _isShowFloatingActionButton = true;

  /// 重新构建的数据集合
  Map<String, List<TodoSeed>> map = {};
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  @override
  void initState() {
    super.initState();
    setAppBarVisible(false);
    registerRefreshEvent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading().then((onValue) {
      getDoneTodoList();
    });

    // _scrollController.addListener(() {
    //   /// 滑动到底部，加载更多
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     // getMoreDoneTodoList();
    //   }
    //   if (_scrollController.offset < 200 && _isShowFloatingActionButton) {
    //     setState(() {
    //       _isShowFloatingActionButton = false;
    //     });
    //   } else if (_scrollController.offset >= 200 && !_isShowFloatingActionButton) {
    //     setState(() {
    //       _isShowFloatingActionButton = true;
    //     });
    //   }
    // });
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
        enablePullUp: true,
        header: const MaterialClassicHeader(),
        footer: RefreshFooterWidget.customFooter(),
        controller: _refreshController,
        onRefresh: getDoneTodoList,
        onLoading: getMoreDoneTodoList,
        child: ListView.builder(
            itemBuilder: listViewitemBuilder,
            physics: const BouncingScrollPhysics(),
            controller: _scrollController,
            itemCount: todoSeedList.length),
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
  void onPressedErrorButtonToReloading() {
    showLoading();
    getDoneTodoList();
  }

  /// 悬浮按钮
  @override
  floatingActionButtonWidget() {
    return !_isShowFloatingActionButton
        ? null
        : FloatingActionButton(
            heroTag: 'todo_done_list',
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () {
              Get.toNamed('todo_add_or_edit_page',
                  arguments: {'todoType': todoType, 'editKey': 0});
            });
  }

  /// 获取已完成TODO列表数据
  void getDoneTodoList() async {
    page = 1;
    apiService.getDoneTodoList((TodoModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            todoSeedList.clear();
            todoSeedList.addAll(model.data!.datas!);
          });
          rebuildData();
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      showError();
    }, todoType, page);
  }

  void getMoreDoneTodoList() async {
    page++;
    apiService.getDoneTodoList((TodoModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            todoSeedList.addAll(model.data!.datas!);
          });
          rebuildData();
        } else {
          _refreshController.loadNoData();
        }
      } else {
        _refreshController.loadFailed();
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      _refreshController.loadFailed();
    }, todoType, page);
  }

  Widget? listViewitemBuilder(BuildContext context, int index) {
    TodoSeed item = todoSeedList[index];

    //这是日期行的停留
    bool isShowSuspension = false;
    if (map.containsKey(item.dateStr)) {
      if (map[item.dateStr]!.isNotEmpty) {
        //map{'date':[seed]}集合的第1个的id如果等于item.id 那这行可以停留
        if (map[item.dateStr]![0].id == item.id) {
          isShowSuspension = true;
        }
      }
    }
    return TodoSeedListTile(
        isTodo: false,
        item: item,
        todoType: todoType,
        isShowSuspension: isShowSuspension,
        updateTodoCallback: (id) {
          updateTodoState(id, index);
        },
        deleteItemCallback: (id) {
          deleteTodoById(id, index);
        });
  }

  /// 重新构建数据
  void rebuildData() {
    map.clear();
    Set<String> set = {};

    //{'2025-01-10','2025-01-14'} 获取所有日期集合
    for (TodoSeed seed in todoSeedList) {
      set.add(seed.dateStr!);
    }

    //{'2025-01-10':[],'2025-01-14':[]} 给日期集合加空数组
    for (String s in set) {
      List<TodoSeed> list = [];
      //如果map没s就加list,如果有了就不操作
      map.putIfAbsent(s, () => list);
    }

    //{'2025-01-10':[seed1,seed2,seed3],'2025-01-14':[seed4,seed5,seed6]}
    //给日期集合的数组加Seed
    for (TodoSeed seed in todoSeedList) {
      map[seed.dateStr]!.add(seed);
    }
  }

  /// 注册刷新TODO事件
  void registerRefreshEvent() {
    Application.eventBus?.on<RefreshTodoEvent>().listen((event) {
      todoType = event.todoType;
      todoSeedList.clear();
      showLoading();
      getDoneTodoList();
    });
  }

  /// 仅更新完成状态Todo
  void updateTodoState(id, int index) async {
    // status: 0或1，传1代表未完成到已完成，反之则反之。
    Map<String, int> params = {'status': 0};
    showTodoLoading();
    apiService.updateTodoState((BaseModel model) {
      dismissTodoLoading();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('更新成功');
        setState(() {
          todoSeedList.removeAt(index);
        });
        rebuildData();
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissTodoLoading();
    }, id, params);
  }

  /// 根据ID删除TODO
  void deleteTodoById(id, int index) async {
    showLoading();
    apiService.deleteTodoById((BaseModel model) {
      // dismissTodoLoading();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('删除成功');
        setState(() {
          todoSeedList.removeAt(index);
        });
        rebuildData();
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissTodoLoading();
    }, id);
  }

  /// 显示Loading
  void showTodoLoading() {
    showDialog(
        context: context,
        builder: (_) {
          return const LoadingDialog(
              outsideDismiss: false, loadingText: 'loading...');
        });
  }

  /// 隐藏Loading
  void dismissTodoLoading() {
    Get.back();
  }
}
