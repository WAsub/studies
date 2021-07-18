import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class Memo {
  int orderId;
  int memoId;
  String memoPreview;
  String memo;
  int backColor;

  Memo({
    this.orderId,
    this.memoId,
    this.memoPreview,
    this.memo,
    this.backColor,
  });
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'memoId': memoId,
      'memoPreview': memoPreview,
      'memo': memo,
      'backColor': backColor,
    };
  }

  @override
  String toString() {
    return 'Memo{orderId: $orderId, memoId: $memoId, memoPreview: $memoPreview, memo: $memo, backColor: $backColor}';
  }
}

// class MemoPreview {
//   int id;
//   String memoPreview;
//   int backColor;

//   MemoPreview({
//     this.id,
//     this.memoPreview,
//     this.backColor,
//   });
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'memoPreview': memoPreview,
//       'backColor': backColor,
//     };
//   }
//   @override
//   String toString() {
//     return 'MemoPreview{id: $id, memoPreview: $memoPreview, backColor: $backColor}';
//   }
// }

class SQLite {
  static Future<Database> get database async {
    final Future<Database> _database = openDatabase(
      join(await getDatabasesPath(), 'money_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE memo("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "memo TEXT, "
          "backColor INTEGER"
          ")",
        );
        await db.execute(
          "CREATE TABLE memoOrder("
          "id INTEGER PRIMARY KEY AUTOINCREMENT, "
          "memoId INTEGER, "
          "FOREIGN KEY(memoId) REFERENCES memo(id)"
          ")",
        );
        // // テスト用
        await db.execute("INSERT INTO memo (memo, backColor) VALUES (\"あいうえおかきくけこさしすせそ\nあいうえお\", 0)");
        await db.execute("INSERT INTO memoOrder (memoId) VALUES (1)");
      },
      version: 1,
    );
    return _database;
  }

  /** データ加工用 */
  static List<DateTime> getWeekStartEnd(DateTime datetime) {
    int weekday = datetime.weekday;
    DateTime sDate = datetime.add(Duration(days: -(weekday - 1)));
    DateTime eDate = datetime.add(Duration(days: 7 - weekday));
    sDate = DateTime(sDate.year, sDate.month, sDate.day, 0, 0, 0);
    eDate = DateTime(eDate.year, eDate.month, eDate.day, 23, 59, 59, 999);
    return [sDate, eDate];
  }

  /** メモプレビュー取得用 */
  static Future<List<Memo>> getMemoPreview() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT mO.id, mO.memoId, SUBSTR(m.memo, 1, 20) AS memoPreview, m.backColor "
        "FROM memoOrder AS mO "
        "INNER JOIN memo AS m "
        "ON mO.memoId = m.id");
    List<Memo> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(Memo(
        orderId: maps[i]['id'],
        memoId: maps[i]['memoId'],
        memoPreview: maps[i]['memoPreview'],
        backColor: maps[i]['backColor'],
      ));
    }
    return list;
  }

  /** メモ取得用 */
  static Future<Memo> getMemo(int orderId) async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT mO.id, mO.memoId, m.memo, m.backColor "
        "FROM memoOrder AS mO "
        "INNER JOIN memo AS m "
        "ON mO.memoId = m.id "
        "WHERE memoOrder._id = ?",
        [orderId]);
    Memo memo;
    memo = Memo(
      orderId: maps[0]['id'],
      memoId: maps[0]['memoId'],
      memo: maps[0]['memo'],
      backColor: maps[0]['backColor'],
    );
    return memo;
  }

  /** 編集したメモ保存用 */
  static Future<void> updateMemo(Memo memo) async {
    final Database db = await database;
    await db.rawUpdate('UPDATE memo SET memo = ?, backColor = ? WHERE id = ?', [memo.memo, memo.backColor, memo.memoId]);
  }

  /** 新規作成したメモ登録用 */
  static Future<void> insertMemo(Memo memo) async {
    final Database db = await database;
    /** memo表に登録 */
    await db.rawInsert('INSERT INTO memo(memo, backColor) VALUES (?, ?)', [memo.memo, memo.backColor]);
    /** 先ほど登録したメモのIDを取得 */
    int memoId = await getMaxMemoId();
    /** memoOrder表の最後に登録 */
    await db.rawInsert('INSERT INTO memoOrder(memoId) VALUES (?)', [memoId]);
  }

  /** 新規作成したメモIDを取得(memo　の主キーの一番大きい数字を取得) */
  static Future<int> getMaxMemoId() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT MAX(id) FROM memo");
    int memoId = maps[0]['id'];
    return memoId;
  }

