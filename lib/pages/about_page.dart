import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/model/com_model.dart';
import 'package:wan_andriod/utils/gaps_util.dart';
import 'package:wan_andriod/utils/utils.dart';
import 'package:wan_andriod/widget/com_arrow_item.dart';

/// 关于界面
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  ComModel version =
      ComModel(title: '版本号', extra: AppConfig.version, isShowArrow: false);
  ComModel officialAddress = ComModel(
      title: '官方网站',
      subtitle: 'www.wanandroid.com',
      url: 'https://www.wanandroid.com',
      extra: '',
      isShowArrow: true);
  ComModel github = ComModel(
      title: '项目源码',
      subtitle: 'github.com/iceCola7/flutter_wanandroid',
      url: 'https://github.com/iceCola7/flutter_wanandroid',
      extra: '',
      isShowArrow: true);
  ComModel updateLogs = ComModel(
      title: '更新日志',
      url: 'https://github.com/iceCola7/flutter_wanandroid/releases',
      extra: '',
      isShowArrow: true);
  ComModel copyright =
      ComModel(title: '版权声明', extra: '仅作个人及非商业用途', isShowArrow: true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.4,
        title: const Text('关于'),
      ),
      body: ListView(
        children: <Widget>[
          //c1
          Container(
            height: 180,
            alignment: Alignment.center,
            decoration: Decorations.bottom,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //c1c1
                Card(
                  color: Theme.of(context).primaryColor,
                  elevation: 0.0,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Image.asset(Utils.getImagePath('ic_launcher_news'),
                      width: 72, fit: BoxFit.fill, height: 72),
                ),
                //c1c2
                GapsUtil.gapH10,
                //c1c3
                const Text(
                  AppConfig.appName,
                  style: TextStyle(fontSize: 20),
                )
              ],
            ),
          ),
          //c2
          ComArrowItem(version),
          ComArrowItem(officialAddress),
          ComArrowItem(github),
          ComArrowItem(updateLogs),
          ComArrowItem(
            copyright,
            onClick: () {
              showDialog(
                context: context,
                builder: (context) => const AlertDialog(
                  title: Text('版权声明'),
                  content: Text(
                      '本App所使用的所有API均由 玩Android（www.wanandroid.com） 网站提供，仅供学习交流，不可用于任何商业用途。'),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
