import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/event/theme_change_event.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/utils/sp_util.dart';
import 'package:wan_andriod/utils/theme_util.dart';

/// 设置页面
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: const Text('设置'),
      ),
      body: ListView(
        children: <Widget>[
          //c1 可扩展的tile
          ExpansionTile(
            title: Row(
              children: <Widget>[
                //c1r1
                Icon(
                  Icons.color_lens,
                  color: Theme.of(context).primaryColor,
                ),
                //c1r2
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('主题'),
                )
              ],
            ),
            children: <Widget>[
              Wrap(
                children: themeColorMap.keys.map((String key) {
                  Color value = themeColorMap[key]!;
                  return InkWell(
                    onTap: () {
                      //把主题颜色对应的String名称存起来
                      SPUtil.putString(CON.KEY_THEME_COLOR, key);
                      //当前主题颜色属性修改
                      ThemeUtils.currentThemeColor = value;
                      //激发主题颜色修改事件,用上面改好的属性去修改主题颜色
                      Application.eventBus?.fire(ThemeChangeEvent());
                    },
                    child: Container(
                        margin: const EdgeInsets.all(5),
                        width: 36,
                        height: 36,
                        color: value),
                  );
                }).toList(),
              )
            ],
          ),
          //c2
          ListTile(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.feedback,
                  color: Theme.of(context).primaryColor,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('意见反馈'),
                )
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              String url =
                  'https://github.com/iceCola7/flutter_wanandroid/issues';
              RouteUtil.launchInBrowser(url);
            },
          ),
          //c3
          ListTile(
            title: Row(
              children: <Widget>[
                //c3r1
                Icon(Icons.settings_overscan,
                    color: Theme.of(context).primaryColor),
                //c3r2
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('扫码下载'),
                )
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed('/qr_code_page');
            },
          ),
          //c4
          ListTile(
            //这样隔得远
            // leading: Icon(Icons.info, color: Theme.of(context).primaryColor),
            // title: const Text('关于'),
            // trailing: const Icon(Icons.chevron_right),
            title: Row(
              children: <Widget>[
                //c4r1
                Icon(Icons.info, color: Theme.of(context).primaryColor),
                //c4r2
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text('关于'),
                )
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Get.toNamed('/about_page');
            },
          )
        ],
      ),
    );
  }
}
