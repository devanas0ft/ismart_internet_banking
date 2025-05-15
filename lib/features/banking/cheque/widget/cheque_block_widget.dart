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
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

// ignore: must_be_immutable
class ChequeBlockWidget extends StatelessWidget {
  ChequeBlockWidget({Key? key}) : super(key: key);
  final TextEditingController chequeNumberController = TextEditingController();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    return BlocListener<UtilityPaymentCubit, CommonState>(
      listener: (context, state) {
        if (state is CommonLoading && _isLoading == false) {
          _isLoading = true;
          showLoadingDialogBox(context);
        } else if (state is! CommonLoading && _isLoading) {
          _isLoading = false;
          NavigationService.pop();
        } else if (state is CommonError) {
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
              message: state.data.message,
              title: _response.status,
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
            chequeNumberController.clear();
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
              controller: chequeNumberController,
              title: "Enter Cheque Number",
              hintText: "XXXXXXXXX",
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
                            "chequeLeaves": chequeNumberController.text,
                            "mPin": p0,
                          },
                          apiEndpoint: "/api/chequeblockrequest",
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
