import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/widget/custom_cached_network_image.dart';
import 'package:wan_andriod/data/model/banner_model.dart';
import 'package:wan_andriod/data/model/article_model.dart';
import 'package:wan_andriod/widget/article_seed_list_tile.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/utils/route_util.dart';
import 'package:wan_andriod/widget/refresh_footer_widget.dart';

///首页
class HomePage extends BaseWidget {
  const HomePage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _HomePageState();
  }

  // @override
  // State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseWidgetState<HomePage> {
  ///首页轮播图数据
  List<BannerSeed> _bannerSeedList = [];

  ///首页文章列表数据
  // ignore: prefer_final_fields
  List<ArticleSeed> _articleSeedList = [];

  ///是否显示悬浮按钮
  bool _isShowFloatingActionButton = false;

  /// 页码，从0开始
  int _pageIndex = 0;

  ///刷新控制器
  late RefreshController _refreshController;

  ///ListView控制器
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    _scrollController = ScrollController();
    //不显示BaseWidget的AppBar因为Tabs已经显示tabbar了.不然就有两个appbar
    setAppBarVisible(false);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
    _scrollController.dispose();
  }

  @override
  void didChangeDependencies() {
    // initState后 build前调用 进行一些依赖注入的操作，或者当依赖发生变化时需要执行的逻辑
    super.didChangeDependencies();
    _bannerSeedList.clear();
    //显示加载页面后执行获取banner数据article数据
    //允许你在异步操作完成时执行特定的代码块 有一个异步操作（比如网络请求、文件读写等）正在进行，并且一旦这个操作完成并返回结果，.then后面的代码块就会被执行。在这个代码块中，你可以通过参数value来访问异步操作的结果。
    showLoading().then((value) {
      getBannerList();
      getTopArticleList();
    });

    ///监听ListView事件
    _scrollController.addListener(() {
      ///如果滑动到底部,加载更多
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //getMoreArticleList()
      }
      if (_scrollController.offset < 200 && _isShowFloatingActionButton) {
        //如果偏移小于200且显示FAB,那就不显示
        setState(() {
          _isShowFloatingActionButton = false;
        });
      } else if (_scrollController.offset >= 200 &&
          !_isShowFloatingActionButton) {
        //如果偏移大于200且不显示FAB,那就显示
        setState(() {
          _isShowFloatingActionButton = true;
        });
      }
    });
  }

  ///实现抽象类的内容页
  @override
  Widget attachContentBuildWidget(BuildContext context) {
    return Scaffold(
      //刷新插件
      body: SmartRefresher(
        //激活下拉刷新
        enablePullDown: true,
        //激活上滑加载
        enablePullUp: true,
        //头部刷新方式
        header: const MaterialClassicHeader(),
        //尾部加载方式
        footer: RefreshFooterWidget.customFooter(),
        //控制器
        controller: _refreshController,
        //下拉刷新触发事件
        onRefresh: getTopArticleList,
        //上滑加载触发事件
        onLoading: getMoreArticleList,

        child: ListView.builder(
          // AlwaysScrollableScrollPhysics 是 Flutter 框架中的一个预定义的滚动物理类。它允许滚动视图始终响应用户的滚动手势，无论内容是否已经滚动到边界。这意味着，即使滚动视图的内容不足以填满整个视口，用户仍然可以继续拖动滚动条，或者通过编程方式滚动视图。
          // ‌始终可滚动‌：与默认的滚动物理行为不同，AlwaysScrollableScrollPhysics 不会在内容未超出视口范围时阻止滚动。
          // ‌适用场景‌：适用于需要用户能够无限制地拖动滚动的情况，如聊天界面、地图应用等。
          // physics: const AlwaysScrollableScrollPhysics(),
          physics: const BouncingScrollPhysics(),
          //ListView的控制器scrollController
          controller: _scrollController,
          //项目类就是文章的数量加一个Banner
          itemCount: _articleSeedList.length + 1,
          //抽离ListView中的每一行的视图方法
          itemBuilder: _listViewItemBuilder,
        ),
      ),
      floatingActionButton: !_isShowFloatingActionButton
          ? null
          : FloatingActionButton(
              heroTag: 'home',
              onPressed: () {
                /// 回到顶部时要执行的动画,上面监听了列表的位置,超出200就会显示FAB
                _scrollController.animateTo(0,
                    duration: const Duration(milliseconds: 2000),
                    curve: Curves.ease);
              },
              child: const Icon(Icons.arrow_upward),
            ),
    );
  }

  /// 获取轮播数据
  Future getBannerList() async {
    //apiService被类ApiService直接初始化了
    apiService.getBannerList((BannerModel bannerData) {
      if (bannerData.data != null) {
        if (bannerData.data!.isNotEmpty) {
          setState(() {
            _bannerSeedList = bannerData.data!;
          });
        }
      }
    });
  }

  ///获取置顶文章数据
  Future getTopArticleList() async {
    apiService.getTopArticleList((TopArticleModel topArticleModel) {
      if (topArticleModel.errorCode == CON.CODE_SUCCESS) {
        topArticleModel.data?.forEach((v) {
          v.top = 1;
        });
        _articleSeedList.clear();
        _articleSeedList.addAll(topArticleModel.data ?? []);
      }
      //获取文章列表
      getArticleList();
    }, (error) {
      showError();
    });
  }

  /// 获取文章列表数据
  Future getArticleList() async {
    _pageIndex = 0; //这里获取的列表要显示在置顶文章之后,所以要重设索引为0
    apiService.getArticleList((ArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          showContent().then((onValue) {
            // 数据加载完成的逻辑中直接调用,并在调用之后更新 UI 或执行其他操作。
            _refreshController.refreshCompleted(resetFooterState: true);
            setState(() {
              _articleSeedList.addAll(model.data?.datas ?? []);
            });
          });
        } else {
          showEmpty();
        }
      } else {
        showError();
        T.show('${model.errorMsg}');
      }
    }, (error) => showError(), _pageIndex);
  }

  ///获取更多文章列表数据
  Future getMoreArticleList() async {
    _pageIndex++;
    apiService.getArticleList((ArticleModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        if (model.data!.datas!.isNotEmpty) {
          _refreshController.loadComplete(); //加载完成
          setState(() {
            _articleSeedList.addAll(model.data?.datas ?? []);
          });
        } else {
          _refreshController.loadNoData(); //加载完成 没有数据了
        }
      } else {
        _refreshController.loadFailed(); //加载失败
        T.show('${model.errorMsg}');
      }
    }, () {
      _refreshController.loadFailed(); //加载失败
    }, _pageIndex);
  }

  /// ListView中每一行的视图
  Widget? _listViewItemBuilder(BuildContext context, int index) {
    //第一个位置给轮播
    if (index == 0) {
      return Container(
        //高度200
        height: 200,
        //背景透明
        color: Colors.transparent,
        //去实现轮播图
        child: _buildBannerWidget(),
      );
    }
    //index大于0的位置给文章 index 1的位置是articleSeedList的index 0 所以要减1
    ArticleSeed articleSeed = _articleSeedList[index - 1];
    return ArticleSeedListTile(articleSeed: articleSeed);
  }

  /// 构建轮播图
  Widget _buildBannerWidget() {
    return Offstage(
      //如果bannerList是空的,就不显示Swiper轮播图
      offstage: _bannerSeedList.isEmpty,
      child: Swiper(
        //图片数
        itemCount: _bannerSeedList.length,
        //是否自动轮播
        autoplay: true,
        //页码显示方式(...)
        pagination: const SwiperPagination(),
        itemBuilder: _swiperItemBuilder,
      ),
    );
  }

  ///轮播图项目构建
  Widget _swiperItemBuilder(BuildContext context, int index) {
    //如果轮播图没数据,就不显示(给一个高度0的Container)
    //index >= bannerList.length这个判断感觉也不会出发,bannerList.length永远大于index  如果长度3 index是0 1 2  如果是0 就不会itemBuilder index为0的项目
    if (index >= _bannerSeedList.length ||
        // bannerList[index] == null || 系统说不可能为空
        _bannerSeedList[index].imagePath == null) {
      //如果图片地址是空的,就返回一个SizedBox(height:0)
      return const SizedBox(
        height: 0,
      );
    } else {
      //自定义缓存Image 加 水墨点击事件
      return InkWell(
        onTap: () {
          RouteUtil.toWebView(_bannerSeedList[index].title ?? '',
              _bannerSeedList[index].url ?? '');
        },
        child: CustomCachedNetworkImage(
          //imagePath如果为空,则给''
          imageUrl: _bannerSeedList[index].imagePath ?? '',
        ),
      );
    }
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      title: const Text(''),
    );
  }

  @override
  void onPressedErrorButtonToReloading() {
    showLoading().then((value) {
      getBannerList();
      getTopArticleList();
    });
  }
}
