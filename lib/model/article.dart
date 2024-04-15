import 'package:meta/meta.dart';

class Article {
  final String articleId;
  final String articleDescription;
  final String eancode;
  final String mrp;
  final String noOfCopies;
  final String selected;

  const Article({
    required this.articleId,
    required this.articleDescription,
    required this.eancode,
    required this.mrp,
    required this.noOfCopies,
    required this.selected,
  });

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        articleId: json['articleId'],
        articleDescription: json['articleDescription'],
        eancode: json['eancode'],
        mrp: json['mrp'],
        noOfCopies: json['noOfCopies'],
        selected: json['selected'],
      );

}