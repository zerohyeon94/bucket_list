import 'package:bucket_list/DBHelper.dart';
import 'package:bucket_list/home_page.dart';
import 'package:bucket_list/main_page.dart';
import 'package:bucket_list/main.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:developer';

import 'main.dart';

class typeList {
  final String type;
  final String icon;

  typeList(this.type, this.icon);
}

class Setting_Page extends StatefulWidget {
  const Setting_Page({super.key});

  static const String routeName = "/setting_page";

  @override
  State<Setting_Page> createState() => _Setting_PageState();
}

class _Setting_PageState extends State<Setting_Page> {
  final TextEditingController _textFieldController = TextEditingController();

  List<Map<String, dynamic>> typelists = []; // type List table

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // 데이터베이스 초기화
  Future<Database> _initDB() async {
    log("test log : _initDB");
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'bucketlist.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE typelists(type TEXT, icon TEXT)');
      },
    );
  }

  // 데이터 로딩
  Future<void> _loadData() async {
    log("test log : _loadData");
    final db = await _initDB();
    final dataList = await db.query('typelists');
    setState(() {
      typelists = dataList;
    });
  }

  // 데이터 추가
  Future<void> _addData(String type, String icon) async {
    log("test log : _addData");
    final db = await _initDB();
    await db.insert(
      'typelists',
      {
        'type': type,
        'icon': icon,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _textFieldController.clear();
    _loadData();
  }

  // 데이터 수정
  Future<void> _editData(String type, String icon) async {
    final db = await _initDB();
    await db.update(
      'typelists',
      {
        'type': type,
        'icon': icon,
      },
      where: 'type = ?',
      whereArgs: [type],
    );
    _loadData();
  }

  // 데이터 삭제
  Future<void> _deleteData(String type) async {
    final db = await _initDB();
    await db.delete(
      'typelists',
      where: 'type = ?',
      whereArgs: [type],
    );
    _loadData();
  }

  Widget build(BuildContext context) {
    DBHelper helper = DBHelper();

    // type 목록
    List<Map<String, dynamic>> BucketList = [
      {
        "type": "여행",
        "icon": Icons.airplanemode_active,
      },
      {
        "type": "공부",
        "icon": Icons.book,
      },
    ];

    // type 목록
    List<Map<String, dynamic>> BucketList_date = [
      {
        "type": "여행",
        "date": "50% (5/10)",
      },
      {
        "type": "공부",
        "date": "30% (3/10)",
      },
    ];

    final deviceWidth = MediaQuery.of(context).size.width;
    final Shader linearGradientShader = ui.Gradient.linear(
        Offset(0, 20), Offset(150, 20), [Colors.red, Colors.yellow]);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                Color(0xFFFFF59D),
                Color(0xFFAED581),
              ],
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 3, // 앱이 붕 떠 있는 효과를 줌.
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  // log("home icon select : db okay?");
                  // List<String> test_type = ["여행", "공부", "저축", "게임", "독서"];
                  // List<String> test_icon = ["여행", "공부", "저축", "게임", "독서"];
                  // _addData("test type", "test icon");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                      (route) => false);
                },
                icon: Icon(
                  Icons.home,
                  color: Colors.green[400],
                  size: 30,
                ),
              ),
            ],
          ),
        ),
        title: Row(
          // title의 중앙을 맞추기 위해 사용
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '설정 및 달성 현황',
              style: TextStyle(
                // foreground: Paint()..shader = linearGradientShader,
                // foreground: Paint()
                //   ..shader = LinearGradient(
                //     colors: <Color>[Colors.green!, Colors.white!],
                //   ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 100.0)),
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.yellow[100]!, Colors.green[200]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.lightGreen[100]!],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green[400]!,
                          width: 2,
                        )),
                    child: Text(
                      'Nickname',
                      style: TextStyle(
                        color: Colors.green[400],
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  // Row 위젯에서 간격을 넣기 위해 사용.
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: deviceWidth - 150,
                    child: TextFormField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.lightGreen[50],
                        contentPadding: EdgeInsets.only(
                            left: 10.0, right: 0.0, top: 0.0, bottom: 0.0),
                        hintText: "7자 자리수 제한",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // column 위젯에서 간격을 넣기 위해 사용.
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.lightGreen[100]!],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green[400]!,
                          width: 2,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        'Type',
                        style: TextStyle(
                          color: Colors.green[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // column 위젯에서 간격을 넣기 위해 사용.
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.lightGreen[100]!],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.green[400]!,
                      width: 1.5,
                    ),
                    // border: Border(
                    //   left: BorderSide(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    //   right: BorderSide(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    //   top: BorderSide(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    // ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Type',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '완성도',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Colors.lightGreen[100]!],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      border: Border.all(
                        color: Colors.green[400]!,
                        width: 1.5,
                      )),
                  child: ListView.separated(
                    itemCount: BucketList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Container(
                          height: 30.0,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Icon(
                                  BucketList[index]['icon'],
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  BucketList[index]['type'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ),
              // column 위젯에서 간격을 넣기 위해 사용.
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    width: 100,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.white, Colors.lightGreen[100]!],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green[400]!,
                          width: 2,
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        '완성도',
                        style: TextStyle(
                          color: Colors.green[400],
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // column 위젯에서 간격을 넣기 위해 사용.
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: Container(
                  height: 40.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.lightGreen[100]!],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.green[400]!,
                      width: 1.5,
                    ),
                    // border: Border(
                    //   left: BorderSide(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    //   right: BorderSide(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    //   top: BorderSide(
                    //     color: Colors.black,
                    //     width: 1.0,
                    //   ),
                    // ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Type',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          '완성도',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.white, Colors.lightGreen[100]!],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    border: Border.all(
                      color: Colors.green[400]!,
                      width: 1.5,
                    ),
                  ),
                  child: ListView.separated(
                    itemCount: BucketList_date.length,
                    itemBuilder: (context, index) {
                      log("test log : " + typelists.length.toString());
                      return Container(
                        height: 30.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                BucketList_date[index]['type'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                BucketList_date[index]['date'],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                ),
              ),
              // column 위젯에서 간격을 넣기 위해 사용.
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
