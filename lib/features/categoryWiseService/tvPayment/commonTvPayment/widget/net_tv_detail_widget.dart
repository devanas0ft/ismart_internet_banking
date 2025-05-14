import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_list_tile.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class NetTvDetailWidget extends StatefulWidget {
  final ServiceList service;
  final UtilityResponseData detailFetchData;

  const NetTvDetailWidget({
    super.key,
    required this.detailFetchData,
    required this.service,
  });

  @override
  State<NetTvDetailWidget> createState() => _NetTvDetailWidgetState();
}

class _NetTvDetailWidgetState extends State<NetTvDetailWidget> {
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _serialController = TextEditingController();
  //String _currentAmount = '';
  bool _isLoading = false;
  String _selectedSerialNo = "";
  Map<String, dynamic>? _selectedPackage;
  UtilityResponseData? _packageDetails;
  List<Map<String, dynamic>> serialList = [];
  String _amount = "0";
  @override
  void dispose() {
    _packageController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final serialData = widget.detailFetchData.findValue<List<dynamic>>(
      primaryKey: "serialList",
    );
    if (serialData != null) {
      try {
        serialList =
            serialData.map((item) => Map<String, dynamic>.from(item)).toList();
      } catch (e) {
        print("Error casting serialList: $e");
        serialList = [];
      }
    } else {
      serialList = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    // final _theme = Theme.of(context);
    // final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;

    return PageWrapper(
      body: CommonContainer(
        verificationAmount: _amount.toString(),
        showDetail: true,
        topbarName: 'Payment',
        title: 'NetTV Payment',
        buttonName: 'Proceed',
        detail: 'Pay your NetTV subscription from here',
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
              final response = state.data;
              if (response.code == "M0000") {
                setState(() {
                  _packageDetails = response;
                });
              } else {
                showPopUpDialog(
                  context: context,
                  message: response.message,
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
                    controller: _serialController,
                    title: "Select Serial Number",
                    hintText: "Choose STB Serial Number",
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
                      itemCount: serialList.length,
                      itemBuilder: (context, index) {
                        final serial =
                            serialList[index].values.first ?? "Unknown Serial";
                        return CustomListTile(
                          title: serial,
                          description: '',
                          titleFontWeight: FontWeight.w400,
                          trailing: Container(),
                          onPressed: () {
                            _serialController.text = serial;
                            _selectedSerialNo = serial;
                            final sessionId =
                                widget.detailFetchData
                                    .findValue(primaryKey: "sessionId")
                                    ?.toString();
                            if (sessionId != null && serial.isNotEmpty) {
                              onButtonPressed(
                                sessionId: sessionId,
                                serialNo: serial,
                              );
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              if (_packageDetails != null) ...[
                SizedBox(height: _height * 0.02),

                // Package Details
                KeyValueTile(
                  title: "Customer Name",
                  value:
                      _packageDetails!
                          .findValue(primaryKey: "username")
                          .toString(),
                ),
                KeyValueTile(
                  title: "Current Package",
                  value:
                      _packageDetails!
                          .findValue(primaryKey: "package_name")
                          .toString(),
                ),
                KeyValueTile(
                  title: "Expiry Date",
                  value:
                      _packageDetails!
                          .findValue(primaryKey: "expiry_date")
                          .toString(),
                ),
                KeyValueTile(
                  title: "Package Status",
                  value:
                      _packageDetails!
                          .findValue(primaryKey: "package_status")
                          .toString(),
                ),
                KeyValueTile(
                  title: "Serial Number",
                  value:
                      _packageDetails!.findValue(primaryKey: "stb").toString(),
                ),
                KeyValueTile(title: "Amount", value: _amount.toString()),
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
                    final packageList = List.from(
                      _packageDetails!.findValue(primaryKey: "package_list") ??
                          [],
                    );

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (child, animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          axis: Axis.vertical,
                          child: child,
                        );
                      },
                      child: PageWrapper(
                        showBackButton: true,
                        body: ListView.builder(
                          itemCount: packageList.length,
                          itemBuilder: (context, index) {
                            final package = packageList[index];
                            // return ListTile(
                            //   title: Text(package["name"]),
                            //   subtitle: package["discount"] > 0.0
                            //       ? Text("Discount: ${package["discount"]}")
                            //       : const SizedBox(height: 2),
                            //   trailing: Text(
                            //     "Rs." +
                            //         (double.tryParse(
                            //                     package["amount"].toString()) ??
                            //                 0.0)
                            //             .toStringAsFixed(0),
                            //   ),
                            //   onTap: () {
                            //     setState(() {
                            //       _amount = double.tryParse(
                            //               package["amount"].toString()) ??
                            //           0.0;
                            //       _packageController.text = package["name"];
                            //       _selectedPackage = package;
                            //     });
                            //     Navigator.pop(context);
                            //   },
                            // );
                            return CustomListTile(
                              title: package["name"],
                              description:
                                  package["discount"] > 0.0
                                      ? "Discount: ${package["discount"]}"
                                      : "",
                              titleFontWeight: FontWeight.w400,
                              trailing: Text(
                                "Rs." +
                                    (double.tryParse(
                                              package["amount"].toString(),
                                            ) ??
                                            0.0)
                                        .toStringAsFixed(0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _amount = package["amount"].toString();
                                  _packageController.text = package["name"];
                                  _selectedPackage = package;
                                });
                                Navigator.pop(context);
                              },
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        onButtonPressed: () {
          if (_selectedPackage == null) {
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

          NavigationService.push(
            target: CommonBillDetailPage(
              serviceName: widget.service.service,
              body: Column(
                children: [
                  KeyValueTile(
                    title: "Username",
                    value:
                        _packageDetails!
                            .findValue(primaryKey: "username")
                            .toString(),
                  ),
                  KeyValueTile(
                    title: "Serial Number",
                    value: _selectedSerialNo,
                  ),
                  KeyValueTile(
                    title: "Selected Package",
                    value: _selectedPackage!["name"],
                  ),
                  KeyValueTile(
                    title: "Duration",
                    value: _selectedPackage!["duration"],
                  ),
                  KeyValueTile(title: "Amount", value: _amount.toString()),
                ],
              ),
              accountDetails: {
                "username": _packageDetails!.findValue(primaryKey: "username"),
                "serialNo": _selectedSerialNo,
                "sessionId": _packageDetails!.findValue(
                  primaryKey: "session_id",
                ),
                "packageSalesId": _selectedPackage!["package_sales_id"],
                "amount": _selectedPackage!["amount"],
                "accountNumber":
                    RepositoryProvider.of<CustomerDetailRepository>(
                      context,
                    ).selectedAccount.value?.accountNumber,
              },
              apiBody: const {},
              apiEndpoint: "api/nettv/payment",
              service: widget.service,
              serviceIdentifier: widget.service.uniqueIdentifier,
            ),
          );
        },
      ),
    );
  }

  void onButtonPressed({required String sessionId, required serialNo}) {
    context.read<UtilityPaymentCubit>().fetchDetailsPost(
      serviceIdentifier: widget.service.uniqueIdentifier,
      accountDetails: {"sessionId": sessionId, "serialNo": serialNo},
      apiEndpoint: "api/nettv/getPackage",
    );
  }
}
