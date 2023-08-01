import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController accelerationsController = TextEditingController();
  TextEditingController movementController = TextEditingController();
  TextEditingController uterineController = TextEditingController();
  TextEditingController lightController = TextEditingController();
  TextEditingController severeController = TextEditingController();
  TextEditingController prolonguedController = TextEditingController();
  TextEditingController abnormalController = TextEditingController();
  TextEditingController percentageController = TextEditingController();

  String finalData = '';

  Future<void> predict() async {
    final String apiUrl = 'http://127.0.0.1:5000/predict';

    Map<String, dynamic> data = {
      'acceleration': accelerationsController.text,
      'movement': movementController.text,
      'uterine': uterineController.text,
      'light': lightController.text,
      'severe': severeController.text,
      'prolongued': prolonguedController.text,
      'abnormal': abnormalController.text,
      'percentage': percentageController.text,
    };

    final response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data));

    if (response.statusCode == 200) {
      Map<String, dynamic> result = jsonDecode(response.body);
      setState(() {
        finalData = result['finalData'] == 1 ? 'NORMAL' : 'SUSPECT';
      });
    } else {
      setState(() {
        finalData = 'Error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Prediksi Janin'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: accelerationsController,
                decoration: InputDecoration(labelText: 'Accelerations'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: movementController,
                decoration: InputDecoration(labelText: 'Movement'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: uterineController,
                decoration: InputDecoration(labelText: 'Uterine'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: lightController,
                decoration: InputDecoration(labelText: 'Light'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: severeController,
                decoration: InputDecoration(labelText: 'Severe'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: prolonguedController,
                decoration: InputDecoration(labelText: 'Prolongued'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: abnormalController,
                decoration: InputDecoration(labelText: 'Abnormal'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: percentageController,
                decoration: InputDecoration(labelText: 'Percentage'),
                keyboardType: TextInputType.number,
              ),
              // ... Tambahkan TextField lainnya untu9k input lainnya ...
              ElevatedButton(
                onPressed: predict,
                child: Text('Prediksi'),
              ),
              SizedBox(height: 20),
              Text(
                'Hasil Prediksi: $finalData',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}