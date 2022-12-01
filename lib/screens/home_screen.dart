import 'package:flutter/material.dart';
import 'package:pure_scans/models/webtoon_model.dart';
import 'package:pure_scans/screens/search_screen.dart';
import 'package:pure_scans/widgets/bookmarked_list_widget.dart';
import 'package:pure_scans/widgets/webtoon_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final Future<List<Webtoon>> _webtoons;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _webtoons = fetchLatest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Webtoon>>(
          future: _webtoons,
          builder: ((context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Error : ${snapshot.error}"),
                    IconButton(
                        onPressed: () {
                          Route route = MaterialPageRoute(
                              builder: (context) => const HomeScreen());
                          Navigator.pushReplacement(context, route);
                        },
                        icon: const Icon(Icons.refresh)),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              return ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10.0),
                    child: EasyAutocomplete(
                      asyncSuggestions: ((searchValue) async =>
                          autoComplete(searchValue)),
                      controller: searchController,
                      onChanged: (value) {},
                      onSubmitted: (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchScreen(
                              searchString: value,
                            ),
                          ),
                        );
                        searchController.text = "";
                      },
                      progressIndicatorBuilder: Builder(
                        builder: (context) => const CircularProgressIndicator(),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Rechercher...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const BookmarkedListWidget(),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: Text(
                      'Découvre les derniers chapitres',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.count(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
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
                  ),
                ],
              );
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
