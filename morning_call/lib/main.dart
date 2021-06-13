// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List<int> _alarmList = [1, 2, 3];

//   @override
//   Widget build(BuildContext context) {
//     double deviceHeight;
//     double deviceWidth;

//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//         ),
//         body: LayoutBuilder(builder: (context, constraints) {
//           deviceHeight = constraints.maxHeight;
//           deviceWidth = constraints.maxWidth;

//           return Container(
//             height: deviceHeight * 0.86,
//             child: ListView.separated(
//               itemCount: _alarmList.length,
//               itemBuilder: (context, index) {
//                 /** 一番初めと日付が変わるたび日付表示 */

//                 return _swipeDeleteItem(
//                     _alarmList[index], deviceHeight, deviceWidth);
//               },
//               separatorBuilder: (context, index) {
//                 return Divider(
//                   height: 3,
//                 );
//               },
//             ),
//           );
//         }));
//   }

//   Widget _swipeDeleteItem(int n, deviceHeight, deviceWidth) {
//     return Dismissible(
//       // スワイプ削除
//       key: Key(n.toString()),
//       direction: DismissDirection.endToStart,
//       background: Container(
//         color: Colors.redAccent,
//         alignment: Alignment.centerRight,
//         padding: EdgeInsets.only(
//           right: 2,
//         ),
//         child: Icon(
//           Icons.delete,
//           size: deviceHeight * 0.03,
//         ),
//       ),
//       /** スワイプ処理 */
//       confirmDismiss: (direction) {
//         return swipeItem();
//       },
//       /** 削除処理 */
//       onDismissed: (direction) {
//         deleteItem(n);
//       },
//       /** タップアイテム */
//       child: _listItem(n, deviceHeight, deviceWidth),
//     );
//   }

//   // タップアイテム
//   Widget _listItem(int n, deviceHeight, deviceWidth) {
//     return InkWell(
//       /** 詳細表示ダイアログ */
//       // onTap: () {_showDetails(n, deviceHeight, deviceWidth);},
//       /** アイテム */
//       child: Container(
//         width: deviceWidth,
//         height: deviceHeight * 0.07,
//         alignment: Alignment.centerRight,
//         child: Stack(children: <Widget>[
//           DefaultTextStyle(
//             style: Theme.of(context).brightness == Brightness.light
//                 ? TextStyle(color: Colors.black)
//                 : TextStyle(color: Colors.white),
//             overflow: TextOverflow.ellipsis,
//             maxLines: 1,
//             child: Container(
//               alignment: Alignment.centerLeft,
//               padding: EdgeInsets.only(
//                 left: 15,
//                 right: 15,
//               ),
//               width: deviceWidth * 0.7,
//               child: Text(n.toString(),
//                   style: TextStyle(
//                     fontSize: 16,
//                   )),
//             ),
//           ),
//           Container(
//             alignment: Alignment.centerRight,
//             child: Text(
//               n.toString(),
//               style: TextStyle(
//                 fontSize: deviceHeight * 0.04,
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }

//   // スワイプ処理
//   Future<bool> swipeItem() async {
//     return await showDialog(
//         context: context,
//         builder: (_) => AlertDialog(
//               title: Text("削除"),
//               content: Text("削除しますか。"),
//               actions: <Widget>[
//                 // ボタン領域
//                 FlatButton(
//                   child: Text("キャンセル"),
//                   onPressed: () => Navigator.of(context).pop(false),
//                 ),
//                 FlatButton(
//                   child: Text("削除"),
//                   onPressed: () => Navigator.of(context).pop(true),
//                 ),
//               ],
//             ));
//   }

//   // 削除処理
//   void deleteItem(int id) async {
//     // await SQLite.deleteMoneyAndImgs(id);
//     // reload();
//   }
// }

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  await setup();
  runApp(MaterialApp(home: NotificationSamplePage()));
}

Future<void> setup() async {
  tz.initializeTimeZones();
  var tokyo = tz.getLocation('Asia/Tokyo');
  tz.setLocalLocation(tokyo);
}

class NotificationSamplePage extends StatelessWidget {
  // インスタンス生成
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ローカル通知をスケジュールする
  void _scheduleLocalNotification() async {
    // 初期化
    flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
          android: AndroidInitializationSettings('app_icon'), // app_icon.pngを配置
          iOS: IOSInitializationSettings()),
    );
    // スケジュール設定する
    int id = (new math.Random()).nextInt(10);
    // flutterLocalNotificationsPlugin.zonedSchedule(
    //     id, // id
    //     'Local Notification Title $id', // title
    //     'Local Notification Body $id', // body
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), // 5秒後設定
    //     NotificationDetails(
    //         android: AndroidNotificationDetails(
    //             'my_channel_id', 'my_channel_name', 'my_channel_description',
    //             importance: Importance.max, priority: Priority.high),
    //         iOS: IOSNotificationDetails()),
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime,
    //     androidAllowWhileIdle: true);
    var time = new Time(17, 34, 0);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'Timer',
      'You should check the app',
      time,
      NotificationDetails(
          android: AndroidNotificationDetails(
              'my_channel_id', 'my_channel_name', 'my_channel_description',
              importance: Importance.max, priority: Priority.high),
          iOS: IOSNotificationDetails()),
      payload: 'Default_Sound',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FloatingActionButton(
      onPressed: _scheduleLocalNotification, // ボタンを押したら通知をスケジュールする
      child: Text("Notify"),
    )));
  }
}
