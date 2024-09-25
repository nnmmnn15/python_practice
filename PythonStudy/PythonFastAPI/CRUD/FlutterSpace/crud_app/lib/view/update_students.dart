import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateStudents extends StatefulWidget {
  const UpdateStudents({super.key});

  @override
  State<UpdateStudents> createState() => _UpdateStudentsState();
}

class _UpdateStudentsState extends State<UpdateStudents> {
  // Property
  List student = Get.arguments ?? "__";
  TextEditingController codeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController deptController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    codeController.text = student[0];
    nameController.text = student[1] ?? "";
    deptController.text = student[2] ?? "";
    phoneController.text = student[3] ?? "";
    addressController.text = student[4] ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update for CRUD'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: codeController,
                  decoration: const InputDecoration(
                    labelText: '학번 입니다.',
                  ),
                  readOnly: true,
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: '성명을 수정 하세요',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: deptController,
                  decoration: const InputDecoration(
                    labelText: '전공을 수정 하세요',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: '전화번호를 수정 하세요',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: '주소를 수정 하세요',
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: ElevatedButton(
                  onPressed: () => insertJSONData(),
                  child: const Text('수정'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Functions ---
  insertJSONData() async {
    var url = Uri.parse(
        'http://127.0.0.1:8000/update?code=${codeController.text.trim()}&name=${nameController.text.trim()}&dept=${deptController.text.trim()}&phone=${phoneController.text.trim()}&address=${addressController.text.trim()}');
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
    print("Completed!");
    Get.back();
  }

  errorSnackBar() {
    print('Error');
  }
} // End