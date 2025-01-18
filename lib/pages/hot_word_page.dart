import 'package:flutter/material.dart';
import 'package:wan_andriod/common/common.dart';
import 'package:wan_andriod/data/api/api_service.dart';
import 'package:wan_andriod/pages/base_widget.dart';
import 'package:wan_andriod/data/model/hot_word_model.dart';
import 'package:wan_andriod/data/model/history_seed.dart';
import 'package:wan_andriod/utils/toast_util.dart';
import 'package:wan_andriod/utils/color_util.dart';
import 'package:wan_andriod/utils/db_util.dart';
import 'package:get/get.dart';

class HotWordPage extends BaseWidget {
  const HotWordPage({super.key});

  @override
  BaseWidgetState<BaseWidget> attachState() {
    return _HotWordPageState();
  }
}

class _HotWordPageState extends BaseWidgetState<HotWordPage> {
  late final TextEditingController editingController;
  FocusNode focusNode = FocusNode();
  List<Widget> actions = <Widget>[].obs;
  //搜索关键词
  String keyword = "";
  // ignore: prefer_final_fields
  RxList _hotWordSeedList = [].obs;
  // ignore: prefer_final_fields
  RxList _historySeedList = [].obs;
  RxBool isShowCloseIcon = false.obs;
  DatabaseUtil db = DatabaseUtil();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    showLoading();
    getHotWordSeedList();
    getHistorySeedList();

    editingController = TextEditingController(text: keyword);
    editingController.addListener(() {
      if (editingController.text == '') {
        isShowCloseIcon.value = false;
      } else {
        isShowCloseIcon.value = true;
      }
    });
  }

  @override
  AppBar attachAppBar() {
    return AppBar(
      elevation: 0.4,
      title: TextField(
        autofocus: false,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            hintText: '发现更多干货'),
        //焦点
        focusNode: focusNode,
        controller: editingController,
      ),
      actions: [
        //控制close图标是否显示
        Obx(() => Offstage(
              offstage: !isShowCloseIcon.value,
              child: IconButton(
                  onPressed: () {
                    editingController.clear();
                    textChanged();
                  },
                  icon: const Icon(Icons.close)),
            )),
        IconButton(
            onPressed: () {
              textChanged();
            },
            icon: const Icon(Icons.search)),
      ],
    );
  }

  @override
  Widget attachContentBuildWidget(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        // FocusScope.of(context).requestFocus(FocusNode());
        focusNode.unfocus();
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: contentView(_hotWordSeedList.toList()),
      ),
    );
  }

  Widget contentView(List<dynamic> list) {
    List<Widget> hotWordWidgetList = [];
    for (HotWordSeed seed in list) {
      hotWordWidgetList.add(InkWell(
        child: Chip(
          //变更紧密
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          label: Text(
            seed.name!,
            style: TextStyle(
                fontSize: 14,
                color: ColorUtil.randomColor(),
                fontStyle: FontStyle.italic),
          ),
          labelPadding: const EdgeInsets.only(left: 3, right: 3),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        onTap: () {
          saveHistory(seed.name!).then((onValue) {
            Get.toNamed('/search_result_page', arguments: seed.name);
          });
        },
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        //第一行
        const Padding(
          //子组件距离外框左右16 上下8
          padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Text(
            '热门搜索',
            style: TextStyle(fontSize: 16, color: CON.COLOR_TAGS),
          ),
        ),
        //第二行
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Wrap(
            spacing: 10,
            runSpacing: 4,
            alignment: WrapAlignment.start,
            children: hotWordWidgetList,
          ),
        ),
        //第三行
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Row(
            children: <Widget>[
              // 第三行第一个 占满剩余空间
              const Expanded(
                  child: Text(
                '搜索历史',
                style: TextStyle(fontSize: 16, color: CON.COLOR_TAGS),
              )),
              InkWell(
                child: Text(
                  '清空',
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                onTap: () {
                  db.clear();
                  _historySeedList.clear();
                },
              )
            ],
          ),
        ),
        //第四行
        Obx(() => ListView.builder(
              itemBuilder: historyItemBuilder,
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              //SingleChildScrollView包裹了ListView,想要listView滚动,要把listView设置为不能滚动
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _historySeedList.length,
            ))
      ],
    );
  }

  Widget historyItemBuilder(BuildContext context, int index) {
    HistorySeed seed = _historySeedList[index];

    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.fromLTRB(0, 6, 0, 6),
          child: Row(
            children: <Widget>[
              //历史占剩余空间
              Expanded(
                  child: InkWell(
                onTap: () {
                  Get.toNamed('/search_result_page', arguments: seed.name);
                },
                child: Text(
                  seed.name,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              )),
              //右边一个删除按钮
              InkWell(
                onTap: () {
                  db.deleteById(seed.id!);
                  _historySeedList.removeAt(index);
                },
                //删除按钮
                child: Icon(
                  Icons.close,
                  color: Colors.grey[600],
                  size: 22,
                ),
              )
            ],
          ),
        ),
        const Divider(height: 1)
      ],
    );
  }

  /// 获取搜索热词
  Future getHotWordSeedList() async {
    apiService.getHotWordSeedList((HotWordModel model) {
      if (model.errorCode == CON.CODE_SUCCESS) {
        showContent();
        _hotWordSeedList.clear();
        _hotWordSeedList.addAll(model.data!);
      } else {
        showError();
        T.show('${model.errorMsg}');
      }
    }, (error) {
      showError();
    });
  }

  @override
  void onPressedErrorButtonToReloading() {
    //点错误页面重新加载按钮
    showLoading();
    getHotWordSeedList();
  }

  //按了搜索按钮或删除按钮才到这里
  void textChanged() {
    //输入框不显示焦点
    focusNode.unfocus();
    if (editingController.text == '') {
      //没内容不搜索
    } else {
      //如果有内容要搜索,先保存记录,再执行搜索页面
      saveHistory(editingController.text).then((onValue) {
        Get.toNamed('/search_result_page', arguments: editingController.text);
      });
    }
  }

  //保存历史记录
  Future saveHistory(String text) async {
    int id = -1;
    for (HistorySeed seed in _historySeedList) {
      //遍历历史记录,如果历史记录里有词和输入内容一致
      if (seed.name == text) {
        //那_id就是历史记录里的id
        id = seed.id ?? -1;
      }
    }
    //如果_id发生改变,那就肯定有重复,先在数据库里删除这个id,再重新添加到数据库第一位
    if (id != -1) {
      await db.deleteById(id);
    }
    //没有重复就直接添加新数据
    HistorySeed seed = HistorySeed();
    seed.name = text;
    await db.insertItem(seed);
    await getHistorySeedList();
  }

  /// 获取历史搜索记录
  Future getHistorySeedList() async {
    List<dynamic> list = await db.queryList();
    _historySeedList.clear();
    _historySeedList.addAll(HistorySeed.fromMapList(list));
    //把顺序反一下
    _historySeedList.value = _historySeedList.reversed.toList();
  }
}
