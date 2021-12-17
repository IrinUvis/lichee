import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/constants/icons.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';

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
  String parentId = '';
  bool isLastCategory = false;
  List<String> citiesList = [];
  List<String> idsOfChannelsFromCity = [];

  @override
  void initState() {
    super.initState();
    getCitiesFromChannels();
  }

  void getCitiesFromChannels() async {
    await FirebaseFirestore.instance
        .collection('channels')
        .get()
        .then((querySnapshot) => {
              for (var element in querySnapshot.docs)
                {
                  if (!citiesList.contains(element.get('city')))
                    {citiesList.add(element.get('city'))}
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _resetCategoriesTreeView,
              child: kResetCategoriesTreeViewIcon,
              style: kCategoriesTreeViewButtonStyle,
            ),
            ElevatedButton(
              onPressed: _openFilterDialog,
              child: kCategoriesTreeViewFiltersButtonText,
              style: kCategoriesTreeViewButtonStyle,
            ),
            ElevatedButton(
              onPressed: _returnToUpperLevelInCategoriesTreeView,
              child: kReturnToUpperLevelInTreeViewIcon,
              style: kCategoriesTreeViewButtonStyle,
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
                    style: kCategoriesTreeViewButtonStyle,
                  )
                : Container()
            : Container(),
      ],
    );
  }

  StreamBuilder<QuerySnapshot> _getNodesTree() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .where('parentId', isEqualTo: parentId)
          .snapshots(),
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
                            ? null
                            : () {
                                _openCategory(nodesList, nodesArray, index);
                              },
                        child: TreeNodeCard(
                          name: nodesList[index]['name'],
                          type: nodesList[index]['type'],
                          childrenIds:
                              List.from(nodesList[index]['childrenIds']),
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
        await FirebaseFirestore.instance
            .collection('channels')
            .get()
            .then((querySnapshot) => {
                  for (var element in querySnapshot.docs)
                    {
                      if (selectedFiltersList!.isNotEmpty &&
                          element.get('city') == selectedFiltersList!.first)
                        {idsOfChannelsFromCity.add(element.id)}
                    }
                });

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
