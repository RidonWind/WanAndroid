import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/wechat_article_model.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';

///微信公众号文章简要卡片
class WechatArticleSeedListTile extends StatefulWidget {
  final WechatArticleSeed seed;
  const WechatArticleSeedListTile({super.key, required this.seed});

  @override
  State<WechatArticleSeedListTile> createState() =>
      _WechatArticleSeedListTileState();
}

class _WechatArticleSeedListTileState extends State<WechatArticleSeedListTile> {
  @override
  Widget build(BuildContext context) {
    WechatArticleSeed seed = widget.seed;
    return InkWell(
      onTap: () {
        RouteUtil.toWebView(seed.title!, seed.link!);
      },
      child: Column(
        children: <Widget>[
          //c1
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                //c1r1 作者或分享者
                Text(
                  seed.author!.isNotEmpty ? seed.author! : seed.shareUser!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.left,
                ),
                //c1r2 分享时间
                Expanded(
                    child: Text(seed.niceShareDate!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        textAlign: TextAlign.right))
              ],
            ),
          ),
          //c2
          Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: <Widget>[
                //     //c2r1
                Expanded(
                  child: Text('${seed.title}',
                      maxLines: 2,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left),
                )
              ],
            ),
          ),
          //c3
          Container(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: <Widget>[
                //c3r1
                Expanded(
                    child: Text(
                  '${seed.superChapterName}/${seed.chapterName}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                )),
                //c3r2
                LikeButtonWidget(
                    isLike: seed.collect!,
                    onTap: () {
                      addOrCancelCollect(seed);
                    })
              ],
            ),
          ),
          //c4
          const Divider(height: 1),
        ],
      ),
    );
  }

  void addOrCancelCollect(WechatArticleSeed seed) async {
    List<String>? cookies = User.singleton.cookie;
    if (cookies == null || cookies.isEmpty) {
      T.show('请先登录~');
    } else {
      if (seed.collect!) {
        apiService.cancelCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('已经取消收藏~');
            setState(() {
              seed.collect = false;
            });
          } else {
            T.show('取消收藏失败~');
          }
        }, (DioException error) {
          print(error.response);
        }, seed.id!);
      } else {
        apiService.addCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('收藏成功~');
            setState(() {
              seed.collect = true;
            });
          } else {
            T.show('收藏失败~');
          }
        }, (DioException error) {
          print('${error.response}');
        }, seed.id!);
      }
    }
  }
}
