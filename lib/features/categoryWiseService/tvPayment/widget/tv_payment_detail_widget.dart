import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_checkbox.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/tvPayment/resources/tv_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

import 'tv_package_search_widegt.dart';

class TvPaymentDeatilWidget extends StatefulWidget {
  final String amount;
  final String userName;
  final ServiceList service;
  final TvDetailModel detailFetchData;

  const TvPaymentDeatilWidget({
    super.key,
    required this.detailFetchData,
    required this.service,
    required this.amount,
    required this.userName,
  });
  @override
  State<TvPaymentDeatilWidget> createState() => _TvPaymentDeatilWidgetState();
}

class _TvPaymentDeatilWidgetState extends State<TvPaymentDeatilWidget> {
  bool _changePackage = false;
  bool _isLoading = false;
  TextEditingController selectedPackageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final HashResponse hashResponse =
        widget.detailFetchData.details.hashResponse;
    final List<TvPackages> tvPackages =
        widget.detailFetchData.details.tvPackages;
    // final currentPackage =
    // tvPackages.where((element) => element.text == hashResponse.currentPlan);
    final TextEditingController selectedAmount = TextEditingController();
    final TextEditingController selectedPackageId = TextEditingController();
    const String packageName = "1";
    // TvPackages? selectedPackage;

    // TvPackages? packageDetail() {
    //   if (selectedPackage != null) {
    //     return selectedPackage;
    //   } else {
    //     if (currentPackage.isEmpty) {
    //     } else {
    //       return currentPackage.first;
    //     }
    //   }
    // }

