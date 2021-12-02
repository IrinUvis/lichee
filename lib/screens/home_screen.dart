import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lichee/screens/channel_screen.dart';
import '../constants.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> recommendationList = [
    "https://www.fivb.org/Vis2009/Images/GetImage.asmx?No=202004911&width=920&height=588&stretch=uniformtofill",
    "https://photoresources.wtatennis.com/photo-resources/2019/08/15/dbb59626-9254-4426-915e-57397b6d6635/tennis-origins-e1444901660593.jpg?width=1200&height=630",
    "https://images.chesscomfiles.com/uploads/v1/article/27319.746c2259.668x375o.c6cf8543e2d5@2x.png",
  ];

  final List<String> channelNames = [
    'Volleyball',
    'Tennis',
    'Chess',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0.0,
        backgroundColor: const Color(0xFF1A1A1A),
        title: const Center(
          child: Text(
            //ofc we should put logo here but for now...
            'Lichee',
            style: kLicheeTextStyle,
          ),
        ),
      ),
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
                        decoration: kSearchBarInputDecoration,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    const Text(
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
                                child: InkWell(
                                  onTap: () {
                                    // Navigator.pushNamed(context, ChannelScreen.id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChannelScreen(
                                            channelName: channelNames[
                                                recommendationList.indexOf(e)], imageSource: recommendationList[recommendationList.indexOf(e)],),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Image.network(
                                        e,
                                        fit: BoxFit.cover,
                                      ),
                                      Center(
                                        child: Text(
                                          channelNames[
                                              recommendationList.indexOf(e)],
                                          style: kBannerTextStyle,
                                        ),
                                      ),
                                    ],
                                  ),
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
              size: 30.0,
            ),
            label: 'Main',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.chat_outlined,
              size: 30.0,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              size: 30.0,
            ),
            label: 'Add event',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.notifications_outlined,
              size: 30.0,
            ),
            label: 'Add event',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline_rounded,
              size: 30.0,
            ),
            label: 'Add event',
          )
        ],
      ),
    );
  }
}
