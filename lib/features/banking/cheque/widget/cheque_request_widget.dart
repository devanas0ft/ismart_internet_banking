import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/common/wrapper/bottom_sheet_wrapper.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class ChequeRequestWidget extends StatefulWidget {
  const ChequeRequestWidget({Key? key}) : super(key: key);

  @override
  State<ChequeRequestWidget> createState() => _ChequeRequestWidgetState();
}

class _ChequeRequestWidgetState extends State<ChequeRequestWidget> {
  final TextEditingController chequeLeavesController = TextEditingController();

  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  final List<int> numberOfCheque = [10, 20, 30, 40, 50];

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    return BlocListener<UtilityPaymentCubit, CommonState>(
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
            showPopUpDialog(
              context: context,
              message: _response.message,
              title: _response.status,
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          } else {
            showPopUpDialog(
              context: context,
              message: _response.message,
              title: "Exception",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            PrimaryAccountBox(),
            CustomTextField(
              readOnly: true,
              onTap: () {
                showBottomSheet(
                  context: context,
                  builder:
                      (context) => BottomSheetWrapper(
                        title: "Select Number",
                        child: Container(
                          width: double.infinity,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ...List.generate(
                                  numberOfCheque.length,
                                  (index) => Container(
                                    padding: const EdgeInsets.all(20),
                                    margin: const EdgeInsets.only(right: 15),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      // borderRadius: BorderRadius.circular(100),
                                    ),
                                    // shape: CircleBorder(),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(100),
                                      onTap: () {
                                        setState(() {});
                                        chequeLeavesController.text =
                                            numberOfCheque[index].toString();
                                        NavigationService.pop();
                                      },
                                      child: Center(
                                        child: Text(
                                          numberOfCheque[index].toString(),
                                          textAlign: TextAlign.center,
                                          style: _textTheme.headlineSmall,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // child: GridView.builder(
                        //   // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        //   //   crossAxisCount: 5,
                        //   // ),
                        //   shrinkWrap: true,
                        //   itemCount: numberOfCheque.length,
                        //   itemBuilder: (context, index) =>
                        // Container(
                        //     decoration: BoxDecoration(
                        //       shape: BoxShape.circle,
                        //       color: Colors.white,
                        //       // borderRadius: BorderRadius.circular(100),
                        //     ),
                        //     // shape: CircleBorder(),
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.circular(100),
                        //       onTap: () {
                        //         setState(() {});
                        //         chequeLeavesController.text =
                        //             numberOfCheque[index].toString();
                        //         NavigationService.pop();
                        //       },
                        //       child: Center(
                        //         child: Text(
                        //           numberOfCheque[index].toString(),
                        //           textAlign: TextAlign.center,
                        //           style: _textTheme.headlineSmall,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                );
              },
              controller: chequeLeavesController,
              title: "Select Cheque Leaves",
              hintText: "10",
              validator:
                  (value) => FormValidator.validateFieldNotEmpty(
                    value,
                    "Cheque Number",
                  ),
            ),
            SizedBox(height: _height * 0.02),
            CustomRoundedButtom(
              title: "Confirm",
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  NavigationService.push(
                    target: TransactionPinScreen(
                      onValueCallback: (p0) {
                        NavigationService.pop();
                        context.read<UtilityPaymentCubit>().makePayment(
                          serviceIdentifier: "",
                          accountDetails: {},
                          body: {
                            "accountNumber":
                                RepositoryProvider.of<CustomerDetailRepository>(
                                  context,
                                ).selectedAccount.value!.accountNumber,
                            "chequeLeaves": chequeLeavesController.text,
                            "mPin": p0,
                          },
                          apiEndpoint: "api/chequerequest",
                          mPin: p0,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
