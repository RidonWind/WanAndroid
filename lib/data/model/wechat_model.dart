class WechatModel {
  List<WechatSeed>? data;
  int? errorCode;
  String? errorMsg;

  WechatModel({this.data, this.errorCode, this.errorMsg});

  WechatModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => WechatSeed.fromJson(e)).toList();
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<WechatModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(WechatModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    _data["errorCode"] = errorCode;
    _data["errorMsg"] = errorMsg;
    return _data;
  }
}

class WechatSeed {
  List<dynamic>? articleList;
  String? author;
  List<dynamic>? children;
  int? courseId;
  String? cover;
  String? desc;
  int? id;
  String? lisense;
  String? lisenseLink;
  String? name;
  int? order;
  int? parentChapterId;
  int? type;
  bool? userControlSetTop;
  int? visible;

  WechatSeed(
      {this.articleList,
      this.author,
      this.children,
      this.courseId,
      this.cover,
      this.desc,
      this.id,
      this.lisense,
      this.lisenseLink,
      this.name,
      this.order,
      this.parentChapterId,
      this.type,
      this.userControlSetTop,
      this.visible});

  WechatSeed.fromJson(Map<String, dynamic> json) {
    if (json["articleList"] is List) {
      articleList = json["articleList"] ?? [];
    }
    if (json["author"] is String) {
      author = json["author"];
    }
    if (json["children"] is List) {
      children = json["children"] ?? [];
    }
    if (json["courseId"] is int) {
      courseId = json["courseId"];
    }
    if (json["cover"] is String) {
      cover = json["cover"];
    }
    if (json["desc"] is String) {
      desc = json["desc"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["lisense"] is String) {
      lisense = json["lisense"];
    }
    if (json["lisenseLink"] is String) {
      lisenseLink = json["lisenseLink"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["order"] is int) {
      order = json["order"];
    }
    if (json["parentChapterId"] is int) {
      parentChapterId = json["parentChapterId"];
    }
    if (json["type"] is int) {
      type = json["type"];
    }
    if (json["userControlSetTop"] is bool) {
      userControlSetTop = json["userControlSetTop"];
    }
    if (json["visible"] is int) {
      visible = json["visible"];
    }
  }

  static List<WechatSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(WechatSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (articleList != null) {
      _data["articleList"] = articleList;
    }
    _data["author"] = author;
    if (children != null) {
      _data["children"] = children;
    }
    _data["courseId"] = courseId;
    _data["cover"] = cover;
    _data["desc"] = desc;
    _data["id"] = id;
    _data["lisense"] = lisense;
    _data["lisenseLink"] = lisenseLink;
    _data["name"] = name;
    _data["order"] = order;
    _data["parentChapterId"] = parentChapterId;
    _data["type"] = type;
    _data["userControlSetTop"] = userControlSetTop;
    _data["visible"] = visible;
    return _data;
  }
}
