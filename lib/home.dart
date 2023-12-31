import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/category.dart';
import 'package:news_app/model_news.dart';

import 'package:http/http.dart';
import 'package:news_app/newsView.dart';
import 'model_news.dart';

final List<newsModel> topheadlines = <newsModel>[];
TextEditingController searchController = TextEditingController();
int _current = 0;
final CarouselController _controller = CarouselController();
bool isLoading = true;
bool isloading_head=true;

// created a list of latestNewsList
List<newsModel> latestNewsList = <newsModel>[];

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNews("top-headlines");
    getFilterNews("top-headlines");
  }

  Future<void> getFilterNews(String filter) async {
    String url =
        "https://newsapi.org/v2/$filter?country=in&apiKey=840643388dd0483f86cdc7084a265e53";
    Response res = await get(Uri.parse(url)); // import http library
    Map data = jsonDecode(res.body);

    data["articles"].forEach((news) {
      newsModel news_instance = new newsModel();
      news_instance = newsModel.fromMap(news);
      if (news_instance.newsImg.toString().isNotEmpty &&
          topheadlines.length < 6) {
        topheadlines.add(news_instance);
      }
    });

    data_check(topheadlines);

    setState(() {
      isloading_head = false;
    });
  }

  void getNews(String query) async {
    latestNewsList.clear();
    String url =
        "https://newsapi.org/v2/$query?country=in&apiKey=994e4b2b5eb943f6b19aea29fee7e611";
    Response res = await get(Uri.parse(url)); // import http library
    Map data = jsonDecode(res.body);

    data["articles"].forEach((news) {
      newsModel news_instance = new newsModel();
      news_instance = newsModel.fromMap(news);
      if (news_instance.newsImg.toString().isNotEmpty &&
          latestNewsList.length < 25) {
        latestNewsList.add(news_instance);
      }
    });

    latestNewsList.reversed;
    data_check(latestNewsList);
    setState(() {
      isLoading = false;
    });
  }


  void data_check(List<newsModel> NewsList){
    NewsList.forEach((element) {
      if (element.newsDes == null) {
          element.newsDes="Tap to View More";
        
      }

      if (element.newsImg == null) {
          element.newsImg="https://images.unsplash.com/photo-1586339949916-3e9457bef6d3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80";
        
      }

      if (element.newsheadline == null) {
          element.newsheadline="Big Breaking in the town";
        
      }

      if (element.newsUrl == null) {
          element.newsUrl="https://www.aajtak.in/";
        
      }

    });
  }

 

  //   // i=0;
  //   // using for loop for(element in data['articles']){
  //   //        i++;
  //   // }



  void getCheck() {
    print("handle called");
  }

  List<String> navbarItem = [
    "Top News ",
    "India ",
    "Finance",
    "Sport",
    "Space",
    "Technology",
    "Entertainment"
  ];
  @override
  Widget build(BuildContext context) {
    getCheck();
    TextEditingController searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Noticias"),
        centerTitle: true,
      ),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24)),
                padding: const EdgeInsets.symmetric(horizontal: 8),
                margin:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                child: Row(children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      String search = searchController.text;
                      if ((search.replaceAll(" ", "")) != "" && search.isNotEmpty) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    categoryNews(category: search)));
                      } else {}
                    },
                    child: Container(
                        margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                        child: const Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        )),
                  ),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction
                          .search, // used to set the icon of the key board entry
                      // enter button of the keyboard functionality is set by this method
                      onSubmitted: (value) {
                        // value we get from our text field
                        String search = searchController.text;
                        if ((search.replaceAll(" ", "")) != "") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      categoryNews(category: search)));
                        } else {}
                        print(value);
                      },
                      style: const TextStyle(
                          fontFamily: AutofillHints.email,
                          fontWeight: FontWeight.w600),
                      controller: searchController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Look What is Happening In the world",
                          hintStyle: TextStyle(
                              fontFamily: AutofillHints.email,
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                  Container(
                      margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                      child: const Icon(
                        Icons.filter_alt_outlined,
                        color: Colors.green,
                      ))
                ]),
              ),
              Container(
                height: 50, // height have to be fixes
                child:  ListView.builder(
                  shrinkWrap: true, // when you are in column always give true
                  scrollDirection: Axis.horizontal,
                  itemCount: navbarItem.length,
                  itemBuilder: (context, index) {
                    // you have to return the widget of single entity
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    categoryNews(category: navbarItem[index])));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        // in order to sharpen the corners
                        child: Center(
                          child: Text(
                            navbarItem[index],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
               Container(
                margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                child:isloading_head ? Center(child: CircularProgressIndicator()) :  CarouselSlider(
                  // carlos import dependency as well as library
                  items: topheadlines.map((item) {
                    // items should have the widgets as thiss will ging to scroll in the widget
                    return Builder(builder: ((BuildContext context) {
                      // builder function
                      return  Container(
                        child: InkWell(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      newsView(url: item.newsUrl.toString())));
                          },
                          child: Container(
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      child: Image.network(
                                        item.newsImg.toString(),
                                        fit: BoxFit.fitHeight,
                                        height: 230,
                                        width: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                              colors: [
                                                // if you want to apply transparency to a color, you can achieve this by creating a new color with a modified opacity.
                                                Colors.black12.withOpacity(0),
                                                Colors.black
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter)),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 15, 10, 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.newsheadline.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }));
                  }).toList(), // widget builder
                  carouselController: _controller, // controller
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.0,
                    // scrollDirection: Axis.vertical, scroll direction set
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 8, 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  children: [
                    Row(
                      // used so that we can keep the text at the starting
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "LATEST NEWS  ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: isLoading ?  CircularProgressIndicator(): ListView.builder(
                    shrinkWrap:
                        true, // while using builder inside a colum always used used shrink wrap
                    itemCount: latestNewsList.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      newsView(url: latestNewsList[index].newsUrl.toString())));
                        },
                        child: Container(
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
                                    latestNewsList[index].newsImg.toString(),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          latestNewsList[index]
                                              .newsheadline
                                              .toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          latestNewsList[index]
                                                      .newsDes
                                                      .toString()
                                                      .length >
                                                  50
                                              ? latestNewsList[index]
                                                      .newsDes
                                                      .toString()
                                                      .substring(0, 55) +
                                                  "... ... ..."
                                              : latestNewsList[index]
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
                        ),
                      );
                    }),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: isLoading ? Container() : Row(
                  // row is created to keep the text at the starting
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: const Text(
                          "Show More ",
                          style: TextStyle(color: Colors.black87),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      categoryNews(category: "top-headlines")));
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
                                    width:
                                        2)))) // setting the border of a button
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// () {}  () => things that will return by the function

// final List<Widget> wid_build = topheadlines
//     .map((item) => Container(
//             // this return a widget that get stored in the list
//             child: Container(
//               child: InkWell(
//                 child: Container(
//               child: Card(
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: Container(
//                         color: Colors.black,)
//                     ),
//                     Positioned(
//                       left: 0,
//                       right: 0,
//                       bottom: 0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(15),
//                             gradient: LinearGradient(
//                                 colors: [
//                                   // if you want to apply transparency to a color, you can achieve this by creating a new color with a modified opacity.
//                                   Colors.black12.withOpacity(0),
//                                   Colors.black
//                                 ],
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter)),
//                         padding: const EdgeInsets.fromLTRB(10, 15, 10, 8),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children:const  [
//                             Text(
//                               "News Headline",
//                               style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//                       ),
//                     ),
//             )))
//     .toList();
