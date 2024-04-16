import 'dart:convert';
import 'dart:io';
import 'package:excel_to_json/excel_to_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/model/Article.dart';
import 'package:json_table/json_table.dart';
import 'widgets/DataTableDemo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Label Print',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 62, 18, 239)),
        useMaterial3: true,
      ),
      home: const DataTableDemo (),
    );
  }
}

