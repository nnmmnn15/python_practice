import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String result;

  @override
  void initState() {
    super.initState();
    result = "______";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter with Python'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              result,
            ),
            TextButton(
              onPressed: () => getJsonData(),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Functions ---
  getJsonData() async {
    var url = Uri.parse('http://127.0.0.1:8000');
    var response = await http.get(url);
    // print(response.bodyBytes.runtimeType);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    result = dataConvertedJSON['message'];
    setState(() {});
  }
}
