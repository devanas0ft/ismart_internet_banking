import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_bill_details_screen.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class SubisuPaymentWidget extends StatefulWidget {
  const SubisuPaymentWidget({Key? key, required this.service})
    : super(key: key);

  final ServiceList service;

  @override
  State<SubisuPaymentWidget> createState() => _SubisuPaymentWidgetState();
}

class _SubisuPaymentWidgetState extends State<SubisuPaymentWidget> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _amountController = TextEditingController();
  String _currentAmmount = "";

  @override
  Widget build(BuildContext context) {
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      body: Form(
        key: _formKey,
        child: CommonContainer(
          verificationAmount: _currentAmmount,
          showRecentTransaction: true,
          associatedId: widget.service.id.toString(),
          showAccountSelection: true,
          showDetail: true,
          title: 'Internet Payment',
          detail: 'Pay your internet bill of your ISP from here',
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: _height * 0.1,
                    width: _width * 0.2,
                    margin: const EdgeInsets.only(right: 18),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withOpacity(0.05),
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                        ),
                      ],
                      //color: _theme.primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        "${RepositoryProvider.of<CoOperative>(context).baseUrl}/ismart/serviceIcon/${widget.service.icon}",
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.service.service,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _height * 0.03),
              Text(
                "Provide Username and Details to pay.",
                style: Theme.of(context).textTheme.labelMedium,
              ),
              SizedBox(height: _height * 0.03),
              CustomTextField(
                title: 'Username',
                controller: _usernameController,
                hintText: 'Enter Username',
                validator:
                    (value) =>
                        FormValidator.validateFieldNotEmpty(value, 'Username'),
              ),
              CustomTextField(
                title: 'Mobile Number',
                validator: (value) => FormValidator.validatePhoneNumber(value),
                controller: _mobileNumberController,
                hintText: 'Enter Mobile Number',
                textInputType: TextInputType.number,
              ),
              CustomTextField(
                title: 'Amount',
                validator:
                    (value) =>
                        FormValidator.validateFieldNotEmpty(value, 'Amount'),
                controller: _amountController,
                hintText: 'Enter Amount (400 - 10000)',
                textInputType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _currentAmmount = value;
                  });
                },
              ),
            ],
          ),
          topbarName: 'Payment',
          buttonName: 'Proceed',
          onButtonPressed: () {
            if (_formKey.currentState!.validate()) {
              NavigationService.push(
                target: CommonBillDetailPage(
                  serviceName: widget.service.service,
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "Customer ID",
                        value: _usernameController.text,
                      ),
                      KeyValueTile(
                        title: "Mobile Number",
                        value: _mobileNumberController.text,
                      ),
                      KeyValueTile(
                        title: "Amount",
                        value: _amountController.text,
                      ),
                    ],
                  ),
                  accountDetails: {
                    "amount": _amountController.text,
                    "account_number":
                        RepositoryProvider.of<CustomerDetailRepository>(
                          context,
                        ).selectedAccount.value!.accountNumber,
                    "customerId": _usernameController.text,
                    "phone_number": _mobileNumberController.text,
                  },
                  apiEndpoint: "/api/subisupay",
                  apiBody: const {},
                  service: widget.service,
                  serviceIdentifier: widget.service.uniqueIdentifier,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
