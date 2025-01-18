import 'package:dio/dio.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/model/user_model.dart';
import 'package:wan_andriod/utils/sp_util.dart';

class User {
  static final User singleton = User._internal();
  factory User() {
    return singleton;
  }
  User._internal();

  List<String>? cookie;
  String? username;

  void saveUserInfo(UserModel model, Response response) {
    List<String>? cookies = response.headers['set-cookie'];
    cookie = cookies;
    username = model.data?.username;
    saveInfo();
  }

  Future<Null> getUserInfo() async {
    List<String>? cookies = SPUtil.getStringList(CON.KEY_COOKIES);
    if (cookies != const []) {
      cookie = cookies;
    }

    String username1 = SPUtil.getString(CON.KEY_USERNAME);
    if (username1 != '') {
      username = username1;
    }
  }

  void saveInfo() async {
    SPUtil.putStringList(CON.KEY_COOKIES, cookie ??= []);
    SPUtil.putString(CON.KEY_USERNAME, username ??= '获取用户名失败');
  }

  void clearUserInfo() async {
    cookie = null;
    username = null;
    SPUtil.remove(CON.KEY_COOKIES);
    SPUtil.remove(CON.KEY_USERNAME);
  }
}
