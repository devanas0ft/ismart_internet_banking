import 'package:flutter/material.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class InProgressScreen extends StatelessWidget {
  const InProgressScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const PageWrapper(body: Center(child: Text("In Progress")));
  }
}
