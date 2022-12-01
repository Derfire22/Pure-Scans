import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pure_scans/models/webtoon_chapiter_model.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/models/webtoon_page_model.dart';
import 'package:pure_scans/widgets/next_indicator_widget.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({Key? key, required this.webtoon, required this.chapiter})
      : super(key: key);

  final Webtoon webtoon;
  final WebtoonChapiter chapiter;

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late final Future<List<String>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = fetchPages(widget.chapiter);

    Hive.box('bookmarked').put(widget.webtoon.name, {
      'webtoon_link': widget.webtoon.link,
      'webtoon_image': widget.webtoon.image,
      'chapiter_name': widget.chapiter.name,
      'chapiter_link': widget.chapiter.link,
      'chapiter_image': widget.chapiter.image.isEmpty
          ? widget.webtoon.image
          : widget.chapiter.image,
      'chapiter_page': 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: FutureBuilder<List<String>>(
        future: _pages,
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return InteractiveViewer(
              child: NextChapiterIndicator(
                onAction: () {
                  fetchNextChapiter(widget.webtoon, widget.chapiter)
                      .then((chapiter) {
                    if (chapiter.link.isEmpty) {
                      Navigator.pop(context);
                    } else {
                      Route route = MaterialPageRoute(
                          builder: (context) => ReadScreen(
                              webtoon: widget.webtoon, chapiter: chapiter));
                      Navigator.pushReplacement(context, route);
                    }
                  }).catchError((err) {});
                },
                child: ListView(
                  children: List.generate(snapshot.data!.length, (index) {
                    return CachedNetworkImage(
                      imageUrl: snapshot.data![index],
                      fit: BoxFit.fill,
                      errorWidget: (context, err, _) {
                        return const SizedBox.shrink();
                      },
                      progressIndicatorBuilder: (context, url, progress) {
                        return Container(
                          color: Theme.of(context).shadowColor,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: Center(
                              child: CircularProgressIndicator(
                                  value: progress.progress),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                children: [
                  Text("Error : ${snapshot.error}"),
                  IconButton(
                      onPressed: () {
                        Route route = MaterialPageRoute(
                            builder: (context) => ReadScreen(
                                webtoon: widget.webtoon,
                                chapiter: widget.chapiter));
                        Navigator.pushReplacement(context, route);
                      },
                      icon: const Icon(Icons.refresh)),
                ],
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      )),
    );
  }
}
