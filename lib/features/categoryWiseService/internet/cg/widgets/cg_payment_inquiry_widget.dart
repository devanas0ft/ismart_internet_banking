import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class CgPaymentInquiryWidget extends StatefulWidget {
  final ServiceList service;
  final UtilityResponseData detailFetchData;
  final String userId;
  const CgPaymentInquiryWidget({
    super.key,
    required this.service,
    required this.detailFetchData,
    required this.userId,
  });

  @override
  State<CgPaymentInquiryWidget> createState() => _CgPaymentInquiryWidgetState();
}

class _CgPaymentInquiryWidgetState extends State<CgPaymentInquiryWidget> {
  final TextEditingController _packageController = TextEditingController();
  Map<String, dynamic>? _selectedPlan;
  List<Map<String, dynamic>> planList = [];
  String _amount = "0";

  @override
  void dispose() {
    _packageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final plans = widget.detailFetchData.findValue<List<dynamic>>(
      primaryKey: "planList",
    );
    if (plans != null) {
      try {
        planList =
            plans.map((item) => Map<String, dynamic>.from(item)).toList();
      } catch (e) {
        print("Error casting planList: $e");
        planList = [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;

    return PageWrapper(
      body: CommonContainer(
        verificationAmount: _amount,
        showDetail: true,
        topbarName: 'Payment',
        title: 'CG Net Payment',
        buttonName: 'Proceed',
        detail: 'Pay your CG Net subscription from here',
        showAccountSelection: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: _height * 0.02),
            OpenContainer(
              closedColor: Colors.transparent,
              closedElevation: 0.0,
              openElevation: 0,
              transitionType: ContainerTransitionType.fade,
              closedBuilder: (context, open) {
                return CustomTextField(
                  margin: const EdgeInsets.symmetric(
                    horizontal: CustomTheme.symmetricHozPadding,
                  ),
                  controller: _packageController,
                  title: "Select Package",
                  hintText: "Choose Package",
                  showSearchIcon: true,
                  readOnly: true,
                  required: true,
                  suffixIcon: Icons.keyboard_arrow_down_rounded,
                  onTap: open,
                );
              },
              openBuilder: (context, close) {
                return PageWrapper(
                  showBackButton: true,
                  body: ListView.builder(
                    itemCount: planList.length,
                    itemBuilder: (context, index) {
                      final plan = planList[index];
                      return CustomListTile(
                        title: plan["planName"] ?? "Unknown Plan",
                        description:
                            "Speed: ${plan["primarySpeed"]}\n"
                            "Quota: ${plan["volumeQuota"]}\n"
                            "Validity: ${plan["validity"]}",
                        titleFontWeight: FontWeight.w400,
                        trailing: Text("Rs.${plan["amount"]}"),
                        onPressed: () {
                          setState(() {
                            _amount = plan["amount"].toString();
                            _packageController.text = plan["planName"];
                            _selectedPlan = plan;
                          });
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                );
              },
            ),
            if (_selectedPlan != null) ...[
              SizedBox(height: _height * 0.02),
              KeyValueTile(
                title: "Plan Name",
                value: _selectedPlan!["planName"],
              ),
              KeyValueTile(
                title: "Speed",
                value: _selectedPlan!["primarySpeed"],
              ),
              KeyValueTile(
                title: "Volume Quota",
                value: _selectedPlan!["volumeQuota"],
              ),
              KeyValueTile(
                title: "Validity",
                value: _selectedPlan!["validity"],
              ),
              KeyValueTile(title: "Amount", value: "Rs.$_amount"),
            ],
          ],
        ),
        onButtonPressed: () {
          if (_selectedPlan == null) {
            showPopUpDialog(
              context: context,
              message: "Please select a package",
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
            return;
          }

          final requestId = widget.detailFetchData.findValue<String>(
            primaryKey: "requestId",
          );

          NavigationService.push(
            target: CommonBillDetailPage(
              serviceName: widget.service.service,
              body: Column(
                children: [
                  KeyValueTile(
                    title: "Plan Name",
                    value: _selectedPlan!["planName"],
                  ),
                  KeyValueTile(
                    title: "Speed",
                    value: _selectedPlan!["primarySpeed"],
                  ),
                  KeyValueTile(
                    title: "Volume Quota",
                    value: _selectedPlan!["volumeQuota"],
                  ),
                  KeyValueTile(
                    title: "Validity",
                    value: _selectedPlan!["validity"],
                  ),
                  KeyValueTile(title: "Amount", value: "Rs.$_amount"),
                ],
              ),
              accountDetails: {
                "accountNumber":
                    RepositoryProvider.of<CustomerDetailRepository>(
                      context,
                    ).selectedAccount.value?.accountNumber,
              },
              apiBody: {
                "requestId": requestId,
                "userId": widget.userId,
                "amount": _amount,
                "planName": _selectedPlan!["planName"],
                "hashValue": _selectedPlan!["hashValue"].toString(),
              },
              apiEndpoint: "api/cg_net/payment",
              service: widget.service,
              serviceIdentifier: widget.service.uniqueIdentifier,
            ),
          );
        },
      ),
    );
  }
}
