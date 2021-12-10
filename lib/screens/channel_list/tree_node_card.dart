import 'package:flutter/material.dart';

class TreeNodeCard extends StatelessWidget {
  const TreeNodeCard({
    Key? key,
    required this.id,
    required this.name,
    required this.type,
    required this.parentId,
    required this.childrenIds,
  }) : super(key: key);

  //final ChannelTreeNodeA node;
  final String id;
  final String name;
  final String type;
  final String parentId;
  final List<String>? childrenIds;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF363636),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                childrenIds != null
                    ? const Icon(
                        Icons.arrow_right,
                        color: Colors.white,
                      )
                    : Container(),
              ],
            ),
            Row(
              children: [
                childrenIds!.isEmpty || childrenIds == null
                    ? const Text(
                        'empty',
                        style: TextStyle(color: Colors.grey),
                      )
                    : Container(),
                const SizedBox(
                  width: 5.0,
                ),
                type == 'category'
                    ? const Icon(
                        Icons.category,
                        color: Colors.white,
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
