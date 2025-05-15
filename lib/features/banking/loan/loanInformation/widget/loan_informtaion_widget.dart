import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/loan_key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class LoanInformationWiget extends StatelessWidget {
  final UtilityResponseData response;

  const LoanInformationWiget({Key? key, required this.response})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return PageWrapper(
      body: CommonContainer(
        verticalPadding: 0,
        horizontalPadding: 2,
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: _theme.primaryColor.withOpacity(0.05),
              ),
              child: Column(
                children: [
                  LoanKeyValueTile(
                    title: "Product Name",
                    value: response.findValueString("product"),
                    axis: Axis.horizontal,
                  ),
                  LoanKeyValueTile(
                    title: "Account Number",
                    value: response.findValueString("accountNumber"),
                    axis: Axis.horizontal,
                  ),
                ],
              ),
            ),
            // Divider(thickness: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Table(
                children: [
                  TableRow(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LoanKeyValueTile(
                            title: "Interest Type",
                            value: response.findValueString("interestType"),
                            axis: Axis.vertical,
                          ),
                          LoanKeyValueTile(
                            title: "Issued On",
                            value: response.findValueString("issuedOn"),
                            axis: Axis.vertical,
                          ),
                          LoanKeyValueTile(
                            title: "Principal Installments",
                            value: response.findValueString(
                              "principalInstallments",
                            ),
                            axis: Axis.vertical,
                          ),
                          LoanKeyValueTile(
                            title: "Interest Installments",
                            value: response.findValueString(
                              "interestInstallments",
                            ),
                            axis: Axis.vertical,
                          ),
                          LoanKeyValueTile(
                            title: "Balance",
                            value: response.findValueString("balance"),
                            axis: Axis.vertical,
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.wp),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LoanKeyValueTile(
                              title: "Interest Rate",
                              value: response.findValueString("interestRate"),
                              axis: Axis.vertical,
                            ),
                            LoanKeyValueTile(
                              title: "Matures On",
                              value: response.findValueString("maturesOn"),
                              axis: Axis.vertical,
                            ),
                            LoanKeyValueTile(
                              title: "Disbursed Amount",
                              value: response.findValueString(
                                "disbursedAmount",
                              ),
                              axis: Axis.vertical,
                            ),
                            LoanKeyValueTile(
                              title: "Duration",
                              value: response.findValueString("duration"),
                              axis: Axis.vertical,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        topbarName: "Loan Information",
        showTitleText: false,
        buttonName: "Close",
        onButtonPressed: () {
          NavigationService.pop();
        },
      ),
    );
  }
}
