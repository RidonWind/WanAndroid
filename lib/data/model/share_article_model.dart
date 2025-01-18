class ShareArticleModel {
  ShareArticleData? data;
  int? errorCode;
  String? errorMsg;

  ShareArticleModel({this.data, this.errorCode, this.errorMsg});

  ShareArticleModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data =
          json["data"] == null ? null : ShareArticleData.fromJson(json["data"]);
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<ShareArticleModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(ShareArticleModel.fromJson).toList();
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

class ShareArticleData {
  CoinInfo? coinInfo;
  ShareArticles? shareArticles;

  ShareArticleData({this.coinInfo, this.shareArticles});

  ShareArticleData.fromJson(Map<String, dynamic> json) {
    if (json["coinInfo"] is Map) {
      coinInfo =
          json["coinInfo"] == null ? null : CoinInfo.fromJson(json["coinInfo"]);
    }
    if (json["shareArticles"] is Map) {
      shareArticles = json["shareArticles"] == null
          ? null
          : ShareArticles.fromJson(json["shareArticles"]);
    }
  }

  static List<ShareArticleData> fromList(List<Map<String, dynamic>> list) {
    return list.map(ShareArticleData.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    if (coinInfo != null) {
      _data["coinInfo"] = coinInfo?.toJson();
    }
    if (shareArticles != null) {
      _data["shareArticles"] = shareArticles?.toJson();
    }
    return _data;
  }
}

class ShareArticles {
  int? curPage;
  List<ShareArticleSeed>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  ShareArticles(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  ShareArticles.fromJson(Map<String, dynamic> json) {
    if (json["curPage"] is int) {
      curPage = json["curPage"];
    }
    if (json["datas"] is List) {
      datas = json["datas"] == null
          ? null
          : (json["datas"] as List)
              .map((e) => ShareArticleSeed.fromJson(e))
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

  static List<ShareArticles> fromList(List<Map<String, dynamic>> list) {
    return list.map(ShareArticles.fromJson).toList();
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

class ShareArticleSeed {
  bool? adminAdd;
  String? apkLink;
  int? audit;
  String? author;
  bool? canEdit;
  int? chapterId;
  String? chapterName;
  bool? collect;
  int? courseId;
  String? desc;
  String? descMd;
  String? envelopePic;
  bool? fresh;
  String? host;
  int? id;
  bool? isAdminAdd;
  String? link;
  String? niceDate;
  String? niceShareDate;
  String? origin;
  String? prefix;
  String? projectLink;
  int? publishTime;
  int? realSuperChapterId;
  int? selfVisible;
  int? shareDate;
  String? shareUser;
  int? superChapterId;
  String? superChapterName;
  List<dynamic>? tags;
  String? title;
  int? type;
  int? userId;
  int? visible;
  int? zan;
  int? top;

  ShareArticleSeed(
      {this.adminAdd,
      this.apkLink,
      this.audit,
      this.author,
      this.canEdit,
      this.chapterId,
      this.chapterName,
      this.collect,
      this.courseId,
      this.desc,
      this.descMd,
      this.envelopePic,
      this.fresh,
      this.host,
      this.id,
      this.isAdminAdd,
      this.link,
      this.niceDate,
      this.niceShareDate,
      this.origin,
      this.prefix,
      this.projectLink,
      this.publishTime,
      this.realSuperChapterId,
      this.selfVisible,
      this.shareDate,
      this.shareUser,
      this.superChapterId,
      this.superChapterName,
      this.tags,
      this.title,
      this.type,
      this.userId,
      this.visible,
      this.zan,
      this.top});

  ShareArticleSeed.fromJson(Map<String, dynamic> json) {
    if (json["adminAdd"] is bool) {
      adminAdd = json["adminAdd"];
    }
    if (json["apkLink"] is String) {
      apkLink = json["apkLink"];
    }
    if (json["audit"] is int) {
      audit = json["audit"];
    }
    if (json["author"] is String) {
      author = json["author"];
    }
    if (json["canEdit"] is bool) {
      canEdit = json["canEdit"];
    }
    if (json["chapterId"] is int) {
      chapterId = json["chapterId"];
    }
    if (json["chapterName"] is String) {
      chapterName = json["chapterName"];
    }
    if (json["collect"] is bool) {
      collect = json["collect"];
    }
    if (json["courseId"] is int) {
      courseId = json["courseId"];
    }
    if (json["desc"] is String) {
      desc = json["desc"];
    }
    if (json["descMd"] is String) {
      descMd = json["descMd"];
    }
    if (json["envelopePic"] is String) {
      envelopePic = json["envelopePic"];
    }
    if (json["fresh"] is bool) {
      fresh = json["fresh"];
    }
    if (json["host"] is String) {
      host = json["host"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["isAdminAdd"] is bool) {
      isAdminAdd = json["isAdminAdd"];
    }
    if (json["link"] is String) {
      link = json["link"];
    }
    if (json["niceDate"] is String) {
      niceDate = json["niceDate"];
    }
    if (json["niceShareDate"] is String) {
      niceShareDate = json["niceShareDate"];
    }
    if (json["origin"] is String) {
      origin = json["origin"];
    }
    if (json["prefix"] is String) {
      prefix = json["prefix"];
    }
    if (json["projectLink"] is String) {
      projectLink = json["projectLink"];
    }
    if (json["publishTime"] is int) {
      publishTime = json["publishTime"];
    }
    if (json["realSuperChapterId"] is int) {
      realSuperChapterId = json["realSuperChapterId"];
    }
    if (json["selfVisible"] is int) {
      selfVisible = json["selfVisible"];
    }
    if (json["shareDate"] is int) {
      shareDate = json["shareDate"];
    }
    if (json["shareUser"] is String) {
      shareUser = json["shareUser"];
    }
    if (json["superChapterId"] is int) {
      superChapterId = json["superChapterId"];
    }
    if (json["superChapterName"] is String) {
      superChapterName = json["superChapterName"];
    }
    if (json["tags"] is List) {
      tags = json["tags"] ?? [];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["type"] is int) {
      type = json["type"];
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
    top = 0;
  }

  static List<ShareArticleSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(ShareArticleSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["adminAdd"] = adminAdd;
    _data["apkLink"] = apkLink;
    _data["audit"] = audit;
    _data["author"] = author;
    _data["canEdit"] = canEdit;
    _data["chapterId"] = chapterId;
    _data["chapterName"] = chapterName;
    _data["collect"] = collect;
    _data["courseId"] = courseId;
    _data["desc"] = desc;
    _data["descMd"] = descMd;
    _data["envelopePic"] = envelopePic;
    _data["fresh"] = fresh;
    _data["host"] = host;
    _data["id"] = id;
    _data["isAdminAdd"] = isAdminAdd;
    _data["link"] = link;
    _data["niceDate"] = niceDate;
    _data["niceShareDate"] = niceShareDate;
    _data["origin"] = origin;
    _data["prefix"] = prefix;
    _data["projectLink"] = projectLink;
    _data["publishTime"] = publishTime;
    _data["realSuperChapterId"] = realSuperChapterId;
    _data["selfVisible"] = selfVisible;
    _data["shareDate"] = shareDate;
    _data["shareUser"] = shareUser;
    _data["superChapterId"] = superChapterId;
    _data["superChapterName"] = superChapterName;
    if (tags != null) {
      _data["tags"] = tags;
    }
    _data["title"] = title;
    _data["type"] = type;
    _data["userId"] = userId;
    _data["visible"] = visible;
    _data["zan"] = zan;
    return _data;
  }
}

class CoinInfo {
  int? coinCount;
  int? level;
  String? nickname;
  String? rank;
  int? userId;
  String? username;

  CoinInfo(
      {this.coinCount,
      this.level,
      this.nickname,
      this.rank,
      this.userId,
      this.username});

  CoinInfo.fromJson(Map<String, dynamic> json) {
    if (json["coinCount"] is int) {
      coinCount = json["coinCount"];
    }
    if (json["level"] is int) {
      level = json["level"];
    }
    if (json["nickname"] is String) {
      nickname = json["nickname"];
    }
    if (json["rank"] is String) {
      rank = json["rank"];
    }
    if (json["userId"] is int) {
      userId = json["userId"];
    }
    if (json["username"] is String) {
      username = json["username"];
    }
  }

  static List<CoinInfo> fromList(List<Map<String, dynamic>> list) {
    return list.map(CoinInfo.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["coinCount"] = coinCount;
    _data["level"] = level;
    _data["nickname"] = nickname;
    _data["rank"] = rank;
    _data["userId"] = userId;
    _data["username"] = username;
    return _data;
  }
}
