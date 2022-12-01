import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';
import 'package:pure_scans/models/webtoon_chapiter_model.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/screens/read_screen.dart';
import 'package:pure_scans/screens/webtoon_screen.dart';

class BookmarkedListWidget extends StatefulWidget {
  const BookmarkedListWidget({Key? key}) : super(key: key);

  @override
  State<BookmarkedListWidget> createState() => _BookmarkedListWidgetState();
}

class _BookmarkedListWidgetState extends State<BookmarkedListWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('bookmarked').listenable(),
      builder: (context, Box<dynamic> box, widget) {
        if (box.length > 0) {
          List<Map<String, dynamic>> bookmarks = [];
          box.toMap().forEach((key, value) {
            bookmarks.add({'webtoon': key, 'data': value});
          });

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, bottom: 20.0),
                child: Text(
                  "Continue tes lectures",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              SizedBox(
                height: 150,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: GridView.count(
                    scrollDirection: Axis.horizontal,
                    crossAxisCount: 1,
                    childAspectRatio: 10 / 9,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(bookmarks.length, (index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: InkWell(
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          onLongPress: () => showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              title: Text(bookmarks[index]['webtoon']),
                              content: const Text(
                                  'Voulez-vous vraiment supprimer votre progression ?'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Annuler'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Hive.box('bookmarked')
                                        .delete(bookmarks[index]['webtoon']);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Oui'),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            final webtoon = Webtoon(
                              name: bookmarks[index]['webtoon'],
                              link: bookmarks[index]['data']['webtoon_link'],
                              image: bookmarks[index]['data']['webtoon_image'],
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => WebtoonScreen(
                                  webtoon: webtoon,
                                ),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReadScreen(
                                  webtoon: webtoon,
                                  chapiter: WebtoonChapiter(
                                      link: bookmarks[index]['data']
                                          ['chapiter_link'],
                                      image: bookmarks[index]['data']
                                          ['chapiter_image'],
                                      name: bookmarks[index]['data']
                                          ['chapiter_name'],
                                      date: ''),
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                foregroundDecoration: const BoxDecoration(
                                  gradient: RadialGradient(
                                    center: Alignment.center,
                                    radius: 1.5,
                                    colors: [
                                      Color.fromARGB(200, 0, 0, 0),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: bookmarks[index]['data']
                                      ['chapiter_image'],
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, url, progress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                          value: progress.progress),
                                    );
                                  },
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: AutoSizeText(
                                    bookmarks[index]['webtoon'],
                                    textAlign: TextAlign.center,
                                    minFontSize: 16,
                                    maxLines: 3,
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                    overflowReplacement: Marquee(
                                      text: bookmarks[index]['webtoon'],
                                      blankSpace: 100,
                                      accelerationCurve: Curves.easeOutCubic,
                                      velocity: 50,
                                      startPadding: 2.0,
                                      startAfter: const Duration(seconds: 3),
                                      pauseAfterRound:
                                          const Duration(seconds: 3),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              )
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
