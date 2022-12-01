import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

Future<Document> parseURL(String url) async {
  final httClient = http.Client();
  final uri = Uri.parse(url);
  final response = await httClient.get(uri);
  if (response.statusCode == 200) {
    return parser.parse(response.body);
  } else {
    httClient.close();
    throw Exception('The website is down');
  }
}
