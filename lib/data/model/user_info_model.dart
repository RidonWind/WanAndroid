class UserInfoModel {
  UserInfoSeed? data;
  int? errorCode;
  String? errorMsg;

  UserInfoModel({this.data, this.errorCode, this.errorMsg});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data = json["data"] == null ? null : UserInfoSeed.fromJson(json["data"]);
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<UserInfoModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserInfoModel.fromJson).toList();
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

class UserInfoSeed {
  int? coinCount;
  int? rank;
  int? userId;
  String? username;

  UserInfoSeed({this.coinCount, this.rank, this.userId, this.username});

  UserInfoSeed.fromJson(Map<String, dynamic> json) {
    if (json["coinCount"] is int) {
      coinCount = json["coinCount"];
    }
    if (json["rank"] is int) {
      rank = json["rank"];
    }
    if (json["userId"] is int) {
      userId = json["userId"];
    }
    if (json["username"] is String) {
      username = json["username"];
    }
  }

  static List<UserInfoSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(UserInfoSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["coinCount"] = coinCount;
    _data["rank"] = rank;
    _data["userId"] = userId;
    _data["username"] = username;
    return _data;
  }
}
