import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/user_info_model.dart';
import 'package:wan_andriod/event/login_event.dart';
import 'package:wan_andriod/event/theme_change_event.dart';
import 'package:wan_andriod/utils/sp_util.dart';
import 'package:wan_andriod/utils/theme_util.dart';
import 'package:wan_andriod/utils/utils.dart';
import 'package:wan_andriod/utils/gaps_util.dart';
import 'package:wan_andriod/utils/toast_util.dart';

///侧滑页面
class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage>
    with AutomaticKeepAliveClientMixin {
  bool isLogin = false;
  String username = '去登录';
  String level = '--'; //等级
  String rank = '--'; //排名
  String myScore = ''; //我的积分

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    print('---------------------------------drawer page init');
    //注册登录成功事件,自动回到drawer页面执行内容更新数据
    registerLoginEvent();

    if (User.singleton.username != null) {
      if (User.singleton.username!.isNotEmpty) {
        isLogin = true;
        username = User.singleton.username!;
        getUserInfo();
      }
    }
  }

  ///注册登录成功事件,注册成功后发动事件
  void registerLoginEvent() {
    Application.eventBus?.on<LoginEvent>().listen((onData) {
      setState(() {
        isLogin = true;
        username = User.singleton.username ?? '获取用户名失败';
        getUserInfo();
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print('-----------------------------------drawer page dispose()');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return PopScope(
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            //C1
            Container(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 10),
              color: Theme.of(context).primaryColor,
              child: Column(
                children: [
                  // C1C1 等级排名
                  Container(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        child: Image.asset(
                          Utils.getImagePath('ic_rank'),
                          color: Colors.white,
                          width: 20,
                          height: 20,
                        ),
                        onTap: () {
                          Get.toNamed('/rank_page');
                        },
                      )),
                  //C1C2 头像
                  CircleAvatar(
                    backgroundImage: AssetImage(
                      Utils.getImagePath('ic_default_avatar'),
                    ),
                    radius: 40.0, //半径
                  ),
                  //C1C3 上下间隔10
                  GapsUtil.gapH10,
                  //C1C4
                  InkWell(
                    onTap: () {
                      //如果还没登录
                      if (!isLogin) {
                        //去登录页面
                        Get.toNamed('/login_page');
                      }
                    },
                    child: Text(
                      username,
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  //C1C5 上下间隔5
                  GapsUtil.gapH5,
                  //C1C6的一行等级排名信息
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '等级:',
                        style: TextStyle(fontSize: 11, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        level,
                        style: TextStyle(fontSize: 11, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                      GapsUtil.gapW5,
                      Text(
                        '排名:',
                        style: TextStyle(fontSize: 11, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        rank,
                        style: TextStyle(fontSize: 11, color: Colors.grey[100]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  )
                ],
              ),
            ),
            //C2
            ListTile(
              title: const Text('我的积分',
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
              leading: Image.asset(Utils.getImagePath('ic_score'),
                  width: 24, height: 24, color: Theme.of(context).primaryColor),
              trailing:
                  Text(myScore, style: TextStyle(color: Colors.grey[500])),
              onTap: () {
                if (isLogin) {
                  Get.toNamed('/score_page', arguments: myScore); //去积分页面
                } else {
                  T.show('请先登录');
                  Get.toNamed('/login_page'); //去登录页面
                }
              },
            ),
            //C3
            ListTile(
              title: const Text('我的收藏',
                  style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
              leading: Icon(Icons.favorite_border,
                  size: 24, color: Theme.of(context).primaryColor),
              onTap: () {
                if (isLogin) {
                  Get.toNamed('/collect_page'); //去收藏页面
                } else {
                  T.show('请先登录');
                  Get.toNamed('/login_page'); //去登录页面
                }
              },
            ),
            //C4
            ListTile(
              title: const Text('我的分享',
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
              leading: Image.asset(Utils.getImagePath('ic_share'),
                  width: 24, height: 24, color: Theme.of(context).primaryColor),
              onTap: () {
                if (isLogin) {
                  Get.toNamed('/share_page'); //去分享页面
                } else {
                  T.show('请先登录');
                  Get.toNamed('/login_page'); //去登录页面
                }
              },
            ),
            //C5
            ListTile(
              title: const Text('TODO',
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
              leading: Image.asset(Utils.getImagePath('ic_todo'),
                  width: 24, height: 24, color: Theme.of(context).primaryColor),
              onTap: () {
                if (isLogin) {
                  Get.toNamed('/todo_page'); //去todo页面
                } else {
                  T.show('请先登录');
                  Get.toNamed('/login_page'); //去登录页面
                }
              },
            ),
            //C6
            ListTile(
              title: const Text('夜间模式',
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
              leading: Icon(
                Icons.brightness_2,
                size: 24,
                color: Theme.of(context).primaryColor,
              ),
              onTap: () {
                setState(() {
                  changeTheme();
                });
              },
            ),
            //C7
            ListTile(
              title: const Text('系统设置',
                  textAlign: TextAlign.left, style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.settings,
                  size: 24, color: Theme.of(context).primaryColor),
              onTap: () {
                Get.toNamed('/setting_page');
              },
            ),
            //C8
            Offstage(
              offstage: !isLogin,
              child: ListTile(
                title: const Text(
                  '退出登录',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16),
                ),
                leading: Icon(Icons.power_settings_new,
                    size: 24, color: Theme.of(context).primaryColor),
                onTap: () {
                  _logout(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onPopInvokedWithResult(bool, dynamic) async {
    Get.back();
    return true;
    // Get.snackbar('DrawerPage', 'onPopInvokedWithResult()');
  }

  /// 改变主题
  void changeTheme() async {
    ThemeUtils.dark = !ThemeUtils.dark;
    //储存主题状态
    SPUtil.putBool(CON.KEY_DARK, ThemeUtils.dark);
    //发送修改主题事件
    Application.eventBus?.fire(ThemeChangeEvent());
  }

  /// 退出登录
  void _logout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: const Text('确定退出登录吗?'),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      '取消',
                      style: TextStyle(color: CON.COLOR_TAGS),
                    )),
                TextButton(
                    onPressed: () {
                      apiService.logout((BaseModel model) {
                        if (model.errorCode == CON.CODE_SUCCESS) {
                          User.singleton.clearUserInfo();
                          setState(() {
                            isLogin = false;
                            username = '去登录';
                            level = '--';
                            rank = '--';
                            myScore = '';
                          });
                          T.show('已退出登录');
                        } else {
                          T.show('${model.errorMsg}');
                        }
                      }, (DioException error) {
                        print(error.response);
                      });
                      Get.back();
                    },
                    child: const Text(
                      '确定',
                      style: TextStyle(color: CON.COLOR_TAGS),
                    ))
              ],
            ));
  }

  /// 获取用户信息
  Future getUserInfo() async {
    apiService.getUserInfo((UserInfoModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        setState(() {
          level = (model.data!.coinCount! ~/ 100 + 1).toString();
          rank = model.data!.rank.toString() == 'null'
              ? '无'
              : model.data!.rank.toString();
          myScore = model.data!.coinCount.toString();
        });
      }
    }, (DioException error) {
      print(error);
    });
  }
}
