import 'package:flutter/material.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:filter_list/filter_list.dart';
import 'package:lichee/constants.dart';

class ChannelListScreen extends StatefulWidget {
  const ChannelListScreen({Key? key}) : super(key: key);

  @override
  _ChannelListScreenState createState() => _ChannelListScreenState();
}

class _ChannelListScreenState extends State<ChannelListScreen> {
  List<ChannelTreeNode> nodes = [];
  List<ChannelTreeNode> temp = [];
  String? parentId;

  void feedCategoriesList() {
    for (var element in nodesList) {
      if (element.parentId == null) {
        nodes.add(element);
      }
    }
  }

  void feedNodesListByParentId(List<ChannelTreeNode> table, String parentId) {
    for (var element in nodesList) {
      print(element.name);
      print(element.parentId);
      print(parentId);
      print('');
      if (element.parentId == parentId) {
        table.add(element);
      }
    }
    print(temp);
  }

  @override
  void initState() {
    super.initState();
    feedCategoriesList();
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
                            onPressed: nodes[index].childrenIds == null ? null : () {
                              String parentId = nodes[index].id;
                              //nodes.clear();
                              temp.clear();
                              nodes.clear();
                              feedNodesListByParentId(temp, parentId);
                              nodes = temp;
                              print(nodes);
                              setState(() {

                              });
                            }, child: Text(nodeName, style: const TextStyle(color: Colors.white),));
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

class LicheeButton extends StatelessWidget {
  const LicheeButton({
    Key? key,
    required this.text,
    required this.callback,
  }) : super(key: key);

  final String text;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 60,
        margin: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: callback,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.pinkAccent),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width,
              minHeight: MediaQuery.of(context).size.height / 16,
            ),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

List<ChannelTreeNode> nodesList = [
  ChannelTreeNode(
      id: '1',
      name: 'Football',
      icon: const Icon(Icons.sports_soccer),
      type: 'Category',
      parentId: null,
      childrenIds: ['4', '5', '6']),
  ChannelTreeNode(
      id: '2',
      name: 'Basketball',
      icon: const Icon(Icons.sports_soccer),
      type: 'Category',
      parentId: null,
      childrenIds: null),
  ChannelTreeNode(
      id: '3',
      name: 'Volleyball',
      icon: const Icon(Icons.sports_soccer),
      type: 'Category',
      parentId: null,
      childrenIds: null),
  ChannelTreeNode(
      id: '4',
      name: 'matchPlaying',
      icon: const Icon(Icons.sports_soccer),
      type: 'Category',
      parentId: '1',
      childrenIds: ['7']),
  ChannelTreeNode(
      id: '5',
      name: 'fanMeetings',
      icon: const Icon(Icons.sports_soccer),
      type: 'Category',
      parentId: '1',
      childrenIds: null),
  ChannelTreeNode(
      id: '6',
      name: 'matchWatching',
      icon: const Icon(Icons.sports_soccer),
      type: 'Category',
      parentId: '1',
      childrenIds: null),
  ChannelTreeNode(
      id: '7',
      name: 'Match 3x3',
      icon: const Icon(Icons.sports_soccer),
      type: 'Channel',
      parentId: '4',
      childrenIds: null),
];

class ChannelTreeNode {
  String id;
  String name;
  Icon icon;
  String type;
  String? parentId;
  List<String>? childrenIds;

  ChannelTreeNode(
      {required this.id,
      required this.name,
      required this.icon,
      required this.type,
      required this.parentId,
      required this.childrenIds});
}
