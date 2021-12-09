import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/screens/channel_list/sample_channel_data.dart';
import 'package:lichee/screens/channel_list/tree_node_card.dart';
import 'lichee_button.dart';

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
              const Center(
                child: Text(
                  'Channels',
                  style: kLicheeTextStyle,
                ),
              ),
              LicheeButton(
                text: 'Filters',
                callback: _openFilterDialog,
                textSize: 25.0,
              ),
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
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      feedNodesListWithParentLevelNodes();
                    },
                    child: const Icon(
                      Icons.undo,
                      color: Colors.white,
                    ),
                    style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  color: const Color(0xFF1A1A1A),
                  child: ListView.builder(
                    itemCount: nodes.length,
                    itemBuilder: (BuildContext context, int index) {
                      return TextButton(
                        onPressed: nodes[index].childrenIds == null
                            ? null
                            : () {
                                feedNodesListByParentId(nodes, nodes[index].id);
                              },
                        child: TreeNodeCard(
                          nodeName: nodes[index].name,
                          nodes: nodes,
                          index: index,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
