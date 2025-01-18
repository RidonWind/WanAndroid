import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/knowledge_detail_model.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';

class KnowledgeDetailListTile extends StatefulWidget {
  final KnowledgeDetailChild item;
  const KnowledgeDetailListTile({super.key, required this.item});

  @override
  State<KnowledgeDetailListTile> createState() =>
      _KnowledgeDetailListTileState();
}

class _KnowledgeDetailListTileState extends State<KnowledgeDetailListTile> {
  @override
  Widget build(BuildContext context) {
    KnowledgeDetailChild item = widget.item;
    return InkWell(
      onTap: () {
        RouteUtil.toWebView(item.title ?? '', item.link ?? '');
      },
      child: Column(
        children: <Widget>[
          //c1
          Row(
            children: [
              //c1r1
              Offstage(
                offstage: item.envelopePic == '',
                child: Container(
                  width: 100,
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                  child: CustomCachedNetworkImage(imageUrl: item.envelopePic!),
                ),
              ),
              //c1r2
              Expanded(
                  child: Column(
                children: <Widget>[
                  //c1r2c1
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        //c1r2c1r1
                        Text(
                          item.author!.isNotEmpty
                              ? item.author!
                              : item.shareUser!,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.left,
                        ),
                        Expanded(
                            child: Text(
                          item.niceDate!,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.right,
                        ))
                      ],
                    ),
                  ),
                  //c1r2c2
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: <Widget>[
                        //c1r2c2r1
                        Expanded(
                            child: Text(item.title ?? '',
                                maxLines: 2,
                                style: const TextStyle(fontSize: 16),
                                textAlign: TextAlign.left))
                      ],
                    ),
                  ),
                  //c1r2c3
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        //c1r2c3r1
                        Expanded(
                            child: Text(
                          item.chapterName ?? '',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.left,
                        )),
                        //c1r2c3r2
                        LikeButtonWidget(
                          isLike: item.collect ?? false,
                          onTap: () {
                            addOrCancelCollect(item);
                          },
                        )
                      ],
                    ),
                  )
                ],
              ))
            ],
          ),
          //c2
          const Divider(height: 1)
        ],
      ),
    );
  }

  /// 添加收藏或者取消收藏
  void addOrCancelCollect(KnowledgeDetailChild item) {
    List<String>? cookies = User.singleton.cookie;
    if (cookies == null || cookies.isEmpty) {
      T.show('请先登录~');
    } else {
      if (item.collect!) {
        apiService.cancelCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('已取消收藏');
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
            T.show('收藏成功');
            setState(() {
              item.collect = true;
            });
          } else {
            T.show('收藏失败');
          }
        }, (DioException error) {
          print(error.response);
        }, item.id!);
      }
    }
  }
}
