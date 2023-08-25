import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:news_app/model_news.dart';

import 'package:http/http.dart';
import 'model_news.dart';

final List items = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
  
];
final List<newsModel> filterNewsList=<newsModel>[];


class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  TextEditingController searchController = TextEditingController();
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool isLoading=true;

// created a list of latestNewsList
  List<newsModel> latestNewsList=<newsModel>[];



   Future<void> getFilterNews(String filter) async {
    String url="https://newsapi.org/v2/everything?q=$filter&from=2023-07-25&sortBy=publishedAt&apiKey=9fc29d16a36a4c228547d6a4c86387dc";
    Response res = await get(Uri.parse(url)); // import http library
    Map data=jsonDecode(res.body);
    setState(() {
      data["articles"].forEach((news){
        newsModel news_instance=new newsModel();
        news_instance =newsModel.fromMap(news);
        if(!news_instance.newsImg.toString().isEmpty && filterNewsList.length<6){
           filterNewsList.add(news_instance);
           print(news_instance.newsImg);
          //  items.add(news_instance.newsImg.toString());
        }
        
      });


    });

   }

   void getNews(String query) async{
    String url="https://newsapi.org/v2/everything?q=$query&from=2023-07-25&sortBy=publishedAt&apiKey=9fc29d16a36a4c228547d6a4c86387dc";
    Response res = await get(Uri.parse(url)); // import http library
    Map data=jsonDecode(res.body);
    setState(() {
      data["articles"].forEach((news){
        newsModel news_instance=new newsModel();
        news_instance =newsModel.fromMap(news);
        if(!news_instance.newsImg.toString().isEmpty && latestNewsList.length<25){
           latestNewsList.add(news_instance);
        }
        
      });
    });
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
    TextEditingController searchController = TextEditingController();
    // getNews("latest");
    getFilterNews("latest");
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
                      if ((search.replaceAll(" ", "")) != "") {
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
                child: ListView.builder(
                  shrinkWrap: true, // when you are in column always give true
                  scrollDirection: Axis.horizontal,
                  itemCount: navbarItem.length,
                  itemBuilder: (context, index) {
                    // you have to return the widget of single entity
                    return InkWell(
                      onTap: () {
                        print(navbarItem[index]);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(
                                15),),
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
                margin: EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                child: CarouselSlider(
                  // carlos import dependency as well as library
                  items: wid_build, // widget builder
                  carouselController: _controller, // controller
                  options: CarouselOptions(
                      autoPlay: true,
                      enlargeCenterPage: true,
                      // aspectRatio: 2.0,
                      // scrollDirection: Axis.vertical, scroll direction set
                      onPageChanged: (index, reason) {
                        // function on on page changed
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Row(
                // this code is related to the to that indiactor
                mainAxisAlignment: MainAxisAlignment.center,
                children: items.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Colors.blueAccent)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 8, 5),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: Column(
                  children: [
                    Row( // used so that we can keep the text at the starting 
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
                child: ListView.builder(
                    shrinkWrap:
                        true, // while using builder inside a colum always used used shrink wrap
                    itemCount: filterNewsList.length,
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
                              ClipRRect( // clipRrect is used to make image circle corners
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(filterNewsList[index].newsImg.toString(),fit:BoxFit.fitHeight,height: 230,width: double.infinity,),
                              ),
                              Positioned(
                                left: 0, // when left and right are both zero then the image is streched 
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
                                        filterNewsList[index].newsheadline.toString(),
                                        style:const  TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        filterNewsList[index].newsDes.toString().length>50 ? filterNewsList[index].newsDes.toString().substring(0,55)+"... ... ..." : filterNewsList[index].newsDes.toString(),
                                        style:const  TextStyle(
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
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Row( // row is created to keep the text at the starting 
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        child: const Text(
                          "Show More ", style: TextStyle(color: Colors.black87),
                        ),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom( // to give style to the button
                            // Set your desired background color
                            backgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder( // for corners always use shape property 
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.black ,width: 2)))) // setting the border of a button

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

final List<Widget> wid_build = items
    .map((item) => Container(
            // this return a widget that get stored in the list
            child: Container(
              child: InkWell(
                child: Container(
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:Image.network(item, fit: BoxFit.cover, width: 1000.0),),
                    Positioned(
                      left: 0,
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
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:const  [
                            Text(
                              "News Headline",
                              style: TextStyle(
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
            )))
    .toList();

// final List<Widget> wid_build = filterNewsList
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
