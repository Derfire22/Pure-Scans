import 'package:flutter/material.dart';
import 'package:pure_scans/models/webtoon_chapiter_model.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/screens/read_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WebtoonChapiterWidget extends StatelessWidget {
  const WebtoonChapiterWidget(
      {Key? key, required this.webtoon, required this.chapiter})
      : super(key: key);
  final Webtoon webtoon;
  final WebtoonChapiter chapiter;

  @override
  Widget build(BuildContext context) {
    if (chapiter.image == '') {
      return InkWell(
        splashColor: Theme.of(context).splashColor,
        hoverColor: Theme.of(context).hoverColor,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onTap: (() {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReadScreen(webtoon: webtoon, chapiter: chapiter),
            ),
          );
        }),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                width: 2.0,
                color: Theme.of(context).primaryColor,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                chapiter.name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Text(
                chapiter.date,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        onTap: (() {
          FocusScope.of(context).unfocus();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReadScreen(
                webtoon: webtoon,
                chapiter: chapiter,
              ),
            ),
          );
        }),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Container(
                foregroundDecoration: const BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 3.0,
                    colors: [
                      Color.fromARGB(140, 0, 0, 0),
                      Colors.transparent,
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width,
                child: CachedNetworkImage(
                  imageUrl: chapiter.image,
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    chapiter.name,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            Theme.of(context).textTheme.titleLarge!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.titleLarge!.fontWeight),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    chapiter.date,
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily:
                            Theme.of(context).textTheme.bodyMedium!.fontFamily,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                        fontWeight:
                            Theme.of(context).textTheme.bodyMedium!.fontWeight),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}
