import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news_app/slideshow.dart';

class slideshow extends StatefulWidget {
  const slideshow({super.key});

  @override
  State<slideshow> createState() => _slideshowState();
}

class _slideshowState extends State<slideshow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: CarouselSlider(
            items: slide_items.map((list_item) { // items should have the widgets as thiss will ging to scroll in the widget 
              return Builder(builder: ((BuildContext context) { // builder function 
                return Container(
                  decoration: BoxDecoration(
                    color: list_item,
                  ),
                );
              }));
            }).toList(), // neccassary to do 
            options: CarouselOptions(  // options is done to set the property of the slider show 
                height: 200,  // neccassary to set height of the each slide 
                enlargeCenterPage: true, // centre each slide 
                autoPlay: true, // autoplay 
                enableInfiniteScroll: true // infinite scroll
                )),
      ),
    );
  }

  final List slide_items = [Colors.black, Colors.blue, Colors.red, Colors.red];
}
