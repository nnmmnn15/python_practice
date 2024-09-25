import 'dart:convert';

import 'package:crud_app/view/delete_students.dart';
import 'package:crud_app/view/insert_students.dart';
import 'package:crud_app/view/update_students.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class QueryStudents extends StatefulWidget {
  const QueryStudents({super.key});

  @override
  State<QueryStudents> createState() => _QueryStudentsState();
}

class _QueryStudentsState extends State<QueryStudents> {
  // Property
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
        title: const Text('CRUD for Students'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const InsertStudents())!
                  .then((value) => getJSONData());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: Center(
        child: data.isEmpty
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const UpdateStudents(),
                        arguments: data[index],
                      )!
                          .then((value) => getJSONData());
                    },
                    onLongPress: () {
                      Get.to(
                        () => const DeleteStudents(),
                        arguments: data[index],
                      )!
                          .then((value) => getJSONData());
                    },
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Code : ${data[index][0].toString()}",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Name : ${data[index][1].toString()}",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Dept : ${data[index][2].toString()}",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Phone : ${data[index][3].toString()}",
                            ),
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
}
