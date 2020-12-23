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
      items: images.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return ClipOval(
              child: Image.memory(
                Uint8List.fromList(i),
                height: 200,
                width: 360,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
