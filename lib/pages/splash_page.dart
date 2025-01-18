import 'package:flutter/material.dart';
import 'package:wan_andriod/utils/utils.dart';
import 'package:get/get.dart';

/**
 * 启动页面
 */
///启动页面
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //在指定的延迟时间后执行一段代码。在 Flutter 开发中，这可以用于各种需要延迟执行的场景，比如延迟加载数据、延迟显示动画等。
    // ‌delay‌：一个 Duration 对象，表示延迟的时间。
    // ‌computation‌：一个返回 void 或 Future 的函数，这个函数将在延迟时间后执行。
    Future.delayed(const Duration(seconds: 2), () {
      Get.offAndToNamed('/tabs');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            //欢迎页面
            color: Theme.of(context).primaryColor,
            // color: Colors.transparent,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // 当设置为 MainAxisSize.max 时，Row 或 Column 组件会尽可能多地占用主轴方向上的空间。这意味着组件会扩展以填满其父容器在主轴方向上的可用空间。
              // 默认情况下，Row 和 Column 的 mainAxisSize 属性都被设置为 MainAxisSize.max。
              // 当设置为 MainAxisSize.min 时，Row 或 Column 组件会仅根据其子组件的大小来占用主轴方向上的空间。这意味着组件只会扩展到刚好容纳其子组件所需的最小空间。
              // 这对于创建紧凑的布局非常有用，尤其是当你想要避免 Row 或 Column 组件不必要地扩展以填满其父容器时。
              mainAxisSize: MainAxisSize.min,
              children: [
                //白环 48半径的白圆中间加46半径的背景色
                Card(
                  //elevation 属性用于控制卡片的阴影大小，即卡片的“立体感”。
                  //当你需要突出显示某些重要信息或希望用户更加注意某个区域时，
                  //可以增加卡片的 elevation 值，使其看起来更加突出。
                  elevation: 0,
                  color: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(48.0))),
                  child: Card(
                    elevation: 0,
                    color: Theme.of(context).primaryColor,
                    margin: const EdgeInsets.all(2.0),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(46.0))),
                    child: CircleAvatar(
                      //透明
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          AssetImage(Utils.getImagePath('ic_launcher_news')),
                      //半径
                      radius: 46.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
