import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/url_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/payment_web_view.dart';
import 'package:ismart_web/features/auth/resources/user_repository.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

class ConnectIpsWidget extends StatefulWidget {
  const ConnectIpsWidget({Key? key}) : super(key: key);

  @override
  State<ConnectIpsWidget> createState() => _ConnectIpsWidgetState();
}

class _ConnectIpsWidgetState extends State<ConnectIpsWidget> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String token = "";

  @override
  void initState() {
    // TODO: implement initState
    token = RepositoryProvider.of<UserRepository>(context).token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      body: CommonContainer(
        showDetail: true,
        showAccountSelection: true,
        accountTitle: "To Account",
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                title: "Amount",
                hintText: "NPR",
                controller: _amountController,
                validator:
                    (val) => FormValidator.validateFieldNotEmpty(val, "Amount"),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              // CustomTextField(
              //   title: "Charge",
              //   hintText: "NPR 10.00",
              // ),
              CustomTextField(
                title: "Remarks",
                hintText: "Remarks",
                controller: _remarksController,
                validator:
                    (val) =>
                        FormValidator.validateFieldNotEmpty(val, "Remarks"),
              ),
            ],
          ),
        ),
        topbarName: "Receive Money",
        onButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            final _body = {
              "accountNo":
                  RepositoryProvider.of<CustomerDetailRepository>(
                    context,
                  ).selectedAccount.value!.accountNumber,
              "amount": _amountController.text,
              "remarks": _remarksController.text,
            };
            final _url =
                RepositoryProvider.of<CoOperative>(context).baseUrl +
                "api/load_from_connectips/payment/";
            final url = UrlUtils.getUri(url: _url, params: _body);

            NavigationService.push(
              target: PaymentWebView(
                urlRequest: URLRequest(
                  url: WebUri.uri(url),
                  headers: {
                    // urlRequest: URLRequest(url: url, headers: {
                    "Authorization": "Bearer $token",
                  },
                ),
                receiptUrl: "receiptUrl",
              ),
            );
          }
        },
        buttonName: "Proceed",
        title: "Connect IPS",
        detail: "You can load fund instantly from connect IPS",
      ),
    );
  }
}
