import 'package:pure_scans/models/requests.dart';
import 'package:pure_scans/models/webtoon_chapiter_model.dart';

Future<List<String>> fetchPages(WebtoonChapiter chapiter) async {
  List<String> pages = [];

  var res = await parseURL(chapiter.link);
  var pagesContainer = res.querySelector("div.reading-content");
  var pagesElements = pagesContainer?.getElementsByTagName('img');
  for (var page in pagesElements!) {
    pages.add(page.attributes['src']?.trim() ?? '');
  }
  return pages;
}
