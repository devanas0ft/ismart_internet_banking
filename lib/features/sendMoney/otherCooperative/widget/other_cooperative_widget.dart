import 'package:flutter/material.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class OtherCooperativeWidget extends StatelessWidget {
  const OtherCooperativeWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: CommonContainer(
        showDetail: true,
        showAccountSelection: true,
        body: Column(
          children: [
            CustomTextField(
              title: "Select Cooperative",
              hintText: "Select From List",
            ),
            CustomTextField(
              title: "Destination Account",
              hintText: "Account Number",
            ),
            CustomTextField(hintText: "Account Holder Name"),
            CustomTextField(title: "Amount", hintText: "NPR"),
            CustomTextField(title: "Remarks", hintText: "Remarks"),
          ],
        ),
        topbarName: "Send Money",
        onButtonPressed: () {
          //TODO : button directs to mpin screen
        },
        buttonName: "Proceed",
        title: "Other Cooperative",
        detail: "Send Fund to accounts maintained at various coop",
      ),
    );
  }
}
