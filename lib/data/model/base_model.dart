
class BaseModel {
  int? errorCode;
  String? errorMsg;

  BaseModel({this.errorCode, this.errorMsg});

  BaseModel.fromJson(Map<String, dynamic> json) {
    if(json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if(json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<BaseModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(BaseModel.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["errorCode"] = errorCode;
    _data["errorMsg"] = errorMsg;
    return _data;
  }
}