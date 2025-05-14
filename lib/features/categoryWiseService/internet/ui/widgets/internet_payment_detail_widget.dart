import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/amount_utils.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_checkbox.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/internet/worldlink/widgets/worldlink_search_widget.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class InternetPaymentDeatilWidget extends StatefulWidget {
  final ServiceList service;
  final UtilityResponseData detailFetchData;

  const InternetPaymentDeatilWidget({
    super.key,
    required this.detailFetchData,
    required this.service,
  });
  @override
  State<InternetPaymentDeatilWidget> createState() =>
      _InternetPaymentDeatilWidgetState();
}

class _InternetPaymentDeatilWidgetState
    extends State<InternetPaymentDeatilWidget> {
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _changePackage = false;
  bool _isLoading = false;
  String _selectedPackageId = "";

  double _dueAmount = 0;

  @override
  void initState() {
    super.initState();

    _dueAmount =
        double.tryParse(
          widget.detailFetchData
                  .findValue(primaryKey: "due_amount_till_now")
                  ?.toString() ??
              "0",
        ) ??
        0;
    _amountController.text =
        ((double.tryParse(
                      widget.detailFetchData.findValueString(
                        "amount",
                        emptyString: "",
                      ),
                    ) ??
                    0) +
                _dueAmount)
            .toString();
  }

  @override
  Widget build(BuildContext context) {
    final bool _renewOption =
        widget.detailFetchData
            .findValue<List>(primaryKey: "packages")
            ?.isNotEmpty ??
        false;
    final _packageOptions = List.from(
      (_renewOption
              ? widget.detailFetchData.findValue(primaryKey: "packages")
              : widget.detailFetchData.findValue(
                primaryKey: "package_options",
              )) ??
          [],
    );
    final idd = List.from(
      widget.detailFetchData.findValue(primaryKey: "packages"),
    );
    final _defaultID = idd.where(
      (element) =>
          element["label"] ==
          widget.detailFetchData
              .findValue(
                primaryKey: "hashResponse",
                secondaryKey: "subscribedPackageName",
              )
              .toString(),
    );
    final amount =
        _selectedPackageId.isEmpty
            ? widget.detailFetchData
                        .findValue(
                          primaryKey: "hashResponse",
                          secondaryKey: "Amount",
                        )
                        .toString() ==
                    "0"
                ? _defaultID.first["amount"]
                : widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "Amount",
                    )
                    .toString()
            : _amountController.text;
    final bool _isPackageAvailable = _packageOptions.isNotEmpty;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: CommonContainer(
        verificationAmount:
            AmountUtils.getAmountInRupees(amount: amount).toString(),
        showDetail: true,
        topbarName: 'Payment',
        title: 'Internet Payment',
        buttonName: 'Proceed',
        detail: 'Pay your internet bill of you ISP from here',
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

              if (_response.code == "M0000") {
              } else {
                showPopUpDialog(
                  context: context,
                  message: _response.message,
                  title: "Error",
                  buttonCallback: () {
                    NavigationService.pop();
                  },
                  showCancelButton: false,
                );
              }
            }
          },
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Details", style: _textTheme.headlineSmall),
                  SizedBox(height: _height * 0.01),
                  KeyValueTile(
                    title: "Customer Name",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "customerName",
                            )
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Customer ID",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "wlinkUserName",
                            )
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Subscribed Package",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "subscribedPackageName",
                            )
                            .toString(),
                  ),

                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Reserve Info",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "Reserve Info",
                            )
                            .toString(),
                  ),

                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Subscription Type",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "subscribedPackageType",
                            )
                            .toString(),
                  ),
                  KeyValueTile(
                    title: "Amount",
                    value:
                        AmountUtils.getAmountInRupees(
                          amount: amount,
                        ).toString(),
                  ),
                  SizedBox(height: _height * 0.008),

                  // KeyValueTile(
                  //   title: "Days Remaining",
                  //   value: widget.detailFetchData
                  //       .findValue(
                  //         primaryKey: "hashResponse",
                  //         secondaryKey: "paymentMessage",
                  //       )
                  //       .toString(),
                  // ),
                  if (_isPackageAvailable)
                    CustomCheckbox(
                      leftMargin: CustomTheme.symmetricHozPadding,
                      selected: _changePackage,
                      onChanged: (val) {
                        setState(() {
                          _changePackage = true;
                        });
                      },
                      title: "Change Package",
                    ),
                  SizedBox(height: _height * 0.02),

                  //  if (_isPackageAvailable)
                  _changePackage || (_isPackageAvailable == false)
                      ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            axis: Axis.vertical,
                            child: child,
                          );
                        },
                        child: OpenContainer(
                          closedColor: Colors.transparent,
                          closedElevation: 0.0,
                          openElevation: 0,
                          transitionType: ContainerTransitionType.fade,
                          closedBuilder: (context, open) {
                            return CustomTextField(
                              margin: const EdgeInsets.only(
                                left: CustomTheme.symmetricHozPadding,
                                right: CustomTheme.symmetricHozPadding,
                              ),
                              controller: _packageController,
                              title: "",
                              hintText: "Renew Options",
                              showSearchIcon: true,
                              readOnly: true,
                              required: true,
                              suffixIcon: Icons.keyboard_arrow_down_rounded,
                              onTap: open,
                              validator: (val) {
                                return FormValidator.validateFieldNotEmpty(
                                  val,
                                  "Renew Options",
                                );
                              },
                            );
                          },
                          openBuilder: (context, close) {
                            return WorldlinkSearchWidgets(
                              useServiceResponse: widget.detailFetchData,
                              renewOptions: _renewOption,
                              onChanged: (val) {
                                _packageController.text = val["text"] ?? "";
                                _selectedPackageId =
                                    val["id"]?.toString() ?? "";
                                _amountController.text =
                                    ((double.tryParse(
                                                  val["amount"]?.toString() ??
                                                      "0",
                                                ) ??
                                                0) +
                                            _dueAmount)
                                        .toString();

                                setState(() {});
                              },
                            );
                          },
                        ),
                      )
                      : Container(),

                  SizedBox(height: _height * 0.01),
                ],
              ),
            ],
          ),
        ),
        onButtonPressed: () {
          final packageID =
              _selectedPackageId.isEmpty
                  ? _defaultID.first["id"]
                  : _selectedPackageId.toString();

          final boody = {
            "packageId": packageID,
            "Reserve Info":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "Reserve Info",
                    )
                    .toString(),
            "Result Message":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "Result Message",
                    )
                    .toString(),
            "subscribedPackageName":
                _packageController.text.isEmpty
                    ? widget.detailFetchData
                        .findValue(
                          primaryKey: "hashResponse",
                          secondaryKey: "subscribedPackageName",
                        )
                        .toString()
                    : _packageController.text,
            "paymentMessage":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "paymentMessage",
                    )
                    .toString(),
            "dueAmount":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "dueAmount",
                    )
                    .toString(),
            // "Amount": _amountController.text.isEmpty
            //     ? widget.detailFetchData
            //         .findValue(
            //             primaryKey: "hashResponse", secondaryKey: "Amount")
            //         .toString()
            //     : _amountController.text,
            "isNew":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "isNew",
                    )
                    .toString(),
            "sessionId":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "sessionId",
                    )
                    .toString(),
            "customerName":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "customerName",
                    )
                    .toString(),
            "subscribedPackageType":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "subscribedPackageType",
                    )
                    .toString(),
            "status":
                widget.detailFetchData
                    .findValue(
                      primaryKey: "hashResponse",
                      secondaryKey: "status",
                    )
                    .toString(),
          };

          NavigationService.push(
            target: CommonBillDetailPage(
              serviceName: widget.service.service,
              body: Column(
                children: [
                  KeyValueTile(
                    title: "Customer Name",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "customerName",
                            )
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Customer ID",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "wlinkUserName",
                            )
                            .toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Subscribed Package",
                    value:
                        _packageController.text.isEmpty
                            ? widget.detailFetchData
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "subscribedPackageName",
                                )
                                .toString()
                            : _packageController.text,
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Subscription Type",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "subscribedPackageType",
                            )
                            .toString(),
                  ),
                  KeyValueTile(
                    title: "Amount",
                    value:
                        AmountUtils.getAmountInRupees(
                          amount: amount,
                        ).toString(),
                  ),
                  SizedBox(height: _height * 0.008),
                  KeyValueTile(
                    title: "Days Remaining",
                    value:
                        widget.detailFetchData
                            .findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "paymentMessage",
                            )
                            .toString(),
                  ),
                ],
              ),
              accountDetails: {
                "wlink_username":
                    widget.detailFetchData
                        .findValue(
                          primaryKey: "hashResponse",
                          secondaryKey: "wlinkUserName",
                        )
                        .toString(),
                "amount": amount,
                "account_number":
                    RepositoryProvider.of<CustomerDetailRepository>(
                      context,
                    ).selectedAccount.value?.accountNumber,
              },
              apiEndpoint: "api/wlinkpay",
              apiBody: boody,
              service: widget.service,
              serviceIdentifier: widget.service.uniqueIdentifier,
            ),
          );

          //   NavigationService.push(
          //     target: TransactionPinScreen(
          //       onValueCallback: (mpin) {
          //         NavigationService.pop();
          //         context.read<UtilityPaymentCubit>().makePayment(
          //               mPin: mpin,
          //               body: {},
          //               // body: widget.detailFetchData
          //               //     .findValue(primaryKey: "hashResponse"),
          //               serviceIdentifier: "worldlink_online_topup",
          //               accountDetails: {
          //                 "wlink_username": widget.detailFetchData
          //                     .findValue(
          //                       primaryKey: "hashResponse",
          //                       secondaryKey: "wlinkUserName",
          //                     )
          //                     .toString(),
          //                 "amount": widget.detailFetchData
          //                     .findValue(
          //                         primaryKey: "hashResponse",
          //                         secondaryKey: "Amount")
          //                     .toString(),
          //                 "account_number":
          //                     RepositoryProvider.of<CustomerDetailRepository>(
          //                             context)
          //                         .selectedAccount
          //                         .value
          //                         ?.accountNumber,
          //               },
          //               apiEndpoint: "api/wlinkpay",
          //             );
          //       },
          //     ),
          //   );
        },
      ),
    );
  }

  // amountBox(context, index) {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 7),
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.black),
  //     ),
  //     child: Center(child: Text(amount[index].toString())),
  //   );
  // }

  // final List amount = [100, 200, 500, 1000, 2000, 5000];
}
