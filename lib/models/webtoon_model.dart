import 'package:dio/dio.dart';
import 'package:pure_scans/models/requests.dart';

class Webtoon {
  String name;
  String link;
  String image;

  Webtoon({required this.name, required this.link, required this.image});

  @override
  String toString() {
    return name;
  }
}

Future<List<Webtoon>> fetchLatest() async {
  List<Webtoon> webtoons = [];
  var res = await parseURL('https://reaperscans.fr/');
  var latest = res.querySelector("section.latest");
  var containers =
      latest?.querySelectorAll("div.col-6.col-sm-6.col-md-6.col-xl-3");
  for (var container in containers!) {
    String? link = container.querySelector('a')?.attributes['href'];
    String? image = container.querySelector('img')?.attributes['src'];
    String? name = container.querySelector('h5')?.text;
    webtoons
        .add(Webtoon(name: name ?? '', link: link ?? '', image: image ?? ''));
  }
  return webtoons;
}

Future<String> fetchDescription(Webtoon webtoon) async {
  var res = await parseURL(webtoon.link);
  var container = res.querySelector('div.description-summary');
  if (container?.querySelector('p') != null) {
    return container?.querySelector('p')?.text ?? '';
  } else {
    return '';
  }
}

Future<List<String>> autoComplete(String title) async {
  if (title == '') {
    return [];
  } else {
    var response = await Dio().post(
      'https://reaperscans.fr/wp-admin/admin-ajax.php',
      data:
          FormData.fromMap({'action': 'wp-manga-search-manga', 'title': title}),
      options: Options(
          contentType: 'application/x-www-form-urlencoded; charset=UTF-8'),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonRes = response.data;
      if (jsonRes['success'] == false) return [];
      List<String> suggestions = [];
      var webtoons = jsonRes['data'];
      for (var webtoon in webtoons) {
        if (webtoon != null) {
          suggestions.add(webtoon['title']);
        }
      }
      return suggestions;
    } else {
      return [];
    }
  }
}

Future<List<Webtoon>> search(String title) async {
  List<Webtoon> webtoons = [];
  var res =
      await parseURL("https://reaperscans.fr/?s=$title&post_type=wp-manga");
  var webtoonContainers = res.querySelectorAll('.row.c-tabs-item__content');
  for (var webtoonContainer in webtoonContainers) {
    var aElement = webtoonContainer.querySelector('a');
    String? link = aElement?.attributes['href'];
    String? name = aElement?.attributes['title'];
    String? image = aElement
        ?.querySelector('img')
        ?.attributes['src']
        ?.replaceAll("-193x278", "");
    webtoons
        .add(Webtoon(name: name ?? '', link: link ?? '', image: image ?? ''));
  }
  return webtoons;
}
