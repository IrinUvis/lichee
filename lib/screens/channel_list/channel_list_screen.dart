import 'package:flutter/material.dart';
import 'categories_tree_view.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: CategoriesTreeView(
            isChoosingCategoryForChannelAddingAvailable: false,
          ),
        ),
      ),
    );
  }
}
