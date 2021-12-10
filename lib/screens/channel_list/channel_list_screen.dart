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
  List<ChannelTreeNode> nodes = [];
  String? parentId;

  void feedNodesListByParentId(List<ChannelTreeNode> table, String? parentId) {
    this.parentId = parentId;
    nodes.clear();
    for (var element in nodesList) {
      if (element.parentId == parentId) {
        table.add(element);
      }
    }
    setState(() {});
  }

  void feedNodesListWithParentLevelNodes() {
    for (var element in nodesList) {
      if (element.id == parentId) {
        parentId = element.parentId;
        break;
      }
    }
    nodes.clear();
    if (parentId != null) {
      feedNodesListByParentId(nodes, parentId);
    } else {
      feedNodesListByParentId(nodes, null);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    feedNodesListByParentId(nodes, null);
  }

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
                      nodes.clear();
                      feedNodesListByParentId(nodes, null);
                    },
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
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
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      feedNodesListWithParentLevelNodes();
                    },
                    child: const Icon(
                      Icons.undo,
                      color: Colors.white,
                      size: 40.0,
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF1A1A1A),
                  child: getNodesTree(),
                  // ListView.builder(
                  //   itemCount: nodes.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return TextButton(
                  //       onPressed: nodes[index].childrenIds == null
                  //           ? null
                  //           : () {
                  //               feedNodesListByParentId(nodes, nodes[index].id);
                  //             },
                  //       child: TreeNodeCard(
                  //         node: nodes[index],
                  //       ),
                  //     );
                  //   },
                  // ),
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
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final nodesList = snapshot.data!.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          print(nodesList.toString());
          print(nodesList[0]['id'].runtimeType);
          print(nodesList[0]['name'].runtimeType);
          print(nodesList[0]['type'].runtimeType);
          print(nodesList[0]['parentId'].runtimeType);
          print(nodesList[0]['childreIds'].runtimeType);
          return
          //   ListView(
          //   children: nodesList
          //       .map((nodesList) => Column(
          //             children: <Widget>[
          //               Icon(Icons.check),
          //               TreeNodeCard(
          //                   id: nodesList['id'],
          //                   name: nodesList['name'],
          //                   type: nodesList['type'],
          //                   parentId: nodesList['parentId'],
          //                   //childrenIds: nodesList['childrenIds'],
          //                 ),
          //               const SizedBox(
          //                 height: 5.0,
          //               )
          //             ],
          //           ))
          //       .toList(),
          // );
            ListView.builder(
            itemCount: nodesList.length,
            itemBuilder: (BuildContext context, int index) {
              return TextButton(
                onPressed: nodesList[index]['childrenIds'] ==
                        null //nodes[index].childrenIds == null
                    ? null
                    : () {
                        feedNodesListByParentId(nodes, nodes[index].id);
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
