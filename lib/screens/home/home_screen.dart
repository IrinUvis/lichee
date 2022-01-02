import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/channels/services/read/read_channel_service.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ReadChannelDto> recommendedChannels = [];

  late final ReadChannelService _readChannelService;

  @override
  void initState() {
    super.initState();
    _readChannelService = ReadChannelService(
        firestore: Provider.of<FirebaseProvider>(
      context,
      listen: false,
    ).firestore);
  }

  Future<List<ReadChannelDto>> getPromotedChannels() async {
    recommendedChannels = await _readChannelService.getPromoted();
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
                          // TODO: Zakomentowane bo narazie nic to nie daje, ale może się przyda potem
                          // Container(
                          //   decoration: const BoxDecoration(
                          //     color: Color(0xFF363636),
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(50.0),
                          //     ),
                          //   ),
                          //   child: const TextField(
                          //     decoration: kHomeSearchBarInputDecoration,
                          //   ),
                          // ),
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
                                        onTap: () async {
                                          final channel =
                                              await _readChannelService
                                                  .getById(
                                                      id: recommendedChannels[
                                                              recommendedChannels
                                                                  .indexOf(e)]
                                                          .channelId);
                                          Navigator.pushNamed(
                                            context,
                                            ChannelScreen.id,
                                            arguments: channel,
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
                            'Your channels',
                            style: kBannerTextStyle,
                          ),
                          // TODO (AM chyba?) - sugestia: Może zrobić tu listę kanałów w któych się jest, bo brakuje czegoś takiego trochę
                          const Text(
                              'Może by tu zrobić po prostu listę kanałów w których się jest? Przyda się coś takiego a Adam nie zrobi ML'),
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