    String getAmount() {
      if (widget.amount.toString().isNotEmpty) {
        return widget.amount;
      } else {
        return selectedAmount.text;
      }
    }

    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        showDetail: true,
        topbarName: widget.service.serviceCategoryName,
        title: widget.service.service,
        buttonName: 'Proceed',
        detail: widget.service.instructions,
        showAccountSelection: true,
        body: BlocListener<UtilityPaymentCubit, CommonState>(
          listener: (context, state) {
            if (state is CommonLoading && _isLoading == false) {
              _isLoading = true;
              showLoadingDialogBox(context);
            } else if (state is! CommonLoading && _isLoading) {
              _isLoading = false;
              NavigationService.pop();
            }
            if (state is CommonError) {
              showPopUpDialog(
                context: context,
                message: state.message,
                title: "Error",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }

            if (state is CommonStateSuccess<UtilityResponseData>) {
              final UtilityResponseData _response = state.data;

              if (_response.code == "M0000" ||
                  _response.status.toLowerCase() == "success" ||
                  _response.status == "M0000") {
                NavigationService.pushReplacement(
                  target: CommonTransactionSuccessPage(
                    serviceName: widget.service.service,
                    body: Column(
                      children: [
                        if (hashResponse.customerName.isEmpty)
                          KeyValueTile(
                            title: "Customer Name",
                            value: hashResponse.customerName,
                          ),
                        hashResponse.casId.isEmpty
                            ? Container()
                            : KeyValueTile(
                              title: "Customer ID",
                              value: hashResponse.casId,
                            ),
                        hashResponse.expiryDate.isEmpty
                            ? Container()
                            : KeyValueTile(
                              title: "Expiry Date",
                              value: hashResponse.expiryDate.toString(),
                            ),
                        hashResponse.balance.isEmpty
                            ? Container()
                            : KeyValueTile(
                              title: "Balance",
                              value: hashResponse.balance,
                            ),
                        KeyValueTile(title: "Amount", value: getAmount()),
                        const KeyValueTile(
                          title: "Package",
                          value: packageName,
                        ),

                        //  Container(
                        //     width: double.infinity,
                        //     child: CustomTextField(
                        //       readOnly: true,
                        //       trailing: Container(
                        //         width: 40.wp,
                        //         child: DropdownButton<TvPackages>(
                        //           underline: const SizedBox(),
                        //           onChanged: (TvPackages? value) {
                        //             if (value != null) {
                        //               selectedPackage = value;
                        //               getAmount();
                        //               testing = value.text;
                        //               setState(() {});

                        //               print(selectedPackage.text);
                        //             }
                        //           },
                        //           items: tvPackages
                        //               .map<DropdownMenuItem<TvPackages>>(
                        //             (TvPackages option) {
                        //               return DropdownMenuItem<TvPackages>(
                        //                 value: option,
                        //                 child: Text(
                        //                   option.text ?? "",
                        //                   style: _textTheme.titleSmall,
                        //                 ),
                        //               );
                        //             },
                        //           ).toList(),
                        //         ),
                      ],
                    ),
                    message: _response.message,
                    transactionID: _response.transactionIdentifier,
                  ),
                );
              } else {
                showPopUpDialog(
                  context: context,
                  message: _response.message,
                  title: _response.status,
                  buttonCallback: () {
                    NavigationService.pop();
                  },
                  showCancelButton: false,
                );
              }
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Details", style: _textTheme.headlineSmall),
              SizedBox(height: _height * 0.01),
              Column(
                children: [
                  KeyValueTile(title: "Customer ID", value: widget.userName),
                  hashResponse.customerName.isEmpty
                      ? Container()
                      : KeyValueTile(
                        title: "Customer Name",
                        value: hashResponse.customerName,
                      ),
                  hashResponse.casId.isEmpty
                      ? Container()
                      : KeyValueTile(
                        title: "Customer ID",
                        value: hashResponse.casId,
                      ),
                  hashResponse.expiryDate.isEmpty
                      ? Container()
                      : KeyValueTile(
                        title: "Expiry Date",
                        value: hashResponse.expiryDate.toString(),
                      ),
                  hashResponse.balance.isEmpty
                      ? Container()
                      : KeyValueTile(
                        title: "Balance",
                        value: hashResponse.balance,
                      ),
                  if (_changePackage == false &&
                      widget.detailFetchData.details.tvPackages.isEmpty)
                    KeyValueTile(title: "Amount", value: getAmount()),
                  if (_changePackage == true)
                    Column(
                      children: [
                        KeyValueTile(
                          title: "Package",
                          value: selectedPackageController.text,
                        ),
                        tvPackages.isEmpty
                            ? Container()
                            : Align(
                              alignment: Alignment.centerLeft,
                              child: CustomCheckbox(
                                selected: _changePackage,
                                onChanged: (val) {
                                  setState(() {
                                    _changePackage = !_changePackage;
                                  });
                                },
                                title: "Change Package",
                              ),
                            ),
                      ],
                    ),
                  if (widget.detailFetchData.details.tvPackages.isNotEmpty)
                    CustomTextField(
                      controller: selectedPackageController,
                      title: "Select Package",
                      readOnly: true,
                      onTap: () {
                        NavigationService.push(
                          target: TvPackageSearchWidgets(
                            onChanged: (value) {
                              selectedPackageController.text =
                                  value.text.toString();
                              selectedAmount.text = value.amount ?? "0";
                              selectedPackageId.text = value.id ?? "";
                              setState(() {});
                              _changePackage = true;
                            },
                            tvpackage: tvPackages,
                          ),
                        );
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
        onButtonPressed: () {
          NavigationService.push(
            target: TransactionPinScreen(
              onValueCallback: (p0) {
                NavigationService.pop();
                context.read<UtilityPaymentCubit>().makePayment(
                  mPin: p0,
                  apiEndpoint: "api/tvpay",
                  serviceIdentifier: widget.service.uniqueIdentifier,
                  body: {
                    "packageId": selectedPackageId.text,
                    // "customer_id": widget.userName,
                    // "username": widget.userName,
                  },
                  accountDetails: {
                    "account_number":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber.toString(),
                    "phone_number": widget.userName,
                    "customer_id": widget.userName,
                    "username": widget.userName,
                    "amount": getAmount(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
