import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../constants.dart';

class HomeScreen extends StatelessWidget {
  static String id = 'home_screen';

  final List<String> recommendationList = [
    "https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill",
    "https://photoresources.wtatennis.com/photo-resources/2019/08/15/dbb59626-9254-4426-915e-57397b6d6635/tennis-origins-e1444901660593.jpg?width=1200&height=630",
    "https://images.chesscomfiles.com/uploads/v1/article/27319.746c2259.668x375o.c6cf8543e2d5@2x.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF363636),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      child: const TextField(
                        decoration: kHomeSearchBarInputDecoration,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Promoted channels',
                      style: kBannerTextStyle,
                    ),
                    SizedBox(height: 20.0),
                    CarouselSlider(
                      options: CarouselOptions(
                        viewportFraction: 0.5,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                      ),
                      items: recommendationList
                          .map((e) => ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.network(
                                      e,
                                      fit: BoxFit.cover,
                                    ),
                                    Center(child: Text('Text', style: kBannerTextStyle,)),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Selected for you',
                      style: kBannerTextStyle,
                    ),
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
