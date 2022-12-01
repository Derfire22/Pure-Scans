import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/screens/webtoon_screen.dart';

class WebtoonWidget extends StatelessWidget {
  const WebtoonWidget({Key? key, required this.webtoon}) : super(key: key);

  final Webtoon webtoon;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: webtoon.image,
      child: Material(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WebtoonScreen(
                    webtoon: webtoon,
                  ),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl: webtoon.image,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) {
                return Center(
                  child: CircularProgressIndicator(value: progress.progress),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
