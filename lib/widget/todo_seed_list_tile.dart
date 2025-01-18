import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/model/todo_model.dart';
import 'package:wan_andriod/utils/theme_util.dart';

class TodoSeedListTile extends StatefulWidget {
  /// TODO实体
  final TodoSeed item;
  final bool isShowSuspension;

  /// 待办类型
  final int todoType;

  /// 是否是待办 true:待办  false:已完成
  final bool isTodo;

  /// 更新TODO
  final Function updateTodoCallback;

  /// 删除TODO
  final Function deleteItemCallback;

  const TodoSeedListTile(
      {super.key,
      required this.item,
      this.isShowSuspension = false,
      required this.todoType,
      this.isTodo = true,
      required this.updateTodoCallback,
      required this.deleteItemCallback});

  @override
  State<TodoSeedListTile> createState() => _TodoSeedListTileState();
}

class _TodoSeedListTileState extends State<TodoSeedListTile> {
  @override
  Widget build(BuildContext context) {
    final TodoSeed item = widget.item;
    final bool isShowSuspension = widget.isShowSuspension;
    final int todoType = widget.todoType;
    final bool isTodo = widget.isTodo;
    return StickyHeader(
        //每个Map的数组第一个显示 StickyHeader
        header: Offstage(
          offstage: !isShowSuspension,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            alignment: Alignment.centerLeft,
            height: 28,
            color: ThemeUtils.dark
                ? const Color(0xFF515151)
                : const Color(0xFFF5F5F5),
            child: Text(
              item.dateStr!,
              style: const TextStyle(fontSize: 12, color: CON.COLOR_TAGS),
            ),
          ),
        ),
        content: Slidable(
            endActionPane:
                ActionPane(motion: const ScrollMotion(), children: <Widget>[
              SlidableAction(
                onPressed: (context) {
                  widget.updateTodoCallback(item.id);
                },
                backgroundColor: Colors.grey,
                foregroundColor: Colors.white,
                icon: isTodo ? Icons.check : Icons.redo,
                label: isTodo ? '已完成' : '复原',
              ),
              SlidableAction(
                onPressed: (context) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      // title: new Text(''),
                      content: const Text('确定删除吗？'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('取消',
                              style: TextStyle(color: Colors.cyan)),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            widget.deleteItemCallback(item.id);
                          },
                          child: const Text('确定',
                              style: TextStyle(color: Colors.cyan)),
                        ),
                      ],
                    ),
                  );
                },
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: '删除',
              )
            ]),
            child: InkWell(
              onTap: () {
                Get.toNamed('/todo_add_or_edit_page', arguments: {
                  'todoType': todoType, // 待办类型：0:只用这一个  1:工作  2:学习  3:生活
                  'editKey': 1, // 编辑类型：0:新增  1:编辑  2:查看
                  'seed': item
                });
              },
              child: Column(
                children: <Widget>[
                  //c1
                  Row(
                    children: [
                      //c1r1
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Column(
                          children: <Widget>[
                            //c1r1c1
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Text(item.title ?? '',
                                  style: const TextStyle(fontSize: 16),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left),
                            ),
                            //c1r1c2
                            Container(
                                alignment: Alignment.topLeft,
                                padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                                child: Text(item.content ?? '',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left))
                          ],
                        ),
                      )),
                      //c1r2
                      Offstage(
                        offstage: item.priority != 1,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: CON.COLOR_TOP_OR_FRESH, width: 0.5),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.elliptical(2, 2),
                                  bottom: Radius.elliptical(2, 2))),
                          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                          margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: const Text('重要',
                              style: TextStyle(
                                  fontSize: 10, color: CON.COLOR_TOP_OR_FRESH),
                              textAlign: TextAlign.left),
                        ),
                      )
                    ],
                  ),
                  //c2
                  const Divider(height: 1),
                ],
              ),
            )));
    /* 
    return Slidable(
        endActionPane:
            ActionPane(motion: const ScrollMotion(), children: <Widget>[
          SlidableAction(
            onPressed: (context) {
              widget.updateTodoCallback(item.id);
            },
            backgroundColor: Colors.grey.shade200,
            foregroundColor: Colors.white,
            icon: isTodo ? Icons.check : Icons.redo,
            label: isTodo ? '已完成' : '复原',
          ),
          SlidableAction(
            onPressed: (context) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  // title: new Text(''),
                  content: const Text('确定删除吗？'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('取消',
                          style: TextStyle(color: Colors.cyan)),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                        widget.deleteItemCallback(item.id);
                      },
                      child: const Text('确定',
                          style: TextStyle(color: Colors.cyan)),
                    ),
                  ],
                ),
              );
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          )
        ]),
        child: InkWell(
          onTap: () {
            Get.toNamed('/todo_add_or_edit_page',
                arguments: {'todoType': todoType, 'editKey': 1, 'seed': item});
          },
          child: Column(
            children: <Widget>[
              //c1
              Row(
                children: [
                  //c1r1
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      children: <Widget>[
                        //c1r1c1
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Text(item.title ?? '',
                              style: const TextStyle(fontSize: 16),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left),
                        ),
                        //c1r1c2
                        Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                            child: Text(item.content ?? '',
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left))
                      ],
                    ),
                  )),
                  //c1r2
                  Offstage(
                    offstage: item.priority != 1,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: CON.COLOR_TOP_OR_FRESH, width: 0.5),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.elliptical(2, 2),
                              bottom: Radius.elliptical(2, 2))),
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                      child: const Text('重要',
                          style: TextStyle(
                              fontSize: 10, color: CON.COLOR_TOP_OR_FRESH),
                          textAlign: TextAlign.left),
                    ),
                  )
                ],
              ),
              //c2
              const Divider(height: 1),
            ],
          ),
        ));*/
  }
}
