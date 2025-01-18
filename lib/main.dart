import 'dart:io';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/event/theme_change_event.dart';
import 'package:wan_andriod/net/dio_manager.dart';
import 'package:wan_andriod/utils/sp_util.dart';
import 'package:wan_andriod/utils/theme_util.dart';
import 'package:wan_andriod/common/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
//import...as‌... 避免命名冲突‌：如果引入了多个库，并且它们中有重名的成员，你可以通过为它们指定不同的别名来避免命名冲突。
// import 'package:flutter_wanandroid/common/router_config.dart' as myrouter; //这是开源代码中引入存放route的文件

// routes: myrouter.Router.generateRoute(), //因为自定义Router类与系统自带Router重名,所以加as
/// 在拿不到context的地方通过navigatorKey进行路由跳转：
/// https://stackoverflow.com/questions/52962112/how-to-navigate-without-context-in-flutter-app
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();//已经用Getx导航了

void main() async {
  /// 修改问题: Unhandled Exception: ServicesBinding.defaultBinaryMessenger was accessed before the binding was initialized
  /// https://stackoverflow.com/questions/57689492/flutter-unhandled-exception-servicesbinding-defaultbinarymessenger-was-accesse
  WidgetsFlutterBinding.ensureInitialized(); //原开源代码,目前没出现这问题
  await SPUtil.getInstance();
  await getTheme();
  runApp(const MyApp());

  ///去掉安卓状态栏浅灰色透明底色,变成纯透明的状态栏
  if (Platform.isAndroid) {
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，
    // 是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
    SystemUiOverlayStyle systemUiOverlayStyle =
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

/// 获取主题
Future<Null> getTheme() async {
  //是否是夜间模式
  bool dark = SPUtil.getBool(CON.KEY_DARK, defValue: false);
  ThemeUtils.dark = dark;
  //如果不是夜间模式,设置的其他主题颜色才起作用
  if (!dark) {
    String themeColorKey =
        SPUtil.getString(CON.KEY_THEME_COLOR, defValue: 'redAccent');
    if (themeColorMap.containsKey(themeColorKey)) {
      ThemeUtils.currentThemeColor = themeColorMap[themeColorKey]!;
    }
  }
}

/// 这个 widget 作用这个应用的顶层 widget.
/// 这个 widget 是无状态的，所以我们继承的是 [StatelessWidget].
/// 对应的，有状态的 widget 可以继承 [StatefulWidget]
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeData themeData; //主题模式

  @override
  void initState() {
    super.initState();
    //异步初始化用户信息
    _initAsync();
    Application.eventBus = EventBus();
    themeData = ThemeUtils.getThemeData();
    registerThemeEvent();
  }

  void _initAsync() async {
    await User().getUserInfo();
    await DioManager.init();
  }

  /// 注册主题改变事件
  void registerThemeEvent() {
    Application.eventBus
        ?.on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData) => changeTheme(onData));
  }

  void changeTheme(ThemeChangeEvent onData) async {
    setState(() {
      themeData = ThemeUtils.getThemeData();
    });
  }

  @override
  void dispose() {
    super.dispose();
    Application.eventBus?.destroy();
  }

  @override
  Widget build(BuildContext context) {
    //初始化ScreenUtil插件
    return ScreenUtilInit(
      //在使用之前请设置好设计稿的宽度和高度，传入设计稿的宽度和高度(单位随意,但在使用过程中必须保持一致) 一定要进行初始化(只需设置一次),以保证在每次使用之前设置好了适配尺寸:
      //‌dp是设备独立像素
      designSize: const Size(360, 690),
      //	是否根据宽度/高度中的最小值适配文字(默认false)
      minTextAdapt: true,
      //支持分屏尺寸(默认false)
      splitScreenMode: true,
      //一般返回一个MaterialApp类型的Function()
      builder: (context, child) {
        return GetMaterialApp(
          title: AppConfig.appName, //标题
          debugShowCheckedModeBanner: false, //去掉debug图标
          theme: themeData,
          // routes: myrouter.Router.generateRoute(), // 存放路由的配置 改为Getx路由
          getPages: PageRoutes.routes, //使用Getx管理路由
          // home: new SplashScreen(), // 启动页(开源代码中使用)
          initialRoute: '/', //初始路由
          //‌状态管理‌：通过使用带有 navigatorKey 的 Navigator，你可以在应用的不同部分之间共享导航状态。
          //  这对于实现复杂的导航逻辑，如底部导航栏或侧边栏导航，非常有用。
          //‌控制导航‌：有了 navigatorKey，你可以在任何地方控制导航器的行为，
          //  比如推送新页面、弹出页面或替换当前页面。这对于实现全局的导航控制逻辑非常有帮助。
          //‌避免重建导航器‌：在Flutter中，如果导航器被重建，那么它的状态（比如当前页面堆栈）也会丢失。
          //  通过使用 navigatorKey，你可以确保导航器在应用的整个生命周期内保持唯一，从而避免状态丢失。
          // 最后，你可以在任何需要控制导航的地方使用 navigatorKey。例如，你可以在一个按钮的点击事件处理函数中使用它来推送一个新页面。
          //navigatorKey.currentState?.pushNamed('/newPage');
          // navigatorKey: navigatorKey,//开源代码中使用到
        );
      },
    );
    /*;*/
  }
}
