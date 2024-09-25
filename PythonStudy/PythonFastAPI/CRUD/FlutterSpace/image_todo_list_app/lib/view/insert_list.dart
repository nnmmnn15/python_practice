import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InsertList extends StatefulWidget {
  const InsertList({super.key});

  @override
  State<InsertList> createState() => _InsertListState();
}

class _InsertListState extends State<InsertList> {
  //Property
  late TextEditingController textEditingController;
  late List<String> imagePath;
  late int selectedImage;
  late String? errorText;

  @override
  void initState() {
    super.initState();
    errorText = null;
    textEditingController = TextEditingController();
    selectedImage = 0;
    imagePath = [
      'pencil.png',
      'cart.png',
      'clock.png',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add View'),
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  'images/${imagePath[selectedImage]}',
                  scale: .8,
                  width: 150,
                  height: 150,
                ),
                SizedBox(
                  width: 200,
                  height: 150,
                  child: CupertinoPicker(
                    backgroundColor: Colors.blue[200],
                    itemExtent: 50,
                    onSelectedItemChanged: (value) {
                      selectedImage = value;
                      setState(() {});
                    },
                    children: List.generate(
                      imagePath.length,
                      (index) => Center(
                        child: Image.asset('images/${imagePath[index]}'),
                      ),
                    ),
                  ),
                )
              ],
            ),
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: '목록을 입력하세요',
                errorText: errorText,
              ),
              keyboardType: TextInputType.text,
            ),
            ElevatedButton(
              onPressed: () {
                if (checkText()) {
                  // 추가 로직
                  insertJSONData();
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Functions ---
  // --- Functions ---
  insertJSONData() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/insert?task=${textEditingController.text}&imagepath=${imagePath[selectedImage]}&task_date=${DateTime.now()}');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    var result = dataConvertedJSON['results'];

    setState(() {});
    if (result == 'OK') {
      _showDialog();
    } else {
      errorSnackBar();
    }
  }

  _showDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('입력 결과'),
        content: const Text('입력 성공'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  errorSnackBar() {
    Get.dialog(
      AlertDialog(
        title: const Text('입력 결과'),
        content: const Text('입력 실패'),
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

  bool checkText() {
    if (textEditingController.text.trim().isEmpty) {
      errorText = '할일을 입력해주세요!';
      setState(() {});
      return false;
    } else {
      errorText = null;
      setState(() {});
      return true;
    }
  }
} // End
