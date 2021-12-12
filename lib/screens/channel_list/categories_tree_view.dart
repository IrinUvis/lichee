import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/constants/icons.dart';
import 'package:lichee/screens/channel_list/sample_channel_data.dart';
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
            child: getNodesTree(),
          ),
        ),
        widget.isChoosingCategoryForChannelAddingAvailable
            ? isLastCategory
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context, parentId);
                    },
                    child: kChooseCategoryForAddingChannelButtonText,
                  )
                : Container()
            : Container(),
      ],
    );
  }

  StreamBuilder<QuerySnapshot> getNodesTree() {
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
          return nodesList.isNotEmpty
              ? ListView.builder(
                  itemCount: nodesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextButton(
                      onPressed: nodesList[index]['type'] == 'channel'
                          ? null
                          : () {
                              _openCategory(nodesList, index);
                            },
                      child: TreeNodeCard(
                        id: nodesList[index]['id'],
                        name: nodesList[index]['name'],
                        type: nodesList[index]['type'],
                        parentId: nodesList[index]['parentId'],
                        childrenIds: List.from(
                          nodesList[index]['childrenIds'],
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      kEmptyCategoryText,
                      SizedBox(
                        height: 10.0,
                      ),
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
      listData: filtersList,
      selectedListData: selectedFiltersList,
      backgroundColor: const Color(0xFF1A1A1A),
      searchFieldBackgroundColor: Colors.pinkAccent,
      selectedTextBackgroundColor: Colors.pinkAccent,
      applyButonTextBackgroundColor: Colors.pinkAccent,
      closeIconColor: Colors.white,
      headerTextColor: Colors.white,
      applyButtonTextStyle: const TextStyle(color: Colors.white),
      searchFieldTextStyle: const TextStyle(color: Colors.white),
      controlButtonTextStyle: const TextStyle(color: Colors.black),
      headlineText: 'Select Filters',
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
            /// return list which contains matches
            return list
                .where((element) =>
                    element.toLowerCase().contains(text.toLowerCase()))
                .toList();
          }
        }
        return [];
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedFiltersList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  void _openCategory(List<Map<String, dynamic>> nodesList, int index) {
    setState(() {
      if (widget.isChoosingCategoryForChannelAddingAvailable) {
        isLastCategory = nodesList[index]['isLastCategory'];
      }
      parentIdStack.add(parentId);
      parentId = nodesList[index]['id'];
    });
  }
}
