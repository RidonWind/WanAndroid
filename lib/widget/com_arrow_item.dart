import 'package:flutter/material.dart';
import 'package:wan_andriod/data/model/com_model.dart';
import 'package:wan_andriod/utils/gaps_util.dart';
import 'package:wan_andriod/utils/route_util.dart';

class ComArrowItem extends StatelessWidget {
  /// 数据model
  final ComModel model;

  /// 点击回调函数
  final Function? onClick;

  const ComArrowItem(this.model, {super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.bottom,
      child: Material(
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          title: Text(model.title ?? ''),
          subtitle: (model.subtitle == null || model.subtitle == '')
              ? null
              : Text(
                  model.subtitle!,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                model.extra ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Offstage(
                offstage: //是否显示箭头
                    model.isShowArrow == null ? true : !model.isShowArrow!,
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          onTap: () {
            if (model.page != null) {
              RouteUtil.push(context, model.page);
            } else if (model.url != null) {
              RouteUtil.toWebView(model.title ?? '', model.url!);
            } else {
              if (onClick != null) {
                onClick!();
              }
            }
          },
        ),
      ),
    );
  }
}
