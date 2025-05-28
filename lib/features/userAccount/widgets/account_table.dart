import 'package:flutter/material.dart';

class AccountTable extends StatelessWidget {
  const AccountTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder(
        top: BorderSide(width: 1, color: Colors.grey[200]!),
        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
        horizontalInside: BorderSide(width: 1, color: Colors.grey[200]!),
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey[200]),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('Transaction Date')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Description'),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('Debit')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('Credit')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('Balance')),
          ],
        ),
        //* use listview from data here
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('01/01/2023')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Opening Balance'),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('0.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.check_box_outline_blank,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('01/01/2023')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Closing Balance'),
            ),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('0.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
            Padding(padding: const EdgeInsets.all(8.0), child: Text('1000.00')),
          ],
        ),
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Icon(
                    Icons.circle_outlined,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                  SizedBox(width: 5),
                  Expanded(child: Text('Prev')),
                ],
              ),
            ),
            Text(''),
            // SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '1 2 3 ... 8 9 10',
                style: TextStyle(letterSpacing: 5),
              ),
            ),
            Text(''),
            // SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text('Next'),
                  SizedBox(width: 5),
                  Icon(
                    Icons.circle_outlined,
                    color: Color(0xff010c80),
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
  }
