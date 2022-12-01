import 'package:pure_scans/models/requests.dart';
import 'package:pure_scans/models/webtoon_model.dart';

class WebtoonChapiter {
  String link;
  String image;
  String name;
  String date;

  WebtoonChapiter(
      {required this.link,
      required this.image,
      required this.name,
      required this.date});
}

Future<List<WebtoonChapiter>> fetchChapiters(String webtoonLink) async {
  List<WebtoonChapiter> webtoonChapiters = [];

  var res = await parseURL(webtoonLink);
  var container = res.querySelector('ul.main.version-chap.no-volumn');
  var chapiters = container?.querySelectorAll('li');
  for (var chapiter in chapiters!) {
    String? link = chapiter.querySelector('a')!.attributes['href'];
    var imageContainer = chapiter.querySelector('img');
    String? image =
        imageContainer == null ? '' : imageContainer.attributes['src'];
    String? name = chapiter.querySelector('p')?.text;
    String? date = chapiter.querySelector('i')?.text;
    webtoonChapiters.add(WebtoonChapiter(
        link: link ?? '',
        image: image ?? '',
        name: name ?? '',
        date: date ?? ''));
  }
  return webtoonChapiters;
}

Future<WebtoonChapiter> fetchNextChapiter(
    Webtoon webtoon, WebtoonChapiter chapiter) async {
  // var res = await parseURL(chapiter.link);
  // var nextElement = res.querySelector("a.btn.next_page");
  // nextElement?.attributes['src'] ?? '';

  // final regexp = RegExp(r'(.*)\/.*\/');
  // final match = regexp.firstMatch(chapiter.link);
  // final webtoonLink = match?.group(1);

  var chapiters = await fetchChapiters(webtoon.link);

  for (var i = 0; i < chapiters.length; i++) {
    if (chapiters[i].link == chapiter.link && i != 0) {
      return chapiters[i - 1];
    }
  }
  return WebtoonChapiter(link: '', image: '', name: '', date: '');
}
