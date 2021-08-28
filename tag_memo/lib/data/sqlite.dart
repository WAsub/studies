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
          "id INTEGER PRIMARY KEY, "
          "memoId INTEGER, "
          "FOREIGN KEY(memoId) REFERENCES memo(id)"
          ")",
        );
        // テスト用
        await db.execute("INSERT INTO memo (memo, backColor) VALUES (\"サンプルサンプルサンプルサンプル\nサンプル\", 500)");
        await db.execute("INSERT INTO memoOrder (memoId) VALUES (1)");
      },
      version: 1,
    );
    return _database;
  }

  /** メモプレビュー取得用 */
  static Future<List<Memo>> getMemoPreview() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT mO.id, mO.memoId, SUBSTR(m.memo, 1, 150) AS memoPreview, m.backColor "
      "FROM memoOrder AS mO "
      "LEFT OUTER JOIN memo AS m "
      "ON mO.memoId = m.id");
    
    List<Memo> list = [];
    for (int i = 0; i < maps.length; i++) {
      if (maps[i]['memoId'] != 0) {
        list.add(Memo(
          orderId: maps[i]['id'],
          memoId: maps[i]['memoId'],
          memoPreview: maps[i]['memoPreview'],
          backColor: maps[i]['backColor'],
        ));
      } else {
        // 空白はnull
        list.add(null);
      }
    }
    return list;
  }

  /** メモ取得用 */
  static Future<Memo> getMemo(int memoId) async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        "SELECT mO.id, mO.memoId, m.memo, m.backColor "
        "FROM memoOrder AS mO "
        "LEFT OUTER JOIN memo AS m "
        "ON mO.memoId = m.id "
        "WHERE mO.memoId = ?",
        [memoId]);
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
    int memoId = maps[0]['MAX(id)'];
    return memoId;
  }

  /** memoOrder 主キー昇順　に並んだ memoId のリスト */
  static Future<List<int>> getMemoIds() async {
    final Database db = await database;
    // リストを取得
    final List<Map<String, dynamic>> maps = await db.rawQuery("SELECT memoId FROM memoOrder ORDER BY id asc");
    List<int> list = [];
    for (int i = 0; i < maps.length; i++) {
      list.add(maps[i]['memoId']);
    }
    return list;
  }

  /** メモの削除用 */
  static Future<void> deleteMemo(int memoId) async {
    /** 旧付箋リストのメモIDリストを取得 */
    List<int> memoIds = await getMemoIds();
    /** 削除するメモを取り除く */
    memoIds.remove(memoId);
    /** 新しい memoOrder を登録 */
    await renewMemoOrder(memoIds);
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
    await deleteMemoOrders();
    /** memoIdsを順番に登録 */
    final Database db = await database;
    List<Map<String, dynamic>> maps = [];
    for (int i = 0; i < memoIds.length; i++) {
      await db.rawInsert('INSERT INTO memoOrder (memoId) VALUES (?)', [memoIds[i]]);
    }
  }

  /** memoOrder全削除用 TODO*/
  static Future<void> deleteMemoOrders() async {
    final db = await database;
    await db.delete('memoOrder');
  }
}
