class CollectModel {
  CollectListSeed? data;
  int? errorCode;
  String? errorMsg;

  CollectModel({this.data, this.errorCode, this.errorMsg});

  CollectModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data =
          json["data"] == null ? null : CollectListSeed.fromJson(json["data"]);
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<CollectModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(CollectModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (data != null) {
      _data["data"] = data?.toJson();
    }
    _data["errorCode"] = errorCode;
    _data["errorMsg"] = errorMsg;
    return _data;
  }
}

class CollectListSeed {
  int? curPage;
  List<CollectArticleSeed>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  CollectListSeed(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  CollectListSeed.fromJson(Map<String, dynamic> json) {
    if (json["curPage"] is int) {
      curPage = json["curPage"];
    }
    if (json["datas"] is List) {
      datas = json["datas"] == null
          ? null
          : (json["datas"] as List)
              .map((e) => CollectArticleSeed.fromJson(e))
              .toList();
    }
    if (json["offset"] is int) {
      offset = json["offset"];
    }
    if (json["over"] is bool) {
      over = json["over"];
    }
    if (json["pageCount"] is int) {
      pageCount = json["pageCount"];
    }
    if (json["size"] is int) {
      size = json["size"];
    }
    if (json["total"] is int) {
      total = json["total"];
    }
  }

  static List<CollectListSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(CollectListSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["curPage"] = curPage;
    if (datas != null) {
      _data["datas"] = datas?.map((e) => e.toJson()).toList();
    }
    _data["offset"] = offset;
    _data["over"] = over;
    _data["pageCount"] = pageCount;
    _data["size"] = size;
    _data["total"] = total;
    return _data;
  }
}

class CollectArticleSeed {
  String? author;
  int? chapterId;
  String? chapterName;
  int? courseId;
  String? desc;
  String? envelopePic;
  int? id;
  String? link;
  String? niceDate;
  String? origin;
  int? originId;
  int? publishTime;
  String? title;
  int? userId;
  int? visible;
  int? zan;

  CollectArticleSeed(
      {this.author,
      this.chapterId,
      this.chapterName,
      this.courseId,
      this.desc,
      this.envelopePic,
      this.id,
      this.link,
      this.niceDate,
      this.origin,
      this.originId,
      this.publishTime,
      this.title,
      this.userId,
      this.visible,
      this.zan});

  CollectArticleSeed.fromJson(Map<String, dynamic> json) {
    if (json["author"] is String) {
      author = json["author"];
    }
    if (json["chapterId"] is int) {
      chapterId = json["chapterId"];
    }
    if (json["chapterName"] is String) {
      chapterName = json["chapterName"];
    }
    if (json["courseId"] is int) {
      courseId = json["courseId"];
    }
    if (json["desc"] is String) {
      desc = json["desc"];
    }
    if (json["envelopePic"] is String) {
      envelopePic = json["envelopePic"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["link"] is String) {
      link = json["link"];
    }
    if (json["niceDate"] is String) {
      niceDate = json["niceDate"];
    }
    if (json["origin"] is String) {
      origin = json["origin"];
    }
    if (json["originId"] is int) {
      originId = json["originId"];
    }
    if (json["publishTime"] is int) {
      publishTime = json["publishTime"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["userId"] is int) {
      userId = json["userId"];
    }
    if (json["visible"] is int) {
      visible = json["visible"];
    }
    if (json["zan"] is int) {
      zan = json["zan"];
    }
  }

  static List<CollectArticleSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(CollectArticleSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["author"] = author;
    _data["chapterId"] = chapterId;
    _data["chapterName"] = chapterName;
    _data["courseId"] = courseId;
    _data["desc"] = desc;
    _data["envelopePic"] = envelopePic;
    _data["id"] = id;
    _data["link"] = link;
    _data["niceDate"] = niceDate;
    _data["origin"] = origin;
    _data["originId"] = originId;
    _data["publishTime"] = publishTime;
    _data["title"] = title;
    _data["userId"] = userId;
    _data["visible"] = visible;
    _data["zan"] = zan;
    return _data;
  }
}
