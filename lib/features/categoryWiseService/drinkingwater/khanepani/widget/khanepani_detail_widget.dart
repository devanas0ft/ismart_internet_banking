import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/utils/text_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_table_widget.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class KhanepaniDetailsWidgets extends StatefulWidget {
  final UtilityResponseData useServiceResponse;
  final String customerCode;
  final String selectedCounter;
  final String selectedCounterName;

  final ServiceList service;

  const KhanepaniDetailsWidgets({
    super.key,
    required this.useServiceResponse,
    required this.customerCode,
    required this.selectedCounter,
    required this.service,
    required this.selectedCounterName,
  });

  @override
  State<KhanepaniDetailsWidgets> createState() =>
      _KhanepaniDetailsWidgetsState();
}

class _KhanepaniDetailsWidgetsState extends State<KhanepaniDetailsWidgets> {
  List<List<String>> _billsDetails(UtilityResponseData response) {
    final List<Map<String, dynamic>> _temp =
        response
            .findValue<List>(primaryKey: "statements")
            ?.cast<Map<String, dynamic>>() ??
        [];
    return [
      ["Date", "DECS", "AMT"],
      ..._temp.map<List<String>>(
        (e) => [
          TextUtils.replaceEmptyWithDash(e["date"]),
          TextUtils.replaceEmptyWithDash(e["desc"]),
          TextUtils.replaceEmptyWithDash(e["amt"]),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final _response = widget.useServiceResponse;

    return PageWrapper(
      body: CommonContainer(
        verificationAmount: _response.findValueString("total_dues"),
        detail: widget.service.instructions,
        title: widget.service.service,
        showAccountSelection: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeyValueTile(
              title: "Customer Code",
              value: _response.findValueString("customer_code"),
            ),
            KeyValueTile(
              title: "Customer Name",
              value: _response.findValueString("customer_name"),
            ),
            KeyValueTile(
              title: "Counter Name",
              value: widget.selectedCounterName,
            ),
            KeyValueTile(
              title: "Address",
              value: _response.findValueString("address"),
            ),
            KeyValueTile(
              title: "Mobile Number",
              value: _response.findValueString("mobile_number"),
            ),
            KeyValueTile(
              title: "Current Month Dues",
              value: _response.findValueString("current_month_dues"),
            ),
            KeyValueTile(
              title: "Current Fine",
              value: _response.findValueString("current_month_fine"),
            ),
            KeyValueTile(
              title: "Discount",
              value: _response.findValueString("current_month_discount"),
            ),
            KeyValueTile(
              title: "Total Credit Sales Amount",
              value: _response.findValueString("total_credit_sales_amount"),
            ),
            KeyValueTile(
              title: "Total Advance Amount",
              value: _response.findValueString("total_advance_amount"),
            ),
            KeyValueTile(
              title: "Previous Dues",
              value: _response.findValueString("previous_dues"),
            ),
            KeyValueTile(
              title: "Service Charge",
              value: _response.findValueString("service_charge"),
            ),
            Text("Bill Details", style: Theme.of(context).textTheme.titleLarge),
            _response.findValue(primaryKey: "statements").toString() == "null"
                ? Container()
                : CommonTableWidget(
                  values: _billsDetails(widget.useServiceResponse),
                ),
            KeyValueTile(
              title: "Total Dues",
              titleFontWeight: FontWeight.bold,
              isRedColor: true,
              value: _response.findValueString("total_dues"),
            ),
          ],
        ),
        showDetail: true,
        topbarName: widget.service.serviceCategoryName,
        buttonName: "Proceed",
        onButtonPressed: () {
          NavigationService.pushReplacement(
            target: CommonBillDetailPage(
              serviceName: widget.service.service,
              accountDetails: {
                "account_number":
                    RepositoryProvider.of<CustomerDetailRepository>(
                      context,
                    ).selectedAccount.value!.accountNumber,
                "amount": _response.findValueString("total_dues"),
                "customer_code": _response.findValueString("customer_code"),
                "counter": widget.selectedCounter,
                "customer_name": _response.findValueString("customer_name"),
              },
              apiEndpoint: "/api/khanepanipay",
              apiBody: const {},
              service: widget.service,
              serviceIdentifier: widget.service.uniqueIdentifier,
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KeyValueTile(
                    title: "Customer Code",
                    value: _response.findValueString("customer_code"),
                  ),
                  KeyValueTile(
                    title: "Customer Name",
                    value: _response.findValueString("customer_name"),
                  ),
                  KeyValueTile(
                    title: "Counter Name",
                    value: widget.selectedCounterName,
                  ),
                  KeyValueTile(
                    title: "Address",
                    value: _response.findValueString("address"),
                  ),
                  KeyValueTile(
                    title: "Mobile Number",
                    value: _response.findValueString("mobile_number"),
                  ),
                  KeyValueTile(
                    title: "Current Month Dues",
                    value: _response.findValueString("current_month_dues"),
                  ),
                  KeyValueTile(
                    title: "Current Fine",
                    value: _response.findValueString("current_month_fine"),
                  ),
                  KeyValueTile(
                    title: "Discount",
                    value: _response.findValueString("current_month_discount"),
                  ),
                  KeyValueTile(
                    title: "Total Credit Sales Amount",
                    value: _response.findValueString(
                      "total_credit_sales_amount",
                    ),
                  ),
                  KeyValueTile(
                    title: "Total Advance Amount",
                    value: _response.findValueString("total_advance_amount"),
                  ),
                  KeyValueTile(
                    title: "Previous Dues",
                    value: _response.findValueString("previous_dues"),
                  ),
                  KeyValueTile(
                    title: "Service Charge",
                    value: _response.findValueString("service_charge"),
                  ),
                  KeyValueTile(
                    title: "Total Dues",
                    titleFontWeight: FontWeight.bold,
                    isRedColor: true,
                    value: _response.findValueString("total_dues"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
