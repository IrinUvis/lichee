import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lichee/channels/services/read/read_channel_dto.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/screens/home/channel_list_view.dart';
import 'package:lichee/screens/home/home_screen_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final HomeScreenController _homeScreenController;

  @override
  void initState() {
    super.initState();
    _homeScreenController = HomeScreenController(
      Provider.of<FirebaseProvider>(
        context,
        listen: false,
      ).firestore,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              'Promoted channels',
              style: kBannerTextStyle,
            ),
            const SizedBox(height: 20.0),
            FutureBuilder(
              future: _homeScreenController.getPromotedChannels(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ReadChannelDto>> snapshot) {
                if (snapshot.hasData) {
                  return CarouselSlider(
                    options: CarouselOptions(
                      viewportFraction: 0.5,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: true,
                    ),
                    items: snapshot.data!
                        .map(
                          (channel) => ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: InkWell(
                              onTap: () async {
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
                                    channel.channelImageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                  Center(
                                    child: Text(
                                      channel.channelName,
                                      style: kBannerTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
            const SizedBox(height: 20.0),
            const Text(
              'Your channels',
              style: kBannerTextStyle,
            ),
            Expanded(
              child: ChannelListView(
                homeScreenController: _homeScreenController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
