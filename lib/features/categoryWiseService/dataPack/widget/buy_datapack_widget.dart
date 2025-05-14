import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/dataPack/model/datapack_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class BuyDatapackWidget extends StatefulWidget {
  const BuyDatapackWidget({
    Key? key,
    required this.service,
    required this.package,
  }) : super(key: key);
  final ServiceList service;
  final DataPackPackage package;

  @override
  State<BuyDatapackWidget> createState() => _BuyDatapackWidgetState();
}

class _BuyDatapackWidgetState extends State<BuyDatapackWidget> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final _mobileNumberController = TextEditingController();

  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
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

          if (state is CommonStateSuccess<UtilityResponseData>) {
            NavigationService.pushReplacement(
              target: CommonTransactionSuccessPage(
                serviceName: widget.service.service,
                transactionID: state.data.findValueString(
                  "transactionIdentifier",
                ),
                body: Container(),
                message: state.data.message,
                service: widget.service,
              ),
            );
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
          // } else if (state is CommonError) {
          //   showPopUpDialog(
          //     context: context,
          //     message: state.message,
          //     title: "Error",
          //     showCancelButton: false,
          //     buttonCallback: () {
          //       NavigationService.pop();
          //     },
          //   );
        },
        child: CommonContainer(
          title: widget.service.service,
          detail: "Buy Data Pack from ",
          //detail: widget.service.instructions,
          showDetail: true,
          showRoundBotton: true,
          showTitleText: true,
          showAccountSelection: true,
          buttonName: 'Proceed',
          accountTitle: 'From Account',
          onButtonPressed: () {
            _formKey.currentState!.save();
            if (_formKey.currentState!.validate()) {
              NavigationService.push(
                target: CommonBillDetailPage(
                  serviceName: widget.service.service,
                  service: widget.service,
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Number",
                        value: _mobileNumberController.text,
                      ),
                      KeyValueTile(
                        title: "Package",
                        value: widget.package.name,
                      ),
                      KeyValueTile(
                        title: "Desc",
                        value: widget.package.description,
                      ),
                      KeyValueTile(
                        title: "Amount",
                        value: widget.package.amount.toString(),
                      ),
                    ],
                  ),
                  accountDetails: {
                    "account_number":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber.toString(),
                    "phone_number": _mobileNumberController.text,
                    "amount": widget.package.amount.toString(),
                  },
                  apiEndpoint: "/api/data_pack/pay",
                  apiBody: {"code": widget.package.code},
                  serviceIdentifier: widget.service.uniqueIdentifier,
                ),
              );
            }
          },
          body: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}",
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.service.service,
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          '( ${widget.package.name} )',
                          style: Theme.of(context).textTheme.titleLarge!
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.05),
              Form(
                key: _formKey,
                child: CustomTextField(
                  title: "Mobile Number",
                  hintText: "xxxxxxxxxx",
                  controller: _mobileNumberController,
                  validator:
                      (value) => FormValidator.validatePhoneNumber(value),
                  suffixIcon: Icons.phone_android_outlined,
                  showSearchIcon: true,
                  onSuffixPressed: () async {
                    final String phoneNumber =
                        await SharedPref.getPhoneNumber();
                    _mobileNumberController.text = phoneNumber;
                  },
                ),
              ),
              SizedBox(height: _height * 0.05),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Payable Amount:', style: _textTheme.titleLarge),
                  Text(
                    'NPR ${widget.package.amount}',
                    style: _textTheme.titleLarge!.copyWith(
                      color: CustomTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          topbarName: 'Data Pack',
        ),
      ),
    );
  }
}
