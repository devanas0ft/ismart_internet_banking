import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/internet/common/widget/common_username_search_widget.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class CommonInternetPaymentDeatilWidget extends StatefulWidget {
  final UtilityResponseData detailFetchData;
  final String username;
  final String amount;
  final ServiceList service;
  const CommonInternetPaymentDeatilWidget({
    super.key,
    required this.detailFetchData,
    required this.service,
    required this.amount,
    required this.username,
  });
  @override
  State<CommonInternetPaymentDeatilWidget> createState() =>
      _CommonInternetPaymentDeatilWidgetState();
}

class _CommonInternetPaymentDeatilWidgetState
    extends State<CommonInternetPaymentDeatilWidget> {
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  bool _changePackage = false;
  String? _selectedPackageId;
  String? _selectedPackageName;

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
                      widget.detailFetchData.findValue(
                        primaryKey: "hashResponse",
                        secondaryKey: "amount",
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

    bool _isLoading = false;
    // ignore: unused_local_variable
    final bool _isPackageAvailable = _packageOptions.isNotEmpty;
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    // final _width = SizeUtils.width;
    final _height = SizeUtils.height;

    String getPackageName() {
      if (_selectedPackageName == null) {
        return "";
      } else {
        return _selectedPackageName ?? "";
      }
    }

    String getPackageId() {
      if (_selectedPackageId == null) {
        return "";
      } else {
        return _selectedPackageId ?? "";
      }
    }

    String getAmount() {
      if (widget.amount.isNotEmpty && _changePackage == false) {
        return widget.amount;
      } else {
        if (widget.detailFetchData
                .findValue(
                  primaryKey: "hashResponse",
                  secondaryKey: "monthlyCharge",
                )
                .toString()
                .isNotEmpty &&
            _changePackage == false) {
          return widget.detailFetchData.findValue(
            primaryKey: "hashResponse",
            secondaryKey: "monthlyCharge",
          );
        } else {
          return _amountController.text.toString();
        }
      }
    }

    return PageWrapper(
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
            if (_response.status.toLowerCase() == "success" ||
                _response.code == "M0000" ||
                _response.status == "M0000") {
              NavigationService.push(
                target: CommonTransactionSuccessPage(
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
                                      secondaryKey: "userName",
                                    )
                                    .toString()
                                    .isEmpty
                                ? widget.detailFetchData
                                    .findValue(
                                      primaryKey: "hashResponse",
                                      secondaryKey: "username",
                                    )
                                    .toString()
                                : widget.detailFetchData.findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "userName",
                                ),
                      ),
                      KeyValueTile(title: "Package", value: getPackageName()),
                      KeyValueTile(title: "Amount", value: getAmount()),
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
                title: "Error",
                showCancelButton: false,
                buttonCallback: () {
                  NavigationService.pop();
                },
              );
            }
          }
          print("state iaushdasd $state");
        },
        child: CommonContainer(
          showDetail: true,
          showRoundBotton: _changePackage,
          topbarName: widget.service.serviceCategoryName,
          title: widget.service.service,
          buttonName: 'Proceed',
          detail: widget.service.instructions,
          showAccountSelection: true,
          body: Column(
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
                                  secondaryKey: "userName",
                                )
                                .toString()
                                .isEmpty
                            ? widget.detailFetchData
                                .findValue(
                                  primaryKey: "hashResponse",
                                  secondaryKey: "username",
                                )
                                .toString()
                            : widget.detailFetchData.findValue(
                              primaryKey: "hashResponse",
                              secondaryKey: "userName",
                            ),
                  ),
                  SizedBox(height: _height * 0.008),

                  _changePackage == true
                      ? Column(
                        children: [
                          KeyValueTile(
                            title: "Package",
                            value: getPackageName(),
                          ),
                          KeyValueTile(title: "Amount", value: getAmount()),
                        ],
                      )
                      : Text(
                        "Select Package",
                        style: _textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  SizedBox(height: _height * 0.008),
                  // CustomCheckbox(
                  //   leftMargin: CustomTheme.symmetricHozPadding,
                  //   selected: _changePackage,
                  //   onChanged: (val) {
                  //     setState(() {
                  //       _changePackage = val;
                  //     });
                  //   },
                  //   title: "Change Package",
                  // ),
                  SizedBox(height: _height * 0.02),
                  AnimatedSwitcher(
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
                        _changePackage = true;
                        return CommonInternetPackageSearchWidgets(
                          useServiceResponse: widget.detailFetchData,
                          renewOptions: _renewOption,
                          onChanged: (val) {
                            _packageController.text = val["text"].toString();
                            _selectedPackageId = val["id"].toString();
                            _amountController.text =
                                ((double.tryParse(
                                              val["amount"]?.toString() ?? "0",
                                            ) ??
                                            0) +
                                        _dueAmount)
                                    .toString();
                            _selectedPackageId = val["id"];
                            _selectedPackageName = val["text"];
                            getPackageId();
                            getPackageName();
                            getAmount();
                            setState(() {});
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20.hp),
                ],
              ),
            ],
          ),
          onButtonPressed: () {
            final body = {
              "packageId": getPackageId(),
              "subscribedPackageName": getPackageName(),
            };
            NavigationService.push(
              target: TransactionPinScreen(
                onValueCallback: (mpin) {
                  NavigationService.pop();
                  final accountDetails = {
                    "username": widget.username,
                    "amount": getAmount(),
                    "account_number":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value?.accountNumber,
                    if (widget.detailFetchData.findValue(
                          primaryKey: "hashResponse",
                          secondaryKey: "session_id",
                        ) !=
                        null)
                      "sessionId": widget.detailFetchData.findValue(
                        primaryKey: "hashResponse",
                        secondaryKey: "session_id",
                      ),
                    if (widget.detailFetchData.findValue(
                          primaryKey: "hashResponse",
                          secondaryKey: "customer_id",
                        ) !=
                        null)
                      "customerId": widget.detailFetchData.findValue(
                        primaryKey: "hashResponse",
                        secondaryKey: "customer_id",
                      ),
                  };
                  accountDetails.removeWhere(
                    (key, value) => value == null || value.toString().isEmpty,
                  );
                  context.read<UtilityPaymentCubit>().makePayment(
                    mPin: mpin,
                    body: body,
                    serviceIdentifier: widget.service.uniqueIdentifier,
                    accountDetails: accountDetails,
                    apiEndpoint: "/api/internetpay",
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
