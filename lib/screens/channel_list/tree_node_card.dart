import 'package:flutter/material.dart';
import 'package:lichee/screens/channel_list/sample_channel_data.dart';

class TreeNodeCard extends StatelessWidget {
  const TreeNodeCard({
    Key? key,
    required this.nodeName,
    required this.nodes,
    required this.index,
  }) : super(key: key);

  final String nodeName;
  final List<ChannelTreeNode> nodes;
  final int index;

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
                  nodeName,
                  style: const TextStyle(color: Colors.white, fontSize: 20.0),
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
                        style: TextStyle(color: Colors.grey),
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
    );
  }
}
