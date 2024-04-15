import 'dart:convert';
import 'dart:io';
import 'package:excel_to_json/excel_to_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/Article.dart';
import 'package:json_table/json_table.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Label Print',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 62, 18, 239)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Label generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> selectedArticles = [];
  List<Map<String, dynamic>> jsonSample =
      [];
  

  @override
  Widget build(BuildContext context) {
     var json = jsonSample;
     var columns = [
      JsonTableColumn("Article Id"),
      JsonTableColumn("Article Description"),
      JsonTableColumn("Eancode"),
      JsonTableColumn("MRP"),
      JsonTableColumn("No of Copies"),
      JsonTableColumn("Selected"),
    ];

    return Scaffold(
       body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          child: Column(
                  children: [
                    ElevatedButton(
                      child: const Text("Upload Excel"),
                      onPressed: () async {
                        String? excel = await ExcelToJson().convert();
                        var excelJson = jsonDecode(excel!);
                        var articles = excelJson['Sheet1'];
                        if (kDebugMode) {
                          print(excel);
                          setState(() {
                            for(var i=0; i<articles.length; i++) {
                              jsonSample.add(articles[i]);
                            }
                          });
                          print(selectedArticles);
                        }
                      },
                    ),
                    const SizedBox(
                    height: 15),
                    ElevatedButton(
                      child: const Text("Generate PDF"),
                      onPressed: () async {
                       
                      },
                    ),
                     const SizedBox(
                    height: 15),
                    jsonSample.isNotEmpty ? JsonTable(
                      json,
                      columns: columns,
                      onRowSelect: (index, map) {
  
                        setState(() {
                          selectedArticles.add(map);
                        });
                        print(selectedArticles);
                      },
                    ): Container(),
                    
                    
                  ],
                ),
                
              
        ),
      ),
      
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}
