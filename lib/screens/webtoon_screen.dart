import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pure_scans/models/webtoon_chapiter_model.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/widgets/webtoon_chapiter_widget.dart';
import 'package:expandable_text/expandable_text.dart';

class WebtoonScreen extends StatefulWidget {
  const WebtoonScreen({Key? key, required this.webtoon}) : super(key: key);

  final Webtoon webtoon;

  @override
  State<WebtoonScreen> createState() => _WebtoonScreenState();
}

class _WebtoonScreenState extends State<WebtoonScreen> {
  late final Future<List<WebtoonChapiter>> _chapiters;
  late final Future<String> _description;

  @override
  void initState() {
    super.initState();
    _chapiters = fetchChapiters(widget.webtoon.link);
    _description = fetchDescription(widget.webtoon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Container(
              foregroundDecoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Theme.of(context).backgroundColor,
                  ],
                ),
              ),
              child: Hero(
                tag: widget.webtoon.image,
                child: Material(
                  child: CachedNetworkImage(
                    imageUrl: widget.webtoon.image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, progress) {
                      return Center(
                        child:
                            CircularProgressIndicator(value: progress.progress),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.webtoon.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: FutureBuilder<String>(
                      future: _description,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data != null) {
                            return ExpandableText(
                              snapshot.data ?? '',
                              expandText: "Afficher plus",
                              collapseText: "Afficher moins",
                              maxLines: 5,
                              animation: true,
                              style: Theme.of(context).textTheme.bodyMedium,
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        } else if (snapshot.hasError) {
                          return Text(
                            "Failed to load description.",
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                    ),
                  ),
                  FutureBuilder<List<WebtoonChapiter>>(
                    future: _chapiters,
                    builder: ((context, snapshot) {
                      if (snapshot.hasData) {
                        return GridView.count(
                          reverse: false,
                          crossAxisCount: 1,
                          childAspectRatio: 3 / 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: const ClampingScrollPhysics(),
                          children: List.generate(
                            snapshot.data!.length,
                            (index) => WebtoonChapiterWidget(
                              webtoon: widget.webtoon,
                              chapiter: WebtoonChapiter(
                                link: snapshot.data![index].link,
                                image: snapshot.data![index].image,
                                name: snapshot.data![index].name,
                                date: snapshot.data![index].date,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
