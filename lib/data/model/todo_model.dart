class TodoModel {
  TodoData? data;
  int? errorCode;
  String? errorMsg;

  TodoModel({this.data, this.errorCode, this.errorMsg});

  TodoModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] is Map) {
      data = json["data"] == null ? null : TodoData.fromJson(json["data"]);
    }
    if (json["errorCode"] is int) {
      errorCode = json["errorCode"];
    }
    if (json["errorMsg"] is String) {
      errorMsg = json["errorMsg"];
    }
  }

  static List<TodoModel> fromList(List<Map<String, dynamic>> list) {
    return list.map(TodoModel.fromJson).toList();
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

class TodoData {
  int? curPage;
  List<TodoSeed>? datas;
  int? offset;
  bool? over;
  int? pageCount;
  int? size;
  int? total;

  TodoData(
      {this.curPage,
      this.datas,
      this.offset,
      this.over,
      this.pageCount,
      this.size,
      this.total});

  TodoData.fromJson(Map<String, dynamic> json) {
    if (json["curPage"] is int) {
      curPage = json["curPage"];
    }
    if (json["datas"] is List) {
      datas = json["datas"] == null
          ? null
          : (json["datas"] as List).map((e) => TodoSeed.fromJson(e)).toList();
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

  static List<TodoData> fromList(List<Map<String, dynamic>> list) {
    return list.map(TodoData.fromJson).toList();
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

class TodoSeed {
  int? completeDate;
  String? completeDateStr;
  String? content;
  int? date;
  String? dateStr;
  int? id;
  int? priority;
  int? status;
  String? title;
  int? type;
  int? userId;

  TodoSeed(
      {this.completeDate,
      this.completeDateStr,
      this.content,
      this.date,
      this.dateStr,
      this.id,
      this.priority,
      this.status,
      this.title,
      this.type,
      this.userId});

  TodoSeed.fromJson(Map<String, dynamic> json) {
    if (json["completeDate"] is int) {
      completeDate = json["completeDate"];
    }
    if (json["completeDateStr"] is String) {
      completeDateStr = json["completeDateStr"];
    }
    if (json["content"] is String) {
      content = json["content"];
    }
    if (json["date"] is int) {
      date = json["date"];
    }
    if (json["dateStr"] is String) {
      dateStr = json["dateStr"];
    }
    if (json["id"] is int) {
      id = json["id"];
    }
    if (json["priority"] is int) {
      priority = json["priority"];
    }
    if (json["status"] is int) {
      status = json["status"];
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
  }

  static List<TodoSeed> fromList(List<Map<String, dynamic>> list) {
    return list.map(TodoSeed.fromJson).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["completeDate"] = completeDate;
    _data["completeDateStr"] = completeDateStr;
    _data["content"] = content;
    _data["date"] = date;
    _data["dateStr"] = dateStr;
    _data["id"] = id;
    _data["priority"] = priority;
    _data["status"] = status;
    _data["title"] = title;
    _data["type"] = type;
    _data["userId"] = userId;
    return _data;
  }
}
