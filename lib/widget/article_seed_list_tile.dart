import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/article_model.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/utils/route_util.dart';

class ArticleSeedListTile extends StatefulWidget {
  final ArticleSeed articleSeed;
  const ArticleSeedListTile({
    super.key,
    required this.articleSeed,
  });

  @override
  State<ArticleSeedListTile> createState() => _ArticleSeedListTileState();
}

class _ArticleSeedListTileState extends State<ArticleSeedListTile> {
  @override
  Widget build(BuildContext context) {
    var seed = widget.articleSeed;
    return InkWell(
      onTap: () {
        RouteUtil.toWebView(seed.title!, seed.link!);
      },
      child: Column(
        children: <Widget>[
          Container(
            //内边距左右16 上下10
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            //C1
            child: Row(
              children: <Widget>[
                //C1R1
                Offstage(
                  //不是置顶文章,就不显示'置顶'两字
                  offstage: seed.top == 0,
                  child: Container(
                    //边框
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: CON.COLOR_TOP_OR_FRESH, width: 0.5),
                        //圆角
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2))),
                    //置顶内边距 左右4 上下2(修改上0 才居中,不知道为什么文字与上边有2的空间)
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                    //置顶外边距 右4
                    margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: const Text(
                      '置顶',
                      style: TextStyle(
                        fontSize: 10,
                        color: CON.COLOR_TOP_OR_FRESH,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                //C1R2
                Offstage(
                  //是否新文章 如果seed.fresh是null的就给true 不显示
                  //fresh可空参数没法取反,所以用三目
                  offstage: !seed.fresh!,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: CON.COLOR_TOP_OR_FRESH, width: 0.5),
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.elliptical(2, 2),
                            bottom: Radius.elliptical(2, 2))),
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                    margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: const Text(
                      '新',
                      style: TextStyle(
                          fontSize: 10, color: CON.COLOR_TOP_OR_FRESH),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                //C1R3
                Offstage(
                  //tages是空的就不显示
                  offstage: seed.tags!.isEmpty,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: CON.COLOR_TAGS, width: 0.5),
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.elliptical(2, 2),
                          bottom: Radius.elliptical(2, 2)),
                    ),
                    padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                    margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: Text(
                      seed.tags!.isNotEmpty ? seed.tags![0]['name'] : '',
                      style:
                          const TextStyle(fontSize: 10, color: CON.COLOR_TAGS),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                //C1R4,显示作者,没有的话就显示分享用户
                Text(
                  seed.author!.isNotEmpty ? seed.author! : seed.shareUser!,
                  style: const TextStyle(
                      fontSize: 12, color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                  textAlign: TextAlign.left,
                ),
                //C1R5,占满剩下位置
                Expanded(
                    child: Text(
                  seed.niceShareDate!,
                  style: const TextStyle(
                      fontSize: 12, color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                  textAlign: TextAlign.right,
                ))
              ],
            ),
          ),
          Row(
            children: <Widget>[
              //C2R1 数据基本上都是空的
              Offstage(
                offstage: seed.envelopePic == '',
                child: Container(
                  width: 100,
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                  child: CustomCachedNetworkImage(imageUrl: seed.envelopePic!),
                ),
              ),
              //C2R2,剩余空间再构建一个列
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //C2R2C1,显示最多两行的标题
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Text(
                      seed.title!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  //C2R2C2,显示数据来源
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                    child: Row(
                      children: <Widget>[
                        //C2R2C2R1
                        Expanded(
                            child: Text(
                          '${seed.superChapterName}/${seed.chapterName}',
                          style: const TextStyle(
                              fontSize: 12,
                              color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                          textAlign: TextAlign.left,
                        )),
                        ////C2R2C2R2,显示收藏
                        LikeButtonWidget(
                          isLike: seed.collect!,
                          onTap: () {
                            addOrCancelCollect(seed);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ))
            ],
          ),
          //C3 最底下给一条高1的分割线
          const Divider(
            height: 1,
          )
        ],
      ),
    );
  }

  ///添加收藏或者取消收藏
  void addOrCancelCollect(ArticleSeed seed) {
    List<String>? cookies = User.singleton.cookie;
    if (cookies == null || cookies.isEmpty) {
      T.show('请先登录');
    } else {
      if (seed.collect!) {
        apiService.cancelCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('已取消收藏~');
            setState(() {
              seed.collect = false;
            });
          } else {
            T.show('取消收藏失败');
          }
        }, (DioException error) {
          print(error.response);
        }, seed.id!);
      } else {
        apiService.addCollect((BaseModel model) {
          if (model.errorCode == CON.CODE_SUCCESS) {
            T.show('收藏成功');
            setState(() {
              seed.collect = true;
            });
          } else {
            T.show('收藏失败');
          }
        }, (DioException error) {
          print(error.response);
        }, seed.id!);
      }
    }
  }
}
