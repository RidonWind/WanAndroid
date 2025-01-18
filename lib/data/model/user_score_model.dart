class UserScoreModel {
  UserScoreChild? data;
  int? errorCode;
  String? errorMsg;

  UserScoreModel({this.data, this.errorCode, this.errorMsg});

  UserScoreModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data =
          json["data"] == null ? null : UserScoreChild.fromJson(json["data"]);
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<UserScoreModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserScoreModel.fromJson).toList();
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

class UserScoreChild {
  int? curPage;
  List<UserScoreSeed>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  UserScoreChild(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  UserScoreChild.fromJson(Map<String, dynamic> json) {
    if (json["curPage"] is int) {
      curPage = json["curPage"];
    }
    if (json["datas"] is List) {
      datas = json["datas"] == null
          ? null
          : (json["datas"] as List)
              .map((e) => UserScoreSeed.fromJson(e))
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

  static List<UserScoreChild> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserScoreChild.fromJson).toList();
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

class UserScoreSeed {
  int? coinCount;
  int? date;
  String? desc;
  int? id;
  String? reason;
  int? type;
  int? userId;
  String? userName;

  UserScoreSeed(
      {this.coinCount,
      this.date,
      this.desc,
      this.id,
      this.reason,
      this.type,
      this.userId,
      this.userName});

  UserScoreSeed.fromJson(Map<String, dynamic> json) {
    if (json["coinCount"] is int) {
      coinCount = json["coinCount"];
    }
    if (json["date"] is int) {
      date = json["date"];
    }
    if (json["desc"] is String) {
      desc = json["desc"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["reason"] is String) {
      reason = json["reason"];
    }
    if (json["type"] is int) {
      type = json["type"];
    }
    if (json["userId"] is int) {
      userId = json["userId"];
    }
    if (json["userName"] is String) {
      userName = json["userName"];
    }
  }

  static List<UserScoreSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserScoreSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["coinCount"] = coinCount;
    _data["date"] = date;
    _data["desc"] = desc;
    _data["id"] = id;
    _data["reason"] = reason;
    _data["type"] = type;
    _data["userId"] = userId;
    _data["userName"] = userName;
    return _data;
  }
}
