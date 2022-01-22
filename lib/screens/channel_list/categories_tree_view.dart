import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/constants/icons.dart';
import 'package:lichee/providers/firebase_provider.dart';
import 'package:lichee/screens/channel/channel_screen.dart';
import 'package:lichee/screens/channel_list/channel_list_controller.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';
import 'package:provider/provider.dart';

class CategoriesTreeView extends StatefulWidget {
  const CategoriesTreeView(
      {Key? key, required this.isChoosingCategoryForChannelAddingAvailable})
      : super(key: key);

  final bool isChoosingCategoryForChannelAddingAvailable;

  @override
  _CategoriesTreeViewState createState() => _CategoriesTreeViewState();
}

class _CategoriesTreeViewState extends State<CategoriesTreeView> {
  List<String>? selectedFiltersList = [];
  List<String> parentIdStack = [];
  List<String> citiesList = [];
  List<String> idsOfChannelsFromCity = [];

  String parentId = '';
  bool isLastCategory = false;

  late final ChannelListController _channelListController;

  @override
  void initState() {
    super.initState();
    _channelListController = ChannelListController(
        firestore:
            Provider.of<FirebaseProvider>(context, listen: false).firestore);
    _channelListController.getCitiesFromChannels(citiesList: citiesList);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              key: const Key('homeButton'),
              onPressed: _resetCategoriesTreeView,
              child: kResetCategoriesTreeViewIcon,
              style: kPinkRoundedButtonStyle,
            ),
            ElevatedButton(
              key: const Key('citiesButton'),
              onPressed: _openFilterDialog,
              child: kCategoriesTreeViewFiltersButtonText,
              style: kPinkRoundedButtonStyle,
            ),
            ElevatedButton(
              key: const Key('returnButton'),
              onPressed: _returnToUpperLevelInCategoriesTreeView,
              child: kReturnToUpperLevelInTreeViewIcon,
              style: kPinkRoundedButtonStyle,
            ),
          ],
        ),
        Expanded(
          child: Container(
            color: LicheeColors.backgroundColor,
            child: _getNodesTree(),
          ),
        ),
        widget.isChoosingCategoryForChannelAddingAvailable
            ? isLastCategory
                ? ElevatedButton(
                    onPressed: () => Navigator.pop(context, parentId),
                    child: kChooseCategoryForAddingChannelButtonText,
                    style: kPinkRoundedButtonStyle,
                  )
                : Container()
            : Container(),
      ],
    );
  }

  StreamBuilder<QuerySnapshot> _getNodesTree() {
    return StreamBuilder(
      stream: _channelListController.getCategoriesStream(parentId: parentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final nodesList = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          final nodesArray = snapshot.data!.docs;
          return nodesList.isNotEmpty
              ? ListView.builder(
                  itemCount: nodesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (idsOfChannelsFromCity.isEmpty ||
                        nodesList[index]['type'] == 'category' ||
                        (nodesList[index]['type'] == 'channel' &&
                            idsOfChannelsFromCity
                                .contains(nodesArray[index].id))) {
                      return TextButton(
                        onPressed: nodesList[index]['type'] == 'channel'
                            ? () async {
                                await _openChannel(nodesArray, index, context);
                              }
                            : () {
                                _openCategory(nodesList, nodesArray, index);
                              },
                        child: TreeNodeCard(
                          name: nodesList[index]['name'],
                          type: nodesList[index]['type'],
                          childrenIds: List.from(
                            nodesList[index]['childrenIds'],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      kEmptyCategoryText,
                      SizedBox(height: 10.0),
                      kEmptyCategoryIcon,
                    ],
                  ),
                );
        }
      },
    );
  }

  Future<void> _openChannel(List<QueryDocumentSnapshot<Object?>> nodesArray,
      int index, BuildContext context) async {
    final channel = await _channelListController.getChannelById(
        channelId: nodesArray[index].id);
    Navigator.pushNamed(context, ChannelScreen.id, arguments: channel);
  }

  void _resetCategoriesTreeView() {
    setState(() {
      parentId = '';
      parentIdStack.clear();
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        isLastCategory = false;
      }
    });
  }

  void _returnToUpperLevelInCategoriesTreeView() {
    setState(() {
      if (parentIdStack.isNotEmpty) {
        parentId = parentIdStack.removeLast();
      }
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        isLastCategory = false;
      }
    });
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      listData: citiesList,
      selectedListData: selectedFiltersList,
      enableOnlySingleSelection: true,
      hideSelectedTextCount: true,
      backgroundColor: const Color(0xFF1A1A1A),
      searchFieldBackgroundColor: Colors.pinkAccent,
      selectedTextBackgroundColor: Colors.pinkAccent,
      applyButonTextBackgroundColor: Colors.pinkAccent,
      closeIconColor: Colors.white,
      headerTextColor: Colors.white,
      applyButtonTextStyle: const TextStyle(color: Colors.white),
      searchFieldTextStyle: const TextStyle(color: Colors.white),
      controlButtonTextStyle: const TextStyle(color: Colors.black),
      headlineText: 'Select city',
      searchFieldHintText: 'Search Here',
      selectedItemsText: 'selected filters',
      choiceChipLabel: (item) {
        return item;
      },
      validateSelectedItem: (list, val) {
        return list!.contains(val);
      },
      onItemSearch: (list, text) {
        if (list != null) {
          if (list.any((element) =>
              element.toLowerCase().contains(text.toLowerCase()))) {
            return list
                .where((element) =>
                    element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        }
        return [];
      },
      onApplyButtonClick: (list) async {
        selectedFiltersList = List.from(list!);
        idsOfChannelsFromCity.clear();
        _channelListController.getChannelsFromCity(
            selectedFiltersList, idsOfChannelsFromCity);
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  void _openCategory(List<Map<String, dynamic>> nodesList,
      List<QueryDocumentSnapshot<Object?>> nodesArray, int index) {
    setState(() {
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        isLastCategory = nodesList[index]['isLastCategory'];
      }
      parentIdStack.add(parentId);
      parentId = nodesArray[index].id;
    });
  }
}
