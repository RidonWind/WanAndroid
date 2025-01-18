import 'package:dio/dio.dart';
import 'package:wan_andriod/data/model/base_model.dart';
import 'package:wan_andriod/data/model/collect_model.dart';
import 'package:wan_andriod/data/model/knowledge_detail_model.dart';
import 'package:wan_andriod/data/model/knowledge_tree_model.dart';
import 'package:wan_andriod/data/model/navigation_model.dart';
import 'package:wan_andriod/data/model/project_article_model.dart';
import 'package:wan_andriod/data/model/project_tree_model.dart';
import 'package:wan_andriod/data/model/rank_model.dart';
import 'package:wan_andriod/data/model/share_article_model.dart';
import 'package:wan_andriod/data/model/todo_model.dart';
import 'package:wan_andriod/data/model/user_info_model.dart';
import 'package:wan_andriod/data/model/user_model.dart';
import 'package:wan_andriod/data/model/user_score_model.dart';
import 'package:wan_andriod/data/model/wechat_article_model.dart';
import 'package:wan_andriod/data/model/wechat_model.dart';
import 'package:wan_andriod/net/dio_manager.dart';
import 'package:wan_andriod/data/api/apis.dart';
import 'package:wan_andriod/data/model/banner_model.dart';
import 'package:wan_andriod/data/model/article_model.dart';
import 'package:wan_andriod/data/model/hot_word_model.dart';

//引用类直接使用apiService
ApiService _apiService = ApiService();
ApiService get apiService => _apiService;

class ApiService {
  ///  获取首页轮播数据
  /// https://www.wanandroid.com/banner/json
  /// 方法：GET 参数：无
  void getBannerList(Function callback) async {
    dio.get(Apis.HOME_BANNER).then((onValue) {
      //获取到的数据返回给调用方
      callback(BannerModel.fromJson(onValue.data));
    });
  }

