import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  final List<TableRow> rows;

  const DetailsTable({
    Key? key,
    required this.rows,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        child: Table(
          columnWidths: const {1: FractionColumnWidth(0.75)},
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: rows,
        ),
      ),
    );
  }
}