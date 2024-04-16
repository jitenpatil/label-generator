import 'dart:convert';

import 'package:excel_to_json/excel_to_json.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_application_2/model/Article.dart';

class DataTableDemo extends StatefulWidget {
  //
  const DataTableDemo({super.key});

  final String title = 'Flutter Data Table';

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

// Now we will write a class that will help in searching.
// This is called a Debouncer class.
// I have made other videos explaining about the debouncer classes
// The link is provided in the description or tap the 'i' button on the right corner of the video.
// The Debouncer class helps to add a delay to the search
// that means when the class will wait for the user to stop for a defined time
// and then start searching
// So if the user is continuosly typing without any delay, it wont search
// This helps to keep the app more performant and if the search is directly hitting the server
// it keeps less hit on the server as well.
// Lets write the Debouncer class



class DataTableDemoState extends State<DataTableDemo> {
  late List<Article> _articles;
  late List<Article> _selectedArticles;
  late String _titleProgress;
 

  @override
  void initState() {
    super.initState();
    _articles = [];
    _titleProgress = widget.title;
  }

  // Method to update title in the AppBar Title
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  static List<Article> _getArticles() {
    return <Article>[
      const Article(articleId: 410210222, articleDescription: "Jackson", eancode: 89078999, mrp: 44, noOfCopies: 3, selected: 'N'),
      const Article(articleId: 410210223, articleDescription: "Jiten", eancode: 89079000, mrp: 54, noOfCopies: 2, selected: 'N'),
      const Article(articleId: 410210224, articleDescription: "Jeet", eancode: 89079001, mrp: 64, noOfCopies: 2, selected: 'N'),
    ];
  }

  static List<Article> parseResponse(String responseBody) {
    print(json.decode(responseBody));
    var excelJson = json.decode(responseBody);
    var excelArticles = excelJson['Sheet1'];
    final parsed = excelArticles.cast<Map<String, dynamic>>();
    return parsed.map<Article>((json) => Article.fromJson(json)).toList();
  }
  // _getArticles() {
  //   _showProgress('Loading Employees...');
  //     var articles = [
  //       {
  //         "articleId": "1",
  //         "articleDescription": "A",
  //         "mrp": "4",
  //         "eancode": "444",
  //         "noOfCopies": "2"
  //       },
  //       {
  //         "articleId": "2",
  //         "articleDescription": "AB",
  //         "mrp": "42",
  //         "eancode": "44422",
  //         "noOfCopies": "2"
  //       },
  //       {
  //         "articleId": "3",
  //         "articleDescription": "ABC",
  //         "mrp": "455",
  //         "eancode": "455",
  //         "noOfCopies": "5"
  //       }
  //     ];
  //     setState(() {
  //       _articles = articles;

  //     });
  //     _showProgress(widget.title); // Reset the title...
      
    
  // }


  // Let's create a DataTable and show the employee list in it.
  SingleChildScrollView _dataBody() {
    // Both Vertical and Horozontal Scrollview for the DataTable to
    // scroll both Vertical and Horizontal...
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: const [
            DataColumn(
              label: Text('Article Id'),
            ),
            DataColumn(
              label: Text('Article Description'),
            ),
            DataColumn(
              label: Text('Eancode'),
            ),
            // Lets add one more column to show a delete button
            DataColumn(
              label: Text('MRP'),
            ),
            DataColumn(
              label: Text('No of copies'),
            ),
            DataColumn(
              label: Text('Selected'),
            )
          ],
          // the list should show the filtered list now
          rows: _articles
              .map(
                (article) => DataRow(cells: [
                  const DataCell(
                      Text('C')
                      // article.mrp as Widget,
                    
                    
                  ),
                  DataCell(
                    Text(
                      article.articleDescription,
                    ),
                    
                  ),
                  const DataCell(
                      Text('B')
                      // article.mrp as Widget,
                    
                    
                  ),
                   const DataCell(
                      Text('A')
                      // article.mrp as Widget,
                    
                    
                  ),
                   const DataCell(
                      Text('D')
                      // article.mrp as Widget,
                    
                    
                  ),
                  DataCell(IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      
                    },
                  ))
                ]),
              )
              .toList(),
        ),
      ),
    );
  }

  
  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title:  Row(
            children: <Widget>[
            ElevatedButton(onPressed: () async {
                        String? excel = await ExcelToJson().convert();
                        
  
                          print(excel);
                            List<Article> list = parseResponse(excel!);
                            print(list);
                          setState(() {
                            _articles=list;
                          });
                          
                        
            }, child: const Text('Upload Excel')),
            const SizedBox(width: 20),
            ElevatedButton(onPressed: (){}, child: const Text('Download sample file')),
            const SizedBox(width: 20),
            ElevatedButton(onPressed: (){}, child: const Text('Clear')),
            const SizedBox(width: 20),
            ElevatedButton(onPressed: (){}, child: const Text('Generate Pdf')),
            const SizedBox(width: 300),
            const Text('Selected Articles:')
          ]
          ),
  
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _dataBody(),
          ),
        ],
      )
    );
  }
}