  ///获取置顶文章数据 返回数据回调函数,有错误的话加上错误信息回调函数
  ///https://www.wanandroid.com/article/top/json 方法：GET 参数：无
  void getTopArticleList(Function callback, Function errorCallback) async {
    dio.get(Apis.HOME_TOP_ARTICLE_LIST).then((onValue) {
      callback(TopArticleModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取首页文章列表数据
  /// https://www.wanandroid.com/article/list/0/json
  /// 方法：GET 参数：页码，拼接在链接中，从0开始。
  void getArticleList(
      Function callback, Function errorCallback, int page) async {
    dio.get('${Apis.HOME_ARTICLE_LIST}/$page/json').then((onValue) {
      callback(ArticleModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取搜索热词列表数据
  /// https://www.wanandroid.com//hotkey/json
  /// 方法：GET 参数：无
  void getHotWordSeedList(Function callback, Function errorCallback) async {
    dio.get(Apis.HOT_WORD_LIST).then((onValue) {
      callback(HotWordModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取搜索的文章列表
  /// https://www.wanandroid.com/article/query/0/json
  /// 方法：POST 页码：拼接在链接上，从0开始。 k ： 搜索关键词
  void getSearchArticleList(Function callback, Function errorCallback,
      int pageIndex, String keyword) async {
    FormData formData = FormData.fromMap({'k': keyword});
    dio
        .post('${Apis.SEARCH_ARTICLE_LIST}/$pageIndex/json', data: formData)
        .then((onValue) {
      callback(ArticleModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///登录
  ///https://www.wanandroid.com/user/login
  ///方法：POST 参数：	username，password
  ///登录后会在cookie中返回账号密码，只要在客户端做cookie持久化存储即可自动登录验证。
  void login(Function callback, Function errorCallback, String username,
      String password) async {
    FormData formData =
        FormData.fromMap({'username': username, 'password': password});
    dio.post(Apis.USER_LOGIN, data: formData).then((onValue) {
      callback(UserModel.fromJson(onValue.data), onValue);
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///注册
  ///https://www.wanandroid.com/user/register
  ///方法：POST 参数 username,password,repassword
  void register(Function callback, Function errorCallback, String username,
      String password) async {
    FormData formData = FormData.fromMap(
        {'username': username, 'password': password, 'repassword': password});
    dio.post(Apis.USER_REGISTER, data: formData).then((onValue) {
      callback(UserModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///获取个人积分，需要登录后访问
  ///https://www.wanandroid.com/lg/coin/userinfo/json 方法：GET
  void getUserInfo(Function callback, Function errorCallback) async {
    dio.get(Apis.USER_INFO).then((onValue) {
      callback(UserInfoModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///退出登录
  ///https://www.wanandroid.com/user/logout/json 方法：GET
  ///访问了 logout 后，服务端会让客户端清除 Cookie（即cookie max-Age=0），如果客户端 Cookie 实现合理，可以实现自动清理，如果本地做了用户账号密码和保存，及时清理。
  void logout(Function callback, Function errorCallBack) async {
    dio.get(Apis.USER_LOGOUT).then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallBack(onError);
    });
  }

  ///取消收藏
  ///https://www.wanandroid.com/lg/uncollect_originId/2333/json
  ///方法：POST 参数：	id:拼接在链接上
  void cancelCollect(Function callback, Function errorCallback, int id) async {
    dio.post('${Apis.CANCEL_COLLECT}/$id/json').then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 新增收藏(收藏站内文章)
  /// https://www.wanandroid.com/lg/collect/1165/json
  /// 方法：POST 参数： 文章id，拼接在链接中。
  void addCollect(Function callback, Function errorCallback, int id) async {
    dio.post('${Apis.ADD_COLLECT}/$id/json').then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取广场列表数据
  /// https://wanandroid.com/user_article/list/页码/json
  /// GET请求 页码拼接在url上从0开始
  void getSquareList(
      Function callback, Function errorCallback, int pageIndex) async {
    dio.get('${Apis.SQUARE_LIST}/$pageIndex/json').then((onValue) {
      callback(ArticleModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///获取微信公众号列表
  ///https://wanandroid.com/wxarticle/chapters/json
  ///方法： GET
  void getWeChatChapterSeedList(
      Function callback, Function errorCallback) async {
    dio.get(Apis.WECHAT_CHAPTER_LIST).then((onValue) {
      callback(WechatModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///查看某个公众号文章列表数据
  ///https://wanandroid.com/wxarticle/list/408/1/json
  ///方法：GET 参数：	公众号 ID：拼接在 url 中，eg:405  	公众号页码：拼接在url 中，eg:1(1开始)
  void getWechatArticleSeedList(
      Function callback, Function errorCallback, int id, int page) async {
    dio.get('${Apis.WECHAT_ARTICLE_LIST}/$id/$page/json').then((onValue) {
      callback(WechatArticleModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取知识体系树数据
  /// https://www.wanandroid.com/tree/json
  /// 方法：GET 参数：无
  void getKnowledgeTreeSeedList(
      Function callback, Function errorCallback) async {
    dio.get(Apis.KNOWLEDGE_TREE_LIST).then((onValue) {
      callback(KnowledgeTreeModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取知识体系详情数据
  /// https://www.wanandroid.com/article/list/0/json?cid=60
  /// 方法：GET 参数：cid 分类的id，上述二级目录的id 页码：拼接在链接上，从0开始。
  void getKnowledgeDetailList(
      Function callback, Function errorCallback, int pageIndex, int id) async {
    dio
        .get('${Apis.KNOWLEDGE_DETAIL_LIST}/$pageIndex/json?cid=$id')
        .then((onValue) {
      callback(KnowledgeDetailModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取导航列表数据
  /// https://www.wanandroid.com/navi/json
  /// 方法：GET 参数：无
  void getNavigationSeedList(Function callback, Function errorCallback) async {
    dio.get(Apis.NAVIGATION_LIST).then((onValue) {
      callback(NavigationModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取项目分类列表数据
  /// https://www.wanandroid.com/project/tree/json
  /// 方法： GET 参数： 无
  void getProjectTreeSeedList(Function callback, Function errorCallback) {
    dio.get(Apis.PROJECT_TREE_LIST).then((onValue) {
      callback(ProjectTreeModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取项目文章列表数据
  /// https://www.wanandroid.com/project/list/1/json?cid=294
  /// 方法：GET 参数：	cid 分类的id，上面项目分类接口 	页码：拼接在链接中，从1开始。
  void getProjectArticleSeedList(
      Function callback, Function errorCallback, int id, int pageIndex) {
    dio
        .get('${Apis.PROJECT_ARTICLE_LIST}/$pageIndex/json?cid=$id')
        .then((onValue) {
      callback(ProjectArticleListModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  ///获取收藏列表
  ///https://www.wanandroid.com/lg/collect/list/0/json
  ///方法：GET 参数： 页码：拼接在链接中，从0开始。
  void getCollectSeedList(
      Function callback, Function errorCallback, int pageIndex) async {
    dio.get('${Apis.COLLECTION_LIST}/$pageIndex/json').then((onValue) {
      callback(CollectModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 分享文章
  ///https://www.wanandroid.com/lg/user_article/add/json
  ///请求：POST  参数： title: link
  void shareArticle(Function callback, Function errorCallback, String title,
      String link) async {
    Map<String, dynamic> queryParameters = {'title': title, 'link': link};
    dio
        .post(Apis.SHARE_ARTICLE_ADD, queryParameters: queryParameters)
        .then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取我的积分列表数据
  /// https://www.wanandroid.com//lg/coin/list/1/json
  /// 方法：GET 参数： 页码：拼接在链接中，从1开始。
  void getUserScoreSeedList(
      Function callback, Function errorCallback, int pageIndex) async {
    dio.get('${Apis.USER_SCORE_LIST}/$pageIndex/json').then((onValue) {
      callback(UserScoreModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取我的分享列表数据
  /// https://wanandroid.com/user/lg/private_articles/1/json
  /// 方法：GET 参数：	页码，从1开始
  void getShareArticleSeedList(
      Function callback, Function errorCallback, int pageIndex) async {
    dio.get('${Apis.SHARE_LIST}/$pageIndex/json').then((onValue) {
      callback(ShareArticleModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 删除已分享的文章
  void deleteShareArticle(
      Function callback, Function errorCallback, int id) async {
    dio.post('${Apis.DELETE_SHARE_ARTICLE}/$id/json').then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((e) {
      errorCallback(e);
    });
  }

  /// 获取未完成TODO列表
  /// https://www.wanandroid.com/lg/todo/v2/list/页码/json
  // 页码从1开始，拼接在url 上
  // status 状态， 1-完成；0未完成; 默认全部展示；
  // type 创建时传入的类型, 默认全部展示
  // priority 创建时传入的优先级；默认全部展示
  // orderby 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
  // https://www.wanandroid.com/lg/todo/v2/list/1/json
  // 所有的 'TODO 按照创建的时间，倒序展示；
  // https://www.wanandroid.com/lg/todo/v2/list/1/json?status=0
  // 未完成的 'TODO 按照创建的时间，倒序展示；
  // https://www.wanandroid.com/lg/todo/v2/list/1/json?status=1&orderby=2
  // 以完成的 'TODO 按照完成的时间，倒序展示；
  void getNoTodoList(
      Function callback, Function errorCallback, int todoType, int page) async {
    dio
        .post('${Apis.NO_TODO_LIST}/$page/json?status=0&type=$todoType')
        .then((onValue) {
      callback(TodoModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 仅更新完成状态Todo,未完成 到 已完成
  /// https://www.wanandroid.com/lg/todo/done/80/json
  /// 方法：POST 参数：	id: 拼接在链接上，为唯一标识 	status: 0或1，传1代表未完成到已完成，反之则反之。
  void updateTodoState(Function callback, Function errorCallback, int id,
      Map<String, int> params) async {
    dio
        .post('${Apis.UPDATE_TODO_STATE}/$id/json', queryParameters: params)
        .then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 根据ID删除TODO
  /// https://www.wanandroid.com/lg/todo/delete/83/json
  /// 方法：POST 参数：	id: 拼接在链接上，为唯一标识
  void deleteTodoById(Function(BaseModel model) callback,
      Function(DioException error) errorCallback, int id) async {
    dio.post('${Apis.DELETE_TODO_BY_ID}/$id/json').then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 新增一个TODO
  ///https://www.wanandroid.com/lg/todo/add/json
  ///方法：POST
  ///参数：title: 新增标题（必须）content: 新增详情（必须）date: 2018-08-01 预定完成时间（不传默认当天，建议传）
  ///type: 大于0的整数（可选）；priority 大于0的整数（可选）；
  void addTodo(
      Function(BaseModel model) callback,
      Function(DioException error) errorCallback,
      Map<String, dynamic> params) async {
    dio.post(Apis.ADD_TODO, queryParameters: params).then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 根据ID更新TODO
  /// https://www.wanandroid.com/lg/todo/update/83/json
  /// 方法：POST
  /// 参数：id: 拼接在链接上，为唯一标识，列表数据返回时，每个todo 都会有个id标识 （必须）title: 更新标题 （必须）
  /// content: 新增详情（必须）date: 2018-08-01（必须）status: 0 // 0为未完成，1为完成	type: ；priority: ；
  void updateTodo(
      Function(BaseModel model) callback,
      Function(DioException error) errorCallback,
      int id,
      Map<String, dynamic> params) async {
    dio
        .post('${Apis.UPDATE_TODO}/$id/json', queryParameters: params)
        .then((onValue) {
      callback(BaseModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取已完成TODO列表
  /// https://www.wanandroid.com/lg/todo/v2/list/页码/json
  // 页码从1开始，拼接在url 上
  // status 状态， 1-完成；0未完成; 默认全部展示；
  // type 创建时传入的类型, 默认全部展示
  // priority 创建时传入的优先级；默认全部展示
  // orderby 1:完成日期顺序；2.完成日期逆序；3.创建日期顺序；4.创建日期逆序(默认)；
  // https://www.wanandroid.com/lg/todo/v2/list/1/json
  // 所有的 'TODO 按照创建的时间，倒序展示；
  // https://www.wanandroid.com/lg/todo/v2/list/1/json?status=0
  // 未完成的 'TODO 按照创建的时间，倒序展示；
  // https://www.wanandroid.com/lg/todo/v2/list/1/json?status=1&orderby=2
  // 以完成的 'TODO 按照完成的时间，倒序展示；
  void getDoneTodoList(
      Function(TodoModel model) callback,
      Function(DioException error) errorCallback,
      int todoType,
      int page) async {
    dio
        .post(
            '${Apis.DONE_TODO_LIST}/$page/json?status=1&orderby=2&type=$todoType')
        .then((onValue) {
      callback(TodoModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }

  /// 获取积分排行榜列表
  /// https://www.wanandroid.com/coin/rank/1/json
  void getRankList(Function(RankModel model) callback,
      Function(DioException error) errorCallback, int page) async {
    dio.get('${Apis.RANK_LIST}/$page/json').then((onValue) {
      callback(RankModel.fromJson(onValue.data));
    }).catchError((onError) {
      errorCallback(onError);
    });
  }
}
