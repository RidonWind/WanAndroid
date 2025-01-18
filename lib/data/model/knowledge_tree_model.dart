class KnowledgeTreeModel {
  List<KnowledgeTreeSeed>? data;
  int? errorCode;
  String? errorMsg;

  KnowledgeTreeModel({this.data, this.errorCode, this.errorMsg});

  KnowledgeTreeModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List)
              .map((e) => KnowledgeTreeSeed.fromJson(e))
              .toList();
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<KnowledgeTreeModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(KnowledgeTreeModel.fromJson).toList();
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

class KnowledgeTreeSeed {
  List<dynamic>? articleList;
  String? author;
  List<KnowledgeTreeChildSeed>? children;
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

  KnowledgeTreeSeed(
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

  KnowledgeTreeSeed.fromJson(Map<String, dynamic> json) {
    if (json["articleList"] is List) {
      articleList = json["articleList"] ?? [];
    }
    if (json["author"] is String) {
      author = json["author"];
    }
    if (json["children"] is List) {
      children = json["children"] == null
          ? null
          : (json["children"] as List)
              .map((e) => KnowledgeTreeChildSeed.fromJson(e))
              .toList();
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

  static List<KnowledgeTreeSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(KnowledgeTreeSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (articleList != null) {
      _data["articleList"] = articleList;
    }
    _data["author"] = author;
    if (children != null) {
      _data["children"] = children?.map((e) => e.toJson()).toList();
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

class KnowledgeTreeChildSeed {
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

  KnowledgeTreeChildSeed(
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

  KnowledgeTreeChildSeed.fromJson(Map<String, dynamic> json) {
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

  static List<KnowledgeTreeChildSeed> fromList(
      List<Map<String, dynamic>> list) {
    return list.map(KnowledgeTreeChildSeed.fromJson).toList();
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
