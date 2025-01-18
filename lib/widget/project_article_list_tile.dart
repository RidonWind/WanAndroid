import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/project_article_model.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/widget/like_button_widget.dart';

class ProjectArticleListTile extends StatefulWidget {
  final ProjectArticleSeed item;
  const ProjectArticleListTile({super.key, required this.item});

  @override
  State<ProjectArticleListTile> createState() => _ProjectArticleListTileState();
}

class _ProjectArticleListTileState extends State<ProjectArticleListTile> {
  @override
  Widget build(BuildContext context) {
    ProjectArticleSeed item = widget.item;
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
              Container(
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                child: SizedBox(
                    width: 80,
                    height: 130,
                    child: CustomCachedNetworkImage(
                      imageUrl: item.envelopePic ?? '',
                      fit: BoxFit.fill,
                    )),
              ),
              //c1r2
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //c1r2c1
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                    child: Text(item.title ?? '',
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                        textAlign: TextAlign.left),
                  ),
                  //c1r2c2
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                      child: Text(item.desc ?? '',
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[600]),
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis)),
                  //c1r2c3
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(0, 0, 8, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        //c1r2c3r1
                        Text(
                          item.author!.isNotEmpty
                              ? item.author!
                              : item.shareUser!,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                        //c1r2c3r2
                        Text(
                          item.niceDate!,
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[600]),
                        )
                      ],
                    ),
                  ),
                  //c1r2c4
                  Container(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                      child: LikeButtonWidget(
                          isLike: item.collect!,
                          onTap: () {
                            addOrCanCelCollect(item);
                          }))
                ],
              ))
            ],
          ),
          //c2
          const Divider(height: 1),
        ],
      ),
    );
  }

  /// 添加收藏或者取消收藏
  void addOrCanCelCollect(ProjectArticleSeed item) {
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
          print('${error.response}');
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
