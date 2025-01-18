import 'package:flutter/material.dart';
import 'package:wan_andriod/utils/utils.dart';

abstract class BaseWidget extends StatefulWidget {
  const BaseWidget({super.key});

  // @override
  // State<name> createState() => _nameState();
  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return attachState();
  }

  //抽象类 子类去实现
  BaseWidgetState attachState();
}

// class _nameState extends State<name> {
abstract class BaseWidgetState<T extends BaseWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  /// 是否显示 导航栏
  bool _isShowAppBar = true;

  /// 是否显示 内容页
  bool _isShowContent = false;

  /// 是否显示 错误页
  bool _isShowError = false;
  String _errorImagePath = Utils.getImagePath('ic_error');
  String _errorMessage = '网络请求失败,请检查您的网络';

  /// 是否显示 加载中
  bool _isShowLoading = false;

  /// 是否显示 空页面
  bool _isShowEmpty = false;
  String _emptyImagepath = Utils.getImagePath('ic_empty');
  String _emptyMessage = "暂无数据";

  /// 错误页面和空页面的字体粗度
  final FontWeight _errorOrEmptyFontWidget = FontWeight.w600;

  ///是否保持页面缓存with AutomaticKeepAliveClientMixin
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: _attachBaseAppBar(),
      body: Stack(
        children: <Widget>[
          _attachBaseContentBuildWidget(context),
          _attachBaseErrorWidget(),
          _attachBaseLoadingBuildWidget(),
          _attachBaseEmptyWidget(),
        ],
      ),
      floatingActionButton: floatingActionButtonWidget(),
    );
  }

  //不能指定返回类型Widget,因为Widget不能返回null,子类想要悬浮按钮的话就重写这个方法
  floatingActionButtonWidget() {
    return null;
  }

  ///显示内容页面
  Future showContent() async {
    setState(() {
      _isShowContent = true;
      _isShowError = false;
      _isShowLoading = false;
      _isShowEmpty = false;
    });
  }

  ///显示错误页面
  Future showError() async {
    setState(() {
      _isShowContent = false;
      _isShowError = true;
      _isShowLoading = false;
      _isShowEmpty = false;
    });
  }

  ///显示加载页面
  Future showLoading() async {
    setState(() {
      _isShowContent = false;
      _isShowError = false;
      _isShowLoading = true;
      _isShowEmpty = false;
    });
  }

  ///显示空页面
  Future showEmpty() async {
    setState(() {
      _isShowContent = false;
      _isShowError = false;
      _isShowLoading = false;
      _isShowEmpty = true;
    });
  }

// Widget build(BuildContext context) {} 把内容页变成和错误页面,加载页面,空页面放一起,到时可以根据情况4个页面灵活显示其中一个.
  ///内容页面 嵌套一层Offstage来控制是否显示,内容给子类实现
  Widget _attachBaseContentBuildWidget(BuildContext context) {
    return Offstage(
      offstage: !_isShowContent,
      child: attachContentBuildWidget(context),
    );
  }

  ///内容Build页面 抽象类,让子类去实现
  Widget attachContentBuildWidget(BuildContext context);

  ///错误页面
  Widget _attachBaseErrorWidget() {
    return Offstage(
      offstage: !_isShowError,
      child: attachErrorWidget(),
    );
  }

  //错误页面,子类可以重写定制
  Widget attachErrorWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 80),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(_errorImagePath),
              width: 120,
              height: 120,
            ),
            Container(
              //和图片隔开20
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text(
                _errorMessage,
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: _errorOrEmptyFontWidget,
                ),
              ),
            ),
            //和错误信息文字隔开20
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: OutlinedButton(
                  onPressed: () => onPressedErrorButtonToReloading(),
                  child: Text(
                    '重新加载',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: _errorOrEmptyFontWidget),
                  )),
            )
          ],
        ),
      ),
    );
  }

  ///抽象类子类去实现 点击错误页面重新加载按钮后的操作
  void onPressedErrorButtonToReloading();

  /// 正在加载页面
  Widget _attachBaseLoadingBuildWidget() {
    return Offstage(
      offstage: !_isShowLoading,
      child: attachLoadingWidget(),
    );
  }

  ///实现加载页面的内容,也可以重写定制
  Widget attachLoadingWidget() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.0,
      ),
    );
  }

  ///数据为空页面
  Widget _attachBaseEmptyWidget() {
    return Offstage(
      offstage: !_isShowEmpty,
      child: attachEmptyWidget(),
    );
  }

  ///实现数据为空页面,子类也可以重写
  Widget attachEmptyWidget() {
    return Container(
      //子组件离bottom留100
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(_emptyImagepath),
                color: Colors.black12,
                width: 150,
                height: 150,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  _emptyMessage,
                  style: TextStyle(
                      color: Colors.grey, fontWeight: _errorOrEmptyFontWidget),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 导航栏 AppBar 嵌套一层Offstage来控制是否显示,内容给子类实现
  PreferredSizeWidget _attachBaseAppBar() {
    return PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Offstage(
          offstage: !_isShowAppBar,
          child: attachAppBar(),
        ));
  }

  /// 导航栏  AppBar 抽象类 让子类去实现
  AppBar attachAppBar();

  ///设置错误提示信息
  Future setErrorMessage(String errorMessage) async {
    if (errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }

  ///设置错误图片
  Future setErrorImage(String imagePath) async {
    if (imagePath.isNotEmpty) {
      setState(() {
        _errorImagePath = imagePath;
      });
    }
  }

  ///设置空页面提示信息
  Future setEmptyMessage(String emptyMessage) async {
    if (emptyMessage.isNotEmpty) {
      setState(() {
        _emptyMessage = emptyMessage;
      });
    }
  }

  ///设置空页面图片
  Future setEmptyImage(String imagePath) async {
    if (imagePath.isNotEmpty) {
      setState(() {
        _emptyImagepath = imagePath;
      });
    }
  }

  /// 设置导航栏显示或者隐藏
  Future setAppBarVisible(bool visible) async {
    setState(() {
      _isShowAppBar = visible;
    });
  }
}
