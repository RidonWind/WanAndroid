class HistorySeed {
  int? id;
  late final String name;

  static HistorySeed fromMap(Map<String, dynamic> map) {
    HistorySeed historySeed = HistorySeed();
    historySeed.id = map['id'];
    historySeed.name = map['name'];
    return historySeed;
  }

  static List<HistorySeed> fromMapList(List mapList) {
    List<HistorySeed> list = [];
    for (var i = 0; i < mapList.length; i++) {
      list.add(fromMap(mapList[i]));
    }
    return list;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
