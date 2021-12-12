import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
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
  String parentId = '';
  List<String> parentIdStack = [];
  bool isLastCategory = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  parentId = '';
                  parentIdStack.clear();
                  if (widget.isChoosingCategoryForChannelAddingAvailable) {
                    isLastCategory = false;
                  }
                });
              },
              child: const Icon(
                Icons.home,
                color: Colors.white,
                size: 40.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _openFilterDialog,
              child: const Padding(
                padding: EdgeInsets.all(7.0),
                child: Text(
                  'Filters',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (parentIdStack.isNotEmpty) {
                    parentId = parentIdStack.removeLast();
                  }
                  if (widget.isChoosingCategoryForChannelAddingAvailable) {
                    isLastCategory = false;
                  }
                });
              },
              child: const Icon(
                Icons.undo,
                color: Colors.white,
                size: 40.0,
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            color: const Color(0xFF1A1A1A),
            child: getNodesTree(),
          ),
        ),
        widget.isChoosingCategoryForChannelAddingAvailable
            ? isLastCategory
                ? TextButton(
                    onPressed: () {
                      Navigator.pop(context, parentId);
                    },
                    child: const Text(
                      'Choose this category',
                      style: TextStyle(color: Colors.white),
                    ),
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
                              if (widget
                                  .isChoosingCategoryForChannelAddingAvailable) {
                                isLastCategory =
                                    nodesList[index]['isLastCategory'];
                              }

                              parentIdStack.add(parentId);

                              parentId = nodesList[index]['id'];
                              setState(() {});
                            },
                      child: TreeNodeCard(
                        id: nodesList[index]['id'],
                        name: nodesList[index]['name'],
                        type: nodesList[index]['type'],
                        parentId: nodesList[index]['parentId'],
                        childrenIds: List.from(nodesList[index]['childrenIds']),
                      ),
                    );
                  },
                )
              : const Text(
                  'This category is empty for now',
                  style: TextStyle(color: Colors.white),
                );
        }
      },
    );
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
}
