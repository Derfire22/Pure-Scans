import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/widgets/webtoon_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.searchString}) : super(key: key);

  final String searchString;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final Future<List<Webtoon>> _webtoons;
  @override
  void initState() {
    super.initState();
    _webtoons = search(widget.searchString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Résulat de la recherche",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder<List<Webtoon>>(
          future: _webtoons,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return const SizedBox.shrink();
            } else if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: List.generate(snapshot.data!.length, (index) {
                      return WebtoonWidget(
                          webtoon: Webtoon(
                        name: snapshot.data![index].name,
                        link: snapshot.data![index].link,
                        image: snapshot.data![index].image,
                      ));
                    }),
                  ),
                );
              } else {
                return Center(
                  child: Text(
                    "Aucun résultats",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              }
            } else {
              return Center(
                child: SpinKitFadingCube(
                  color: Theme.of(context).primaryColor,
                  duration: const Duration(milliseconds: 1000),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
