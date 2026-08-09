import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

Widget autoSliderImage({List<Widget>? images}) {
  return CarouselSlider(
    items: images,
    options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
        aspectRatio: 1.2,
        autoPlayAnimationDuration: const Duration(milliseconds: 1200),
        onPageChanged: (index, reason) {}),
  );
}
