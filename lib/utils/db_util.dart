import 'dart:io';
import 'package:wan_andriod/data/model/history_seed.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/*实现了一个单例模式的 DatabaseUtil 类。这个类确保了自己只有一个实例，
 * 并提供了一个全局的访问点 DatabaseUtil() 来获取这个实例。
 * 这种模式在需要控制资源访问或确保某个操作只执行一次时非常有用，比如数据库连接、配置管理等场景。 */
class DatabaseUtil {
  /*这行代码声明了一个名为 _instance 的静态常量，并将其初始化为 DatabaseUtil 类的一个私有实例。
   * 注意，这里使用了类的私有构造函数 DatabaseUtil._() 来创建实例。
   * 由于构造函数是私有的，因此无法从类外部直接创建 DatabaseUtil 的新实例。 */
  static final DatabaseUtil _instance = DatabaseUtil._(); //私有构造函数，防止外部直接实例化
  /*这行代码定义了一个名为 DatabaseUtil 的工厂构造函数。
   * 工厂构造函数不会创建新的实例，而是返回已经存在的 _instance。
   * 这意味着，无论你在代码中多少次调用 DatabaseUtil()，都会得到同一个 DatabaseUtil 实例。 */
  factory DatabaseUtil() => _instance; //静态工厂构造函数，返回类的唯一实例（单例模式）
  /*这是 DatabaseUtil 类的私有构造函数。由于它是私有的，因此无法从类外部直接调用。
   * 这确保了 DatabaseUtil 类的实例只能在类内部被创建和控制。 */
  DatabaseUtil._();

  static Database? _db;
  Future<Database> get db async {
    // ignore: prefer_conditional_assignment
    if (_db == null) {
      _db = await initDb();
    }
    return _db!;
  }

  final String tableName = 'search_history';
  final String columnId = 'id';
  final String columnName = 'name';
  //初始化
  Future<Database> initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'wanandroid.db');
    Database ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //创建数据库
  Future _onCreate(Database db, int version) async {
    //sql语句
    String sql =
        'CREATE TABLE $tableName($columnId INTEGER PRIMARY KEY, $columnName TEXT)'; //只要存了text 自己会生成一个id
    //执行sql语句
    await db.execute(sql);
    print('$tableName is created!');
  }

  ///插入数据
  Future<int> insertItem(HistorySeed item) async {
    Database dbClient = await db;
    int res = await dbClient.insert(tableName, item.toMap());
    print(res);
    return res;
  }

  ///查询数据
  Future<List> queryList() async {
    Database dbClient = await db;
    List<Map<String, Object?>> res =
        await dbClient.rawQuery('SELECT * FROM $tableName'); //查找所有数据
    return res;
  }

  ///根据ID删除数据
  Future<int> deleteById(int id) async {
    Database dbClient = await db;
    return await dbClient
        .delete(tableName, where: '$columnId = ?', whereArgs: [id]);
  }

  ///清空数据
  Future<int> clear() async {
    Database dbClient = await db;
    return await dbClient.delete(tableName); //where 不设置就删除所有行
  }

  ///关闭数据库
  Future close() async {
    var dbClient = await db;
    print('database is closed!');
    return dbClient.close();
  }
}