//TODO
  /** メモの削除用 TODO*/
  static Future<void> deleteMemo(int memoId) async {
    /** 旧付箋リストのメモIDリストを取得 */
    /** 削除するメモを取り除く */
    /** 新しい memoOrder を登録 */
    /** メモ本体を削除 */
    final db = await database;
    await db.delete('memo', where: "id = ?", whereArgs: [memoId]);
  }

  /** メモの並び替え */
  static Future<List<Memo>> sortMemoOrder(List<int> memoIds) async {
    /** 新しい memoOrder を登録 */
    await renewMemoOrder(memoIds);
    /** 新しい付箋リストを取得 */
    List<Memo> list = await getMemoPreview();

    return list;
  }

  /** 新しい順番のmemoOrderを登録 */
  static Future<void> renewMemoOrder(List<int> memoIds) async {
    /** 全削除 */
    await deleteMemoorders();
    /** memoIdsを順番に登録 */
    final Database db = await database;
    List<Map<String, dynamic>> maps = [];
    maps = await db.rawQuery('SELECT * FROM goals WHERE id = (SELECT MAX(id) FROM goals)');
    Goal maxGoal;
    maxGoal = maps.isEmpty
        ?
        // データが空の場合
        Goal(
            entryDate: null,
            achieveDate: null,
            goal: null,
            memo: null,
            flg: true,
          )
        :
        // データがある場合
        Goal(
            entryDate: DateTime.parse(maps[0]['entryDate']),
            achieveDate: maps[0]['achieveDate'] == null ? null : DateTime.parse(maps[0]['achieveDate']),
            goal: maps[0]['goal'],
            memo: maps[0]['memo'],
            flg: maps[0]['flg'] != 0 ? true : false,
          );
    print("maxGoal:$maxGoal");
    return maxGoal;
  }

  /** memoOrder全削除用 TODO*/
  static Future<void> deleteMemoorders() async {
    final db = await database;
    await db.delete('memoOrder');
  }

  //TODO
  /** 今の目標取得(日付順にIDふっているのでIDの最大値の行) */
  static Future<int> getGoalNowId() async {
    final Database db = await database;
    List<Map<String, dynamic>> maps = [];
    maps = await db.rawQuery('SELECT MAX(id) FROM goals');
    int maxGoalId;
    maxGoalId = maps.isEmpty ? null : maps[0]['MAX(id)'];
    print("maxGoalId:$maxGoalId");
    return maxGoalId;
  }

  /** 目標登録用 */
  static Future<void> insertGoal(Goal goal) async {
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Database db = await database;
    // リストを順番に登録
    await db.rawInsert('INSERT INTO goals(entryDate, achieveDate, goal, memo, flg) VALUES (?, ?, ?, ?, ?)', [
      format.format(now),
      null,
      goal.goal,
      goal.memo,
      false,
    ]);
  }

  /** 目標達成登録用 */
  static Future<void> achieveNowGoal(bool flg) async {
    int nowID = await getGoalNowId();
    DateTime now = DateTime.now();
    DateFormat format = DateFormat('yyyy-MM-dd HH:mm:ss');
    final Database db = await database;
    // リストを順番に登録
    await db.rawUpdate('UPDATE goals SET flg = ?, achieveDate = ? WHERE id = ?', [flg, format.format(now), nowID]);
  }
}
