class HotWordModel {
  List<HotWordSeed>? data;
  int? errorCode;
  String? errorMsg;

  HotWordModel({this.data, this.errorCode, this.errorMsg});

  HotWordModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is List) {
      data = json["data"] == null
          ? null
          : (json["data"] as List).map((e) => HotWordSeed.fromJson(e)).toList();
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<HotWordModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(HotWordModel.fromJson).toList();
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

class HotWordSeed {
  int? id;
  String? link;
  String? name;
  int? order;
  int? visible;

  HotWordSeed({this.id, this.link, this.name, this.order, this.visible});

  HotWordSeed.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["link"] is String) {
      link = json["link"];
    }
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["order"] is int) {
      order = json["order"];
    }
    if (json["visible"] is int) {
      visible = json["visible"];
    }
  }

  static List<HotWordSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(HotWordSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["link"] = link;
    _data["name"] = name;
    _data["order"] = order;
    _data["visible"] = visible;
    return _data;
  }
}
