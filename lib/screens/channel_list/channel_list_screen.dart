import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:lichee/constants.dart';
import 'package:lichee/screens/channel_list/sample_channel_data.dart';
import 'lichee_button.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  List<ChannelTreeNode> nodes = [];
  String? parentId;

  void feedNodesListByParentId(List<ChannelTreeNode> table, String? parentId) {
    for (var element in nodesList) {
      if (element.parentId == parentId) {
        table.add(element);
      }
    }
  }

  void feedNodesListWithParentLevelNodes() {
    for (var element in nodesList) {
      if (element.id == parentId) {
        parentId = element.parentId;
        break;
      }
    }
    if (parentId != null) {
      nodes.clear();
      feedNodesListByParentId(nodes, parentId);
    } else {
      nodes.clear();
      feedNodesListByParentId(nodes, null);
    }
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
                      setState(() {});
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
                      setState(() {});
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
                      String nodeName;
                      nodeName = nodes[index].name;
                      return TextButton(
                        onPressed: nodes[index].childrenIds == null
                            ? null
                            : () {
                                this.parentId = nodes[index].id;
                                String parentId = nodes[index].id;
                                nodes.clear();
                                feedNodesListByParentId(nodes, parentId);
                                setState(() {});
                              },
                        child: Card(
                          color: const Color(0xFF363636),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      nodeName,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20.0),
                                    ),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    nodes[index].childrenIds != null
                                        ? const Icon(
                                            Icons.arrow_right,
                                            color: Colors.white,
                                          )
                                        : Container(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    nodes[index].childrenIds == null
                                        ? const Text(
                                            'empty',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        : Container(),
                                    const SizedBox(
                                      width: 5.0,
                                    ),
                                    nodes[index].icon
                                  ],
                                ),
                              ],
                            ),
                          ),
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

  List<String> filtersList = [
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten'
  ];
  List<String>? selectedFiltersList = [];

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
