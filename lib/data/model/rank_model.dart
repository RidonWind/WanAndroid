class RankModel {
  RankChild? data;
  int? errorCode;
  String? errorMsg;

  RankModel({this.data, this.errorCode, this.errorMsg});

  RankModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data = json["data"] == null ? null : RankChild.fromJson(json["data"]);
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<RankModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(RankModel.fromJson).toList();
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

class RankChild {
  int? curPage;
  List<RankSeed>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  RankChild(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  RankChild.fromJson(Map<String, dynamic> json) {
    if (json["curPage"] is int) {
      curPage = json["curPage"];
    }
    if (json["datas"] is List) {
      datas = json["datas"] == null
          ? null
          : (json["datas"] as List).map((e) => RankSeed.fromJson(e)).toList();
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

  static List<RankChild> fromList(List<Map<String, dynamic>> list) {
    return list.map(RankChild.fromJson).toList();
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

class RankSeed {
  int? coinCount;
  int? level;
  String? nickname;
  String? rank;
  int? userId;
  String? username;

  RankSeed(
      {this.coinCount,
      this.level,
      this.nickname,
      this.rank,
      this.userId,
      this.username});

  RankSeed.fromJson(Map<String, dynamic> json) {
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

  static List<RankSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(RankSeed.fromJson).toList();
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
