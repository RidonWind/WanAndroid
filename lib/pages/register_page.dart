import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/data/model/user_model.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/widget/loading_dialog.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _rePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        //触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('注册'),
          elevation: 0.4,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                //c1
                const SizedBox(height: 20),
                //c2
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '注册用户',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                //c3
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    '用户注册后才可以登录!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                //c4
                TextField(
                    autofocus: false,
                    controller: _usernameController,
                    decoration: const InputDecoration(
                        labelText: '用户名',
                        hintText: '请输入用户名',
                        labelStyle: TextStyle(color: CON.COLOR_TAGS)),
                    maxLines: 1),
                //c5
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                      labelText: '密码',
                      hintText: '请输入密码',
                      labelStyle: TextStyle(color: CON.COLOR_TAGS)),
                  obscureText: true,
                  maxLines: 1,
                ),
                //c6
                TextField(
                  controller: _rePasswordController,
                  decoration: const InputDecoration(
                      labelText: '再次输入密码',
                      hintText: '请再次输入密码',
                      labelStyle: TextStyle(color: CON.COLOR_TAGS)),
                  obscureText: true,
                  maxLines: 1,
                ),
                //c7
                Padding(
                  padding: const EdgeInsets.only(top: 28),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          _register();
                        },
                        style: ButtonStyle(
                            elevation: const WidgetStatePropertyAll(0.4),
                            backgroundColor: WidgetStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        child: const Text(
                          '注册',
                          style: TextStyle(color: Colors.white),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String rePassword = _rePasswordController.text;
    if (password != rePassword) {
      T.show('两次密码输入不一致!');
    } else {
      _showLoading(context);
      apiService.register((UserModel model) {
        _dismissLoading(context);
        if (model.errorCode == 0) {
          T.show('注册成功!');
          var map = {'username': username, 'password': password};
          Get.back(result: jsonEncode(map));
        } else {
          T.show('${model.errorMsg}');
        }
      }, (DioException error) {
        _dismissLoading(context);
        print('错误信息:${error.response}');
      }, username, password);
    }
  }

  /// 显示Loading
  void _showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return LoadingDialog(
          loadingText: '正在注册...',
          outsideDismiss: false,
        );
      },
    );
  }

  /// 隐藏Loading
  void _dismissLoading(BuildContext context) {
    Get.back();
  }
}
