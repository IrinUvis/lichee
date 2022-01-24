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
  CategoriesTreeViewState createState() => CategoriesTreeViewState();
}

class CategoriesTreeViewState extends State<CategoriesTreeView> {
  List<String>? _selectedFiltersList = [];
  final List<String> _parentIdStack = [];
  final List<String> _citiesList = [];
  final List<String> _idsOfChannelsFromCity = [];

  String _parentId = '';
  bool _isLastCategory = false;

  late final ChannelListController _channelListController;

  String get parentId => _parentId;

  @override
  void initState() {
    super.initState();
    _channelListController = ChannelListController(
        firestore:
            Provider.of<FirebaseProvider>(context, listen: false).firestore);
    _channelListController.getCitiesFromChannels(citiesList: _citiesList);
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
            ? _isLastCategory
                ? ElevatedButton(
          key: const Key('chooseCategoryButton'),
                    onPressed: () => Navigator.pop(context, _parentId),
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
      stream: _channelListController.getCategoriesStream(parentId: _parentId),
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
                    if (_idsOfChannelsFromCity.isEmpty ||
                        nodesList[index]['type'] == 'category' ||
                        (nodesList[index]['type'] == 'channel' &&
                            _idsOfChannelsFromCity
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
      _parentId = '';
      _parentIdStack.clear();
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        _isLastCategory = false;
      }
    });
  }

  void _returnToUpperLevelInCategoriesTreeView() {
    setState(() {
      if (_parentIdStack.isNotEmpty) {
        _parentId = _parentIdStack.removeLast();
      }
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        _isLastCategory = false;
      }
    });
  }

  void _openFilterDialog() async {
    await FilterListDialog.display<String>(
      context,
      listData: _citiesList,
      selectedListData: _selectedFiltersList,
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
        _selectedFiltersList = List.from(list!);
        _idsOfChannelsFromCity.clear();
        _channelListController.getChannelsFromCity(
            _selectedFiltersList, _idsOfChannelsFromCity);
        setState(() {});
        Navigator.pop(context);
      },
    );
  }

  void _openCategory(List<Map<String, dynamic>> nodesList,
      List<QueryDocumentSnapshot<Object?>> nodesArray, int index) {
    setState(() {
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        _isLastCategory = nodesList[index]['isLastCategory'];
      }
      _parentIdStack.add(_parentId);
      _parentId = nodesArray[index].id;
    });
  }
}
