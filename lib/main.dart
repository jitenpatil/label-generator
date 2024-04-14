import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 62, 18, 239)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Label generator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<dynamic>> _data = [];

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        pageFormat: const PdfPageFormat(4 * PdfPageFormat.cm, 5 * PdfPageFormat.cm),
        build: (context) => pw.Center(
          child: pw.Column(
            children: [
              pw.Text('410210001', style: const pw.TextStyle(fontSize: 10)),
              pw.SizedBox(height: 2 * PdfPageFormat.cm),
              pw.Text('890290031', style: const pw.TextStyle(fontSize: 10)),
            ],
          )
        ),
      ),
    );

    // Save the PDF to a file
    final output = await File('example.pdf').create();
    await output.writeAsBytes(await pdf.save());
  }

   Future<void> _generateSampleExcel() async {
    var excel = Excel.createExcel();
    var sheet = excel['Sheet1'];

    //Add header row
    sheet.appendRow([
      // 'Name',
      // 'Age',
      // 'City'
    ]);


    // Save the Excel file
    var fileBytes = excel.encode();
    File('sample_excel.xlsx').writeAsBytesSync(fileBytes!);
  }

  Future<void> _pickAndParseExcel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      var bytes = await file.readAsBytes();
      var excel = Excel.decodeBytes(bytes);
      
      setState(() {
        _data = excel.tables[excel.tables.keys.first]!.rows;
      });
    } else {
      // User canceled the picker
    }
  }
 

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
       body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickAndParseExcel,
              child: const Text('Upload Excel'),
            ),
            ElevatedButton(
              onPressed: _generateSampleExcel,
              child: const Text('Download sample file'),
            ),
            ElevatedButton(
              onPressed: _generatePDF,
              child: const Text('Generate PDF'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _data.isNotEmpty
                  ? DataTable(
                      columns: _data.isNotEmpty
                    ? [
                        DataColumn(label: Text(_data[0][0].value.toString())),
                        DataColumn(label: Text(_data[0][1].value.toString())),
                        DataColumn(label: Text(_data[0][2].value.toString())),
                        DataColumn(label: Text(_data[0][3].value.toString())),
                        const DataColumn(label: Text('Selected')),
                      ]
                    : [],
                      rows: _data
                          .asMap()
                          .entries
                          .where((entry) => entry.key != 0)
                          .map((entry) => DataRow(
                                cells: [
                                  DataCell(Text(entry.value[0].value.toString())),
                                  DataCell(Text(entry.value[1].value.toString())),
                                  DataCell(Text(entry.value[2].value.toString())),
                                  DataCell(Text(entry.value[3].value.toString())),
                                  DataCell(
                                    Checkbox(
                                      value: false,
                                      onChanged: (bool? value) {
                                        // setState(() {
                                        //   value;
                                        // });
                                      },
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    )
                  : Container(),
              ),
          ],
        ),
      ),
    );
  }
}
