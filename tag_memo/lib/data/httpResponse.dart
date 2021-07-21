// import 'package:shared_preferences/shared_preferences.dart';
// import 'apiResults.dart';
// import 'sqlite.dart';

// /** 貯金データ取得用 */
// class DataRequest {
//   final String userid;
//   DataRequest({
//     this.userid,
//   });
//   Map<String, dynamic> toJson() => {
//     'userid': userid,
//   };
// }
// /** リモートデータベースの目標リスト更新用 */
// class GoalUpdateRequest {
//   final List<Goal> goallist;
//   GoalUpdateRequest({
//     this.goallist,
//   });
//   Map<String, dynamic> toJson() => {
//     'goallist': goallist,
//   };
// }
// /** アカウント作成用 */
// class SignUpRequest {
//   final String username;
//   final String userpass;
//   SignUpRequest({
//     this.username,
//     this.userpass,
//   });
//   Map<String, dynamic> toJson() => {
//     'username': username,
//     'userpass': userpass,
//   };
// }
// /** ニックネーム変更用 */
// class ChengeNameRequest {
//   final String username;
//   ChengeNameRequest({
//     this.username,
//   });
//   Map<String, dynamic> toJson() => {
//     'username': username,
//   };
// }
// /** HTTP通信系まとめ */
// class HttpRes{
//   static Future<void> getThokinData() async {
//     /** HTTP通信 */
//     ApiResults httpRes;
//     /** サーバーからデータを取得 */
//     httpRes = await fetchApiResults(
//       "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
//       /// new DataRequest(userid: _loginData[0]).toJson()
//       new DataRequest(userid: "abc").toJson() // TODO　テスト用
//     );
//     /** データを取得できたらローカルのデータを入れ替え */
//     if (httpRes.message != "Failed") {
//       List<Thokin> thokin = [];
//       for (int i = 0; i < httpRes.data.length; i++) {
//         thokin.add(Thokin(
//           date: httpRes.data[i]["datetime"],
//           money: httpRes.data[i]["money"],
//           one_yen: httpRes.data[i]['one_yen'],
//           five_yen: httpRes.data[i]['five_yen'],
//           ten_yen: httpRes.data[i]['ten_yen'],
//           fifty_yen: httpRes.data[i]['fifty_yen'],
//           hundred_yen: httpRes.data[i]['hundred_yen'],
//           five_hundred_yen: httpRes.data[i]['five_hundred_yen'],
//         ));
//       }
//       await SQLite.deleteThokin();
//       await SQLite.insertThokin(thokin);
//     }
//   }
//   /** リモートデータベースの目標リスト更新 */
//   static Future<void> remoteGoalsUpdate() async {
//     /** HTTP通信 */
//     ApiResults httpRes;
//     /** ユーザーIDを引き出して */
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     final String myId = (prefs.getString('myid') ?? "");
//     /** 目標リスト引き出してIDを穴埋め */
//     List<Goal> list = await SQLite.getGoal();
//     for(int i = 0; i < list.length; i++){
//       list[i].userId = myId;
//     }
//     // print(list);
//     // TODO API完成まではここの処理はコメントアウト
//     /** サーバーへ登録 */
//     // bool flg = false;
//     // while (!flg) {
//     //   /** サーバーへデータを送信 */
//     //   httpRes = await fetchApiResults(
//     //     "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
//     //     new GoalUpdateRequest(goallist: list).toJson()
//     //   );
//     //   /** 成功したら端末に保存 */
//     //   if(httpRes.message != "Failed"){
//     //     flg = true;
//     //   }
//     // }
//   }
//   /** アカウント作成 */
//   static Future<void> signUp(String name, String pass) async {
//     /** HTTP通信 */
//     ApiResults httpRes;
//     bool flg = false;
//     // while (!flg) {
//     //   // TODO API完成まではここの処理はコメントアウト
//     //   /** サーバーへデータを送信 */
//     //   httpRes = await fetchApiResults(
//     //     "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
//     //     new SignUpRequest(username: name, userpass: pass).toJson()
//     //   );
//     //   /** 成功したら端末に保存 */
//     //   if(httpRes.message != "Failed"){
//     //     String myid = httpRes.data["userid"];
//         String myid = "abc"; // TODO テスト用
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("myid", myid);
//         await prefs.setString("myname", name);
//         await prefs.setString("mypass", pass);
//         await prefs.setBool("first", true);
//         await prefs.setBool("login", true);
//         flg = true;
//       // }
//     // }
//   }
//   /** ニックネーム変更用 */
//   static Future<void> chengeName(String name) async {
//     /** HTTP通信 */
//     ApiResults httpRes;
//     bool flg = false;
//     // while (!flg) {
//     //   // TODO API完成まではここの処理はコメントアウト
//     //   /** サーバーへデータを送信 */
//     //   httpRes = await fetchApiResults(
//     //     "http://haveabook.php.xdomain.jp/editing/api/sumple_api.php",
//     //     new ChengeNameRequest(username: name,).toJson()
//     //   );
//     //   /** 成功したら端末に保存 */
//     //   if(httpRes.message != "Failed"){
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString("myname", name);
//         flg = true;
//     //   }
//     // }
//   }
// }