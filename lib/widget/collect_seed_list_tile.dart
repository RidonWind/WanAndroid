import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/collect_model.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';

class CollectSeedListTile extends StatefulWidget {
  final CollectArticleSeed item;

  /// 收藏的回调函数 返回true点击了取消按钮
  final Function isCancelCollectCallback;
  const CollectSeedListTile(
      {super.key, required this.item, required this.isCancelCollectCallback});

  @override
  State<CollectSeedListTile> createState() => _CollectSeedListTileState();
}

class _CollectSeedListTileState extends State<CollectSeedListTile> {
  @override
  Widget build(BuildContext context) {
    CollectArticleSeed item = widget.item;
    return InkWell(
      onTap: () {
        RouteUtil.toWebView(item.title ?? '', item.link ?? '');
      },
      child: Column(
        children: <Widget>[
          //c1
          Row(
            children: <Widget>[
              //c1r1
              Offstage(
                offstage: item.envelopePic == '',
                child: Container(
                    width: 100,
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
                    child: CustomCachedNetworkImage(
                        imageUrl: item.envelopePic ?? '')),
              ),
              //c1r2
              Expanded(
                  child: Column(
                children: <Widget>[
                  // c1r2c1
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        //c1r2c1r1
                        Text(
                          item.author ?? '',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.right,
                        )
                      ],
                    ),
                  ),
                  // c1r2c2
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Row(
                      children: [
                        //c1r2c2r1
                        Expanded(
                            child: Text(
                          item.title ?? '',
                          maxLines: 2,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.left,
                        )),
                      ],
                    ),
                  ),
                  // c1r2c3
                  Container(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          item.chapterName ?? '',
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                          textAlign: TextAlign.left,
                        )),
                        LikeButtonWidget(
                            isLike: true,
                            onTap: () {
                              cancelCollect(item);
                            })
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

  /// 取消收藏
  void cancelCollect(CollectArticleSeed item) {
    List<String>? cookies = User.singleton.cookie;
    if (cookies == null || cookies.isEmpty) {
      T.show('请先登录~');
    } else {
      apiService.cancelCollect((BaseModel model) {
        if (model.errorCode == CON.CODE_SUCCESS) {
          T.show('已取消收藏~');
          widget.isCancelCollectCallback(true);
        } else {
          T.show('取消收藏失败~');
          widget.isCancelCollectCallback(false);
        }
      }, (DioException error) {
        print(error.response);
      }, item.originId!);
    }
  }
}
