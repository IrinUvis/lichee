import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/screens/channel_screen.dart';
import '../constants/constants.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<ReadChannelDto> recommendedChannels;

  late ReadChannelDto channel;

  Future<ReadChannelDto> getChannel() async {
    channel = await ReadChannelService().getById(id: 'testChannel');
    return channel;
  }

  Future<List<ReadChannelDto>> getPromotedChannels() async {
    recommendedChannels = await ReadChannelService().getPromoted();
    return recommendedChannels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 0.0,
        backgroundColor: LicheeColors.backgroundColor,
        title: const Center(
          child: Text(
            //ofc we should put logo here but for now...
            'Lichee',
            style: kLicheeTextStyle,
          ),
        ),
      ),
      body: FutureBuilder(
        future: getPromotedChannels(),
        builder: (BuildContext context,
            AsyncSnapshot<List<ReadChannelDto>> snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
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
                          const SizedBox(height: 20.0),
                          const Text(
                            'Promoted channels',
                            style: kBannerTextStyle,
                          ),
                          const SizedBox(height: 20.0),
                          CarouselSlider(
                            options: CarouselOptions(
                              viewportFraction: 0.5,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                            ),
                            items: recommendedChannels
                                .map((e) => ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChannelScreen(
                                                channel:
                                                    recommendedChannels[
                                                            recommendedChannels
                                                                .indexOf(e)],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              recommendedChannels[
                                                      recommendedChannels
                                                          .indexOf(e)]
                                                  .channelImageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                            Center(
                                              child: Text(
                                                recommendedChannels[
                                                        recommendedChannels
                                                            .indexOf(e)]
                                                    .channelName,
                                                style: kBannerTextStyle,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Selected for you',
                            style: kBannerTextStyle,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: LicheeColors.primary,
              ),
            );
          }
        },
      ),
    );
  }
}
