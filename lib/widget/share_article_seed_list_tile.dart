import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/share_article_model.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';

class ShareArticleSeedListTile extends StatefulWidget {
  final ShareArticleSeed item;
  final Function deleteItemCallback;
  const ShareArticleSeedListTile(
      {super.key, required this.item, required this.deleteItemCallback});

  @override
  State<ShareArticleSeedListTile> createState() =>
      _ShareArticleSeedListTileState();
}

class _ShareArticleSeedListTileState extends State<ShareArticleSeedListTile> {
  @override
  Widget build(BuildContext context) {
    ShareArticleSeed item = widget.item;
    Function deleteItemCallback = widget.deleteItemCallback;
    return Slidable(
      key: ValueKey('${item.id}'),
      // controller: slidableController,

      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          //滑到90%触发消失事件
          dismissThreshold: 0.9,
          onDismissed: () {
            deleteItemCallback(item.id);
          },
          closeOnCancel: true,
        ),
        children: <Widget>[
          SlidableAction(
            onPressed: (context) {
              Get.defaultDialog(
                  title: '提醒',
                  middleText: '确定删除分享吗?',
                  // textConfirm: ,
                  // textCancel: '取消',
                  confirm: TextButton(
                      onPressed: () {
                        Get.back();
                        deleteItemCallback(item.id);
                      },
                      child: const Text(
                        '确定',
                        style: TextStyle(color: Colors.cyan),
                      )),
                  cancel: TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        '取消',
                        style: TextStyle(color: Colors.cyan),
                      )));
            },
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '删除',
          )
        ],
      ),
      // endActionPane: ,
      child: InkWell(
        onTap: () {
          RouteUtil.toWebView(item.title ?? '', item.link ?? '');
        },
        child: Column(
          children: <Widget>[
            //c1
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: <Widget>[
                  //c1r1
                  Offstage(
                    //top默认就是0
                    offstage: item.top == 0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: CON.COLOR_TOP_OR_FRESH, width: 0.5),
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.elliptical(2, 2),
                              bottom: Radius.elliptical(2, 2))),
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: const Text(
                        '置顶',
                        style: TextStyle(
                            fontSize: 10, color: CON.COLOR_TOP_OR_FRESH),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  //c1r2
                  Offstage(
                    offstage: !item.fresh!,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFFF44336), width: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2)),
                      ),
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: const Text(
                        "新",
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFFF44336)),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  //c1r3
                  Offstage(
                    offstage: item.tags!.isEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan, width: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2)),
                      ),
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: Text(
                        item.tags!.isNotEmpty ? item.tags![0].name : "",
                        style: const TextStyle(
                            fontSize: 10, color: CON.COLOR_TAGS),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  //c1r4
                  Offstage(
                    offstage: item.audit != 0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.cyan, width: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2)),
                      ),
                      padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: const Text(
                        "待审核",
                        style: TextStyle(fontSize: 10, color: Colors.cyan),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  //c1r5
                  Text(
                    item.author!.isNotEmpty ? item.author! : item.shareUser!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    textAlign: TextAlign.left,
                  ),
                  //c1r6
                  Expanded(
                    child: Text(
                      item.niceShareDate!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            //c2
            Row(
              children: <Widget>[
                //c2r1
                Offstage(
                  offstage: item.envelopePic == "",
                  child: Container(
                      width: 100,
                      height: 80,
                      padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                      child: CustomCachedNetworkImage(
                          imageUrl: item.envelopePic ?? '')),
                ),
                //c2r2
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //c2r2c1
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Text(
                        item.title ?? '',
                        maxLines: 2,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    //c2r2c2
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: <Widget>[
                          //c2r2c2r1
                          Expanded(
                            child: Text(
                              '${item.superChapterName}/${item.chapterName}',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          //c2r2c2r2
                          LikeButtonWidget(
                              isLike: item.collect!,
                              onTap: () {
                                addOrCancelCollect(item);
                              })
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
            //c3
            const Divider(height: 1),
          ],
        ),
      ),
    );
  }

  void addOrCancelCollect(ShareArticleSeed item) {
    List<String>? cookies = User.singleton.cookie;
    if (cookies == null || cookies.isEmpty) {
      T.show('请先登录~');
    } else {
      if (item.collect!) {
        apiService.cancelCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('已取消收藏~');
            setState(() {
              item.collect = false;
            });
          } else {
            T.show('取消收藏失败~');
          }
        }, (DioException error) {
          print(error.response);
        }, item.id!);
      } else {
        apiService.addCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('收藏成功~');
            setState(() {
              item.collect = true;
            });
          } else {
            T.show('收藏失败~');
          }
        }, (DioException error) {
          print(error.response);
        }, item.id!);
      }
    }
  }
}
