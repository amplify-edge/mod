import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class ProjectImageCarousel extends StatelessWidget {
  final List<List<int>> images;

  const ProjectImageCarousel({Key key, @required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enableInfiniteScroll: true,
        autoPlay: true,
      ),
      items: [1, 2, 3, 4, 5].map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    color: Colors.amber
                ),
                child: Text('text $i', style: TextStyle(fontSize: 16.0),)
            );
          },
        );
      }).toList(),
    );
  }
}
