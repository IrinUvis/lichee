import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/constants/constants.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReadChannelDto> promotedChannels = [];
  List<ReadChannelDto> recommendedChannels = [];

  Future<List<ReadChannelDto>> getPromotedChannels() async {
    promotedChannels = await ReadChannelService().getPromoted();
    return promotedChannels;
  }

  Future<List<ReadChannelDto>> getRecommendations() async {
    recommendedChannels = await ReadChannelService().getByCity(city: "Lodz");
    return recommendedChannels;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              decoration: kHomeSearchBarInputDecoration,
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
                            items: promotedChannels
                                .map((e) => ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: InkWell(
                                        onTap: () async {
                                          final channel =
                                              await ReadChannelService().getById(
                                                  id: promotedChannels[
                                                          promotedChannels
                                                              .indexOf(e)]
                                                      .channelId);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ChannelScreen(
                                                      channel: channel),
                                            ),
                                          );
                                        },
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              promotedChannels[
                                                      promotedChannels
                                                          .indexOf(e)]
                                                  .channelImageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                            Center(
                                              child: Text(
                                                promotedChannels[
                                                        promotedChannels
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
                          const SizedBox(height: 20.0),
                          Container(
                            height: 120.0,
                            decoration: BoxDecoration(
                              color: LicheeColors.greyColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
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
