import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/model_news.dart';

import 'package:http/http.dart';
import 'model_news.dart';

class categoryNews extends StatefulWidget {
  String? category;

  categoryNews({required this.category});

  @override
  State<categoryNews> createState() => _categoryNewsState();
}

class _categoryNewsState extends State<categoryNews> {
  List<newsModel> filteredNews = <newsModel>[];
  bool isLoading = true;
  int total = 15;
  String? search;

  void getNews(String query) async {
    filteredNews.clear();
    setState(() {
      isLoading=true;
    });
    search = query;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2023-07-26&sortBy=publishedAt&apiKey=840643388dd0483f86cdc7084a265e53";
    Response res = await get(Uri.parse(url)); // import http library
    Map data = jsonDecode(res.body); // import convert library

    data["articles"].forEach((news) {
      total += 10;
      newsModel news_instance = new newsModel();
      news_instance = newsModel.fromMap(news);
      if (news_instance.newsImg.toString().isNotEmpty &&
          filteredNews.length < total) {
        filteredNews.add(news_instance);
      }
    });
    filteredNews.reversed;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews(widget.category.toString());
  }

  ScrollController scrolling = new ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Noticias"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: scrolling,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              child: Row(
                // used so that we can keep the text at the starting
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "$search",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
            ),
            Container(
              child: ListView.builder(
                  shrinkWrap:
                      true, // while using builder inside a colum always used used shrink wrap
                  itemCount: filteredNews.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Card(
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Stack(
                          children: [
                            ClipRRect(
                              // clipRrect is used to make image circle corners
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                filteredNews[index].newsImg.toString(),
                                fit: BoxFit.fitHeight,
                                height: 230,
                                width: double.infinity,
                              ),
                            ),
                            Positioned(
                              left:
                                  0, // when left and right are both zero then the image is streched
                              right: 0,
                              bottom: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    gradient: LinearGradient(
                                        colors: [
                                          // if you want to apply transparency to a color, you can achieve this by creating a new color with a modified opacity.
                                          Colors.black12.withOpacity(0),
                                          Colors.black
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter)),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 15, 10, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      filteredNews[index]
                                          .newsheadline
                                          .toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      filteredNews[index]
                                                  .newsDes
                                                  .toString()
                                                  .length >
                                              50
                                          ? filteredNews[index]
                                                  .newsDes
                                                  .toString()
                                                  .substring(0, 55) +
                                              "... ... ..."
                                          : filteredNews[index]
                                              .newsDes
                                              .toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
              child: Row(
                // row is created to keep the text at the starting
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      child: const Text(
                        "Show More ",
                        style: TextStyle(color: Colors.black87),
                      ),
                      onPressed: () {
                        scrolling.animateTo(
                          0, // The position to scroll to
                          duration: Duration(
                              milliseconds:
                                  300), // The duration of the scroll animation
                          curve: Curves
                              .easeInOut, // The easing curve for the animation
                        );
                        getNews("$search");
                      },
                      style: ElevatedButton.styleFrom(
                          // to give style to the button
                          // Set your desired background color
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                              // for corners always use shape property
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Colors.black,
                                  width: 2)))) // setting the border of a button
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
