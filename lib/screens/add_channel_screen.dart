import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/screens/channel_list/channel_list_screen.dart';

import 'channel_list/sample_channel_data.dart';
import 'channel_list/tree_node_card.dart';

class AddChannelScreen extends StatefulWidget {
  const AddChannelScreen({Key? key}) : super(key: key);

  @override
  _AddChannelScreenState createState() => _AddChannelScreenState();
}

class _AddChannelScreenState extends State<AddChannelScreen> {
  bool isAddChannelPressed = false;
  bool isAddEventPressed = false;
  bool isChooseCategoryPressed = false;

  late String newChannelName;
  late String newChannelCity;
  late String newChannelDescription;
  String? chosenCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddChannelPressed = !isAddChannelPressed;
                    isAddEventPressed = false;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Add channel',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: isAddChannelPressed
                      ? Colors.pinkAccent
                      : const Color(0xFF363636),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isAddEventPressed = !isAddEventPressed;
                    isAddChannelPressed = false;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(7.0),
                  child: Text(
                    'Add event',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: isAddEventPressed
                      ? Colors.pinkAccent
                      : const Color(0xFF363636),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
              ),
            ],
          ),
          isAddChannelPressed
              ? Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LicheeTextField(
                        decoration: kAddChannelNameBarInputDecoration,
                        getText: (String text) {
                          setState(() {
                            newChannelName = text;
                          });
                        },
                      ),
                      LicheeTextField(
                        decoration: kAddChannelCityBarInputDecoration,
                        getText: (String text) {
                          setState(() {
                            newChannelCity = text;
                          });
                        },
                      ),
                      LicheeTextField(
                        decoration: kAddChannelDescriptionBarInputDecoration,
                        getText: (String text) {
                          setState(() {
                            newChannelDescription = text;
                          });
                        },
                        textInputType: TextInputType.multiline,
                        maxLines: null,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            //isChooseCategoryPressed = !isChooseCategoryPressed;
                            getAnswer();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            'Choose category',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF363636),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Text(
                            'category:',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          chosenCategory == '' || chosenCategory == null
                              ? const Text(
                                  'no category chosen',
                                  style: TextStyle(color: Colors.white),
                                )
                              : Text(
                                  chosenCategory!,
                                  style: const TextStyle(color: Colors.white),
                                )
                        ],
                      )
                      // Expanded(
                      //   child: Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Container(
                      //       decoration: BoxDecoration(
                      //         border: Border.all(color: Colors.pinkAccent),
                      //         borderRadius: BorderRadius.circular(15.0),
                      //       ),
                      //       child: const Padding(
                      //         padding: EdgeInsets.all(8.0),
                      //         child: ChannelListScreen(),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                )
              : Container(),
          isAddEventPressed
              ? const Expanded(
                  child: Center(
                    child: Text(
                      'add an event',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void getAnswer() async {
    var channelParentId = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            //title: Text('ABC'),
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 800,
                  child: ChooseCategoryWidget()),
            ],
          );
        });

    setState(() {
      chosenCategory = channelParentId;
    });
  }
}

class LicheeTextField extends StatefulWidget {
  const LicheeTextField({
    Key? key,
    required this.getText,
    required this.decoration,
    this.textInputType = TextInputType.text,
    this.maxLines = 1,
  }) : super(key: key);

  final Function(String text) getText;
  final TextInputType textInputType;
  final int? maxLines;
  final InputDecoration decoration;

  @override
  _LicheeTextFieldState createState() => _LicheeTextFieldState();
}

class _LicheeTextFieldState extends State<LicheeTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF363636),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
      ),
      child: TextField(
        keyboardType: widget.textInputType,
        onChanged: (value) {
          widget.getText(value);
        },
        decoration: widget.decoration,
        maxLines: widget.maxLines,
      ),
    );
  }
}

class ChooseCategoryWidget extends StatefulWidget {
  const ChooseCategoryWidget({Key? key}) : super(key: key);

  @override
  _ChooseCategoryWidgetState createState() => _ChooseCategoryWidgetState();
}

class _ChooseCategoryWidgetState extends State<ChooseCategoryWidget> {
  List<String>? selectedFiltersList = [];
  String parentId = '';
  List<String> parentIdStack = [];
  bool isLastCategory = false;

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
                        parentIdStack.clear();
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
              isLastCategory
                  ? TextButton(
                      onPressed: () {
                        Navigator.pop(context, parentId);
                      },
                      child: const Text(
                        'Choose this category',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Container(),
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
          //.where('type', isEqualTo: 'category')
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
                        isLastCategory = nodesList[index]['isLastCategory'];
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
