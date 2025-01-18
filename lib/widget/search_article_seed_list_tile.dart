import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/article_model.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';
import 'package:wan_andriod/utils/toast_util.dart';

class SearchArticleSeedListTile extends StatefulWidget {
  final ArticleSeed articleSeed;
  const SearchArticleSeedListTile({super.key, required this.articleSeed});

  @override
  State<SearchArticleSeedListTile> createState() =>
      _SearchArticleSeedListTileState();
}

class _SearchArticleSeedListTileState extends State<SearchArticleSeedListTile> {
  @override
  Widget build(BuildContext context) {
    ArticleSeed seed = widget.articleSeed;
    return InkWell(
        onTap: () {
          RouteUtil.toWebView(seed.title ?? '', seed.link ?? '');
        },
        child: Column(
          children: <Widget>[
            //C1
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: <Widget>[
                  //C1R1 新
                  Offstage(
                    offstage: !seed.fresh!,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: CON.COLOR_TOP_OR_FRESH, width: 0.5)),
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
                  //C1R2 tags
                  Offstage(
                    offstage: seed.tags!.isEmpty,
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: CON.COLOR_TAGS, width: 0.5)),
                      padding: const EdgeInsets.fromLTRB(4, 0, 4, 2),
                      margin: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                      child: Text(
                        seed.tags!.isNotEmpty
                            ? '''${seed.tags?[0]['name']}'''
                            : '',
                        style: const TextStyle(
                            fontSize: 10, color: CON.COLOR_TAGS),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  //C1R3 author or shareUser
                  Text(
                    seed.author!.isNotEmpty
                        ? '${seed.author}'
                        : '${seed.shareUser}',
                    style: const TextStyle(
                        fontSize: 12, color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                    textAlign: TextAlign.left,
                  ),
                  //C1R4 niceShareDate占剩余空间靠右
                  Expanded(
                      child: Text(
                    '${seed.niceShareDate}',
                    style: const TextStyle(
                        fontSize: 12, color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                    textAlign: TextAlign.right,
                  ))
                ],
              ),
            ),
            //C2
            Row(
              children: <Widget>[
                //C2R1 envelopePic
                Offstage(
                  offstage: seed.envelopePic == '',
                  child: Container(
                    width: 100,
                    height: 80,
                    padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                    child: CustomCachedNetworkImage(
                        imageUrl: seed.envelopePic ?? ''),
                  ),
                ),
                //C2R2
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    //C2R2C1 标题
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      //搜索返回的标题带HTML,把搜索关键词加亮显示了,需要转换HTML
                      child: Html(
                        data: '<p>${seed.title}</p>',
                        style: {
                          'em': Style(
                            fontSize: FontSize(16),
                            fontStyle: FontStyle.normal,
                            color: CON.COLOR_TOP_OR_FRESH,
                          ),
                          'p': Style(
                            textOverflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            fontSize: FontSize(16),
                          )
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: <Widget>[
                          //C2R2C2R1 数据来源
                          Expanded(
                            child: Text(
                              '${seed.superChapterName}/${seed.chapterName}',
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CON.COLOR_AUTHOR_DATA_CHAPTER),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          //C2R2C2R2
                          LikeButtonWidget(
                              isLike: seed.collect!,
                              onTap: () {
                                addOrCancelCollect(seed);
                              })
                        ],
                      ),
                    )
                  ],
                ))
              ],
            ),
            //C3 一条分割线
            const Divider(
              height: 1,
            )
          ],
        ));
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
