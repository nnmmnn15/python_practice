import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_todo_list_app/view/insert_list.dart';

class TableList extends StatefulWidget {
  const TableList({super.key});

  @override
  State<TableList> createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  List data = [];
  @override
  void initState() {
    super.initState();
    getJSONData();
  }

  getJSONData() async {
    var url = Uri.parse('http://127.0.0.1:8000/select');
    var response = await http.get(url);
    // print(response.body);
    data.clear();
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];
    data.addAll(result);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List 검색'),
        actions: [
          IconButton(
            // 버튼을 누르고 뒤로가기로 돌아올 경우 .then부터 시작
            onPressed: () => Get.to(() => const InsertList())!.then(
              (value) => getJSONData(),
            ),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Slidable(
              endActionPane: ActionPane(
                extentRatio: .3, // 사이즈 최대 1
                motion: const BehindMotion(),
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    label: 'Delete',
                    onPressed: (context) async {
                      await deleteJSONData(data[index][0]);
                      getJSONData();
                    },
                  ),
                ],
              ),
              child: Card(
                color: index % 2 == 0 ? Colors.pink[100] : Colors.yellow[100],
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        "images/${data[index][2]}",
                      ),
                    ),
                    Text(
                      '   ${data[index][1]} / ${data[index][3].toString().split("T")[0]} ${data[index][3].toString().split("T")[1]}',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  deleteJSONData(int seq) async {
    var url = Uri.parse('http://127.0.0.1:8000/delete?seq=$seq');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];
    setState(() {});
    if (result == 'OK') {
      _showDialog('삭제 성공');
    } else {
      _showDialog('삭제 성공');
    }
  }

  _showDialog(message) {
    Get.dialog(
      AlertDialog(
        title: const Text('삭제 결과'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }
}
