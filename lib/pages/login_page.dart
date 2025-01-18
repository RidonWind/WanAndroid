import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as d;
import 'package:get/get.dart';
import 'package:wan_andriod/common/application.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/common/user.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/user_model.dart';
import 'package:wan_andriod/event/login_event.dart';
import 'package:wan_andriod/pages/register_page.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/loading_dialog.dart';
// import 'package:keyboard_actions/keyboard_actions.dart';

/// 登录页面
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  /*键盘事件之后再研究 应该是有下一个按钮与关闭按钮
  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _usernameFocusNode,
        ),
        KeyboardActionsItem(
          focusNode: _passwordFocusNode,
          // closeWidget: Padding(
          //   padding: EdgeInsets.all(8.0),
          //   child: Icon(Icons.close),
          // ),
        ),
      ],
    );
  }   */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('登录'),
          elevation: 0.4,
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                //c1
                const SizedBox(
                  height: 20,
                ),
                //c2
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '用户登录',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                //c3
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '请使用WanAndroid账号登录',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                //c4
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: TextField(
                    focusNode: _usernameFocusNode,
                    autofocus: false,
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        labelText: '用户名',
                        hintText: '请输入用户名',
                        labelStyle: TextStyle(color: CON.COLOR_TAGS)),
                    maxLines: 1,
                  ),
                ),
                //c5
                Padding(
                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                  child: TextField(
                      focusNode: _passwordFocusNode,
                      controller: _passwordController,
                      decoration: const InputDecoration(
                          labelText: '密码',
                          labelStyle: TextStyle(color: CON.COLOR_TAGS),
                          hintText: '请输入密码'),
                      obscureText: true,
                      maxLines: 1),
                ),
                //C6 登录按钮
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Row(
                    children: [
                      //c6r1
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          String username = _usernameController.text;
                          String password = _passwordController.text;
                          _login(username, password);
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor),
                            foregroundColor:
                                const WidgetStatePropertyAll(Colors.white),
                            elevation: const WidgetStatePropertyAll(0.5)),
                        child: const Text('登录'),
                      ))
                    ],
                  ),
                ),
                //c7 注册按钮
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        registerOnTap();
                      },
                      child: const Text(
                        '还没有账号,注册一个?',
                        style: TextStyle(fontSize: 14),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _login(String username, String password) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      _showLoading(context);
      apiService.login((UserModel model, d.Response response) {
        _dismissLoading(context);
        if (model.errorCode == CON.CODE_SUCCESS) {
          //登录成功后保存用户信息和cookie
          User().saveUserInfo(model, response);
          //发送登录成功事件
          Application.eventBus?.fire(LoginEvent());
          T.show('登录成功');
          Get.back();
        } else {
          T.show('${model.errorMsg}');
        }
      }, () {}, username, password);
    } else {
      T.show('用户名或密码不能为空');
    }
  }

  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const LoadingDialog(
            outsideDismiss: false, loadingText: '正在登录...');
      },
    );
  }

  void registerOnTap() async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return const RegisterPage();
    })).then((onValue) {
      //从注册页面返回时执行下面代码
      var map = jsonDecode(onValue);
      var username = map['username'];
      var password = map['password'];
      _usernameController.text = username;
      _passwordController.text = password;
      _login(username, password);
    });
  }

  /// 隐藏Loading
  void _dismissLoading(BuildContext context) {
    Get.back();
  }
}
