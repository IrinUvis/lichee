import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:lichee/screens/channel_list/sample_channel_data.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  List<String>? selectedFiltersList = [];
  String parentId = '';
  List<String> parentIdStack = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        parentId = '';
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
            ],
          ),
        ),
      ),
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
          return ListView.builder(
            itemCount: nodesList.length,
            itemBuilder: (BuildContext context, int index) {
              return TextButton(
                onPressed: List.from(nodesList[index]['childrenIds']).isEmpty
                    ? null
                    : () {
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
