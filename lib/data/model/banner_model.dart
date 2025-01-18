class BannerModel {
  List<BannerSeed>? data;
  int? errorCode;
  String? errorMsg;

  BannerModel({this.data, this.errorCode, this.errorMsg});

  BannerModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => BannerSeed.fromJson(e)).toList();
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<BannerModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(BannerModel.fromJson).toList();
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

class BannerSeed {
  String? desc;
  int? id;
  String? imagePath;
  int? isVisible;
  int? order;
  String? title;
  int? type;
  String? url;

  BannerSeed(
      {this.desc,
      this.id,
      this.imagePath,
      this.isVisible,
      this.order,
      this.title,
      this.type,
      this.url});

  BannerSeed.fromJson(Map<String, dynamic> json) {
    if (json["desc"] is String) {
      desc = json["desc"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["imagePath"] is String) {
      imagePath = json["imagePath"];
    }
    if (json["isVisible"] is int) {
      isVisible = json["isVisible"];
    }
    if (json["order"] is int) {
      order = json["order"];
    }
    if (json["title"] is String) {
      title = json["title"];
    }
    if (json["type"] is int) {
      type = json["type"];
    }
    if (json["url"] is String) {
      url = json["url"];
    }
  }

  static List<BannerSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(BannerSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["desc"] = desc;
    _data["id"] = id;
    _data["imagePath"] = imagePath;
    _data["isVisible"] = isVisible;
    _data["order"] = order;
    _data["title"] = title;
    _data["type"] = type;
    _data["url"] = url;
    return _data;
  }
}
