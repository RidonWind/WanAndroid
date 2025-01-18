import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/todo_model.dart';
import 'package:date_format/date_format.dart';
import 'package:wan_andriod/event/refresh_todo_event.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/loading_dialog.dart';

class TodoAddOrEditPage extends StatefulWidget {
  const TodoAddOrEditPage({super.key});

  @override
  State<TodoAddOrEditPage> createState() => _TodoAddOrEditPageState();
}

class _TodoAddOrEditPageState extends State<TodoAddOrEditPage> {
  // 'todoType': todoType, // 待办类型：0:只用这一个  1:工作  2:学习  3:生活
  // 'editKey': 0 // 编辑类型：0:新增  1:编辑  2:查看
  int todoType = Get.arguments['todoType'];
  int editKey = Get.arguments['editKey'];
  TodoSeed? todoSeed = Get.arguments['seed'];

  bool isEnabled = true; // 是否可编辑
  String toolbarTitle = ''; //toolbar标题
  String title = ''; //标题
  String content = ''; //详情
  int priorityValue = 0; //优先级 0:一般   1:重要
  String selectedDate = ''; //选择日期

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    toolbarTitle = editKey == 0 ? '新增' : (editKey == 1 ? '编辑' : '查看');
    isEnabled = editKey == 0 || editKey == 1; //新增,编辑下可编辑
    selectedDate = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);

    // 判断 seed 是否有值
    if (todoSeed != null) {
      _titleController.text = todoSeed!.title ?? '';
      _contentController.text = todoSeed!.content ?? '';
      priorityValue = todoSeed!.priority ?? 0;
      selectedDate = todoSeed!.dateStr ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Text('todoType:$todoType ---0:只用这一个  1:工作  2:学习  3:生活\neditKey:$editKey ---0:新增  1:编辑  2:查看\ntodoSeed:$todoSeed\ndate:$selectedDate'),
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0.4,
          title: Text(toolbarTitle),
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Column(
            children: <Widget>[
              //c1
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Row(
                  children: <Widget>[
                    //c1r1
                    const Text(
                      '标题: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    //c1r2
                    Expanded(
                        child: TextField(
                            focusNode: _titleFocusNode,
                            autofocus: false,
                            enabled: isEnabled,
                            controller: _titleController,
                            decoration: const InputDecoration.collapsed(
                                hintText: '请输入标题'),
                            maxLines: 1))
                  ],
                ),
              ),
              //c2
              const Divider(height: 1),
              //c3
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      '详情: ',
                      style: TextStyle(fontSize: 16),
                    ),
                    Expanded(
                        child: TextField(
                            focusNode: _contentFocusNode,
                            autofocus: false,
                            enabled: isEnabled,
                            controller: _contentController,
                            decoration: const InputDecoration.collapsed(
                                hintText: '请输入详情'),
                            maxLines: 4))
                  ],
                ),
              ),
              //c4
              const Divider(height: 1),
              //c5
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    //c5r1
                    const Text('优先级: ', style: TextStyle(fontSize: 16)),
                    //c5r2
                    Offstage(
                      offstage: !isEnabled && priorityValue == 1,
                      child: Row(
                        children: <Widget>[
                          //c5r2r1
                          Radio(
                            value: 0,
                            groupValue: priorityValue,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                priorityValue = value ?? 0;
                              });
                            },
                          ),
                          //c5r2r2
                          const Text('一般'),
                        ],
                      ),
                    ),
                    //c5r3
                    Offstage(
                      offstage: !isEnabled && priorityValue == 0,
                      child: Row(
                        children: <Widget>[
                          Radio(
                            value: 1,
                            groupValue: priorityValue,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (value) {
                              setState(() {
                                priorityValue = value ?? 0;
                              });
                            },
                          ),
                          const Text('重要'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //c6
              const Divider(height: 1),
              //c7
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: InkWell(
                  onTap: () {
                    if (!isEnabled) return;
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now()
                          .subtract(const Duration(days: 30)), //减30天
                      lastDate:
                          DateTime.now().add(const Duration(days: 30)), //加30天
                    ).then((onValue) {
                      if (onValue != null) {
                        setState(() {
                          selectedDate =
                              formatDate(onValue, [yyyy, '-', mm, '-', dd]);
                        });
                      }
                    }).catchError((onError) {
                      print(onError);
                    });
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      //c7r1
                      const Text(
                        '日期: ',
                        style: TextStyle(fontSize: 16),
                      ),
                      //c7r2
                      Expanded(
                          child: Text(
                        selectedDate,
                        style: const TextStyle(fontSize: 16),
                      )),
                      //c7r3
                      Offstage(
                        offstage: !isEnabled,
                        child: const Icon(Icons.arrow_forward_ios),
                      )
                    ],
                  ),
                ),
              ),
              //c8
              const Divider(height: 1),
              //c9
              Expanded(flex: 1, child: Container()),
              //c10
              Offstage(
                offstage: !isEnabled,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                        style: const ButtonStyle(
                            padding: WidgetStatePropertyAll(EdgeInsets.all(16)),
                            elevation: WidgetStatePropertyAll(0.5)),
                        child: const Text('保存'),
                        onPressed: () {
                          if (editKey == 0) {
                            //新增
                            saveTodo();
                          } else if (editKey == 1) {
                            //编辑
                            updateTodo();
                          }
                        },
                      ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 保存TODO
  void saveTodo() async {
    title = _titleController.text;
    content = _contentController.text;

    if (title.isEmpty) {
      T.show('请输入标题');
      return;
    }
    if (content.isEmpty) {
      T.show('请输入详情');
      return;
    }
    if (selectedDate.isEmpty) {
      T.show('请选择日期');
      return;
    }
    showTodoLoading();
    Map<String, dynamic> params = {
      'title': title,
      'content': content,
      'date': selectedDate,
      'type': todoType,
      'priority': priorityValue
    };
    apiService.addTodo((BaseModel model) {
      dismissTodoLoading();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('保存成功');
        //激发刷新Toto
        Application.eventBus?.fire(RefreshTodoEvent(todoType));
        Get.back();
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissTodoLoading();
    }, params);
  }

  /// 更新TODO
  void updateTodo() async {
    int id = todoSeed!.id!;
    int status = todoSeed!.status!;

    title = _titleController.text;
    content = _contentController.text;

    if (title.isEmpty) {
      T.show('请输入标题');
      return;
    }
    if (content.isEmpty) {
      T.show('请输入详情');
      return;
    }
    if (selectedDate.isEmpty) {
      T.show('请选择日期');
      return;
    }

    showTodoLoading();
    Map<String, dynamic> params = {
      'title': title,
      'content': content,
      'date': selectedDate,
      'type': todoType,
      'priority': priorityValue,
      'status': status
    };
    apiService.updateTodo((BaseModel model) {
      dismissTodoLoading();
      if (model.errorCode == CON.CODE_SUCCESS) {
        T.show('更新成功');
        Application.eventBus?.fire(RefreshTodoEvent(todoType));
        Get.back();
      } else {
        T.show('${model.errorMsg}');
      }
    }, (DioException error) {
      dismissTodoLoading();
    }, id, params);
  }

  /// 显示Loading
  void showTodoLoading() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) {
          return const LoadingDialog(
              outsideDismiss: false, loadingText: '正在保存');
        });
  }

  /// 隐藏Loading
  void dismissTodoLoading() {
    Get.back();
  }
}
