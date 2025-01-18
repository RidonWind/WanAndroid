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

/// TODO 待办列表页面
class TodoListPage extends BaseWidget {
  const TodoListPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _TodoListPageState();
  }
}

class _TodoListPageState extends BaseWidgetState<TodoListPage> {
  /// 待办类型：0:只用这一个  1:工作  2:学习  3:生活
  int todoType = 0;
  int _page = 1;
  final List<TodoSeed> _todoSeedList = [];

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
      getNoTodoList();
    });

    /*_scrollController.addListener(() {
      /// 滑动到底部，加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // getMoreNoTodoList();
      }
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
    });*/
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
        onRefresh: getNoTodoList,
        onLoading: getMoreNoTodoList,
        child: ListView.builder(
          itemBuilder: listViewItemBuilder,
          physics: const BouncingScrollPhysics(),
          controller: _scrollController,
          itemCount: _todoSeedList.length,
        ),
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
    showLoading().then((onValue) {
      getNoTodoList();
    });
  }

  ///悬浮按钮增加数据应该一直显示
  @override
  floatingActionButtonWidget() {
    return !_isShowFloatingActionButton
        ? null
        : FloatingActionButton(
            heroTag: "todo_list",
            child: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Get.toNamed('/todo_add_or_edit_page', arguments: {
                'todoType': todoType, // 待办类型：0:只用这一个  1:工作  2:学习  3:生活
                'editKey': 0 // 编辑类型：0:新增  1:编辑  2:查看
              });
            },
          );
  }

  ///注册刷新事件,在action选择后激发
  void registerRefreshEvent() {
    Application.eventBus
        ?.on<RefreshTodoEvent>()
        .listen((RefreshTodoEvent event) {
      todoType = event.todoType;
      _todoSeedList.clear();
      showLoading().then((onValue) {
        getNoTodoList();
      });
    });
  }

  /// 获取待办TODO列表数据
  void getNoTodoList() async {
    _page = 1;
    apiService.getNoTodoList((TodoModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent();
          _refreshController.refreshCompleted(resetFooterState: true);
          setState(() {
            _todoSeedList.clear();
            _todoSeedList.addAll(model.data!.datas!);
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
    }, todoType, _page);
  }

  /// 重新构建数据
  void rebuildData() {
    map.clear();
    Set<String> set = {};
    for (TodoSeed seed in _todoSeedList) {
      set.add(seed.dateStr ?? '');
    }

    for (String s in set) {
      List<TodoSeed> list = [];
      map.putIfAbsent(s, () => list);
    }

    for (TodoSeed seed in _todoSeedList) {
      map[seed.dateStr]?.add(seed);
    }
  }

  /// 获取更多待办TODO列表数据
  void getMoreNoTodoList() async {
    _page++;
    apiService.getNoTodoList((TodoModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete();
          setState(() {
            _todoSeedList.addAll(model.data!.datas!);
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
    }, todoType, _page);
  }

  Widget? listViewItemBuilder(BuildContext context, int index) {
    TodoSeed item = _todoSeedList[index];
    bool isShowSuspension = false;
    if (map.containsKey(item.dateStr)) {
      if (map[item.dateStr]!.isNotEmpty) {
        if (map[item.dateStr]![0].id == item.id) {
          isShowSuspension = true;
        }
      }
    }
    return TodoSeedListTile(
        item: item,
        isTodo: true,
        isShowSuspension: isShowSuspension,
        todoType: todoType,
        updateTodoCallback: (int id) {
          updateTodoState(id, index);
        },
        deleteItemCallback: (int id) {
          deleteTodoById(id, index);
        });
  }

  /// 仅更新完成状态Todo
  void updateTodoState(int id, int index) {
    // status: 0或1，传1代表未完成到已完成，反之则反之。
    var params = {'status': 1};
    showTodoLoading();
    apiService.updateTodoState((BaseModel model) {
      dismissTodoLoading();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('更新成功');
        setState(() {
          _todoSeedList.removeAt(index);
          rebuildData();
        });
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissTodoLoading();
    }, id, params);
  }

  /// 根据ID删除TODO
  void deleteTodoById(int id, int index) {
    showTodoLoading();
    apiService.deleteTodoById((BaseModel model) {
      dismissTodoLoading();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('删除成功');

        setState(() {
          _todoSeedList.removeAt(index);
        });
        rebuildData();
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissTodoLoading();
    }, id);
  }

  void showTodoLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const LoadingDialog(
            outsideDismiss: false,
            loadingText: "loading...",
          );
        });
  }

  void dismissTodoLoading() {
    Get.back();
  }
}
