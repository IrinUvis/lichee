import 'package:flutter/material.dart';
import 'package:lichee/constants/colors.dart';
import 'package:lichee/constants/constants.dart';
import 'package:lichee/constants/icons.dart';

class TreeNodeCard extends StatelessWidget {
  const TreeNodeCard({
    Key? key,
    required this.name,
    required this.type,
    required this.childrenIds,
  }) : super(key: key);

  final String name;
  final String type;
  final List<String>? childrenIds;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: LicheeColors.greyColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Text(name, style: kCategoryNodeTestStyle),
                  ),
                  const Expanded(flex: 2, child: kCategoryNodeArrow),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  (childrenIds!.isEmpty || childrenIds == null) &&
                          type == 'category'
                      ? kCategoryNodeEmptyText
                      : Container(),
                  const SizedBox(height: 5.0),
                  type == 'category' ? kCategoryIcon : kChannelIcon,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
