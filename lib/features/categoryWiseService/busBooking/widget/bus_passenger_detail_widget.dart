import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/models/common_contact_model.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/wrapper/bottom_sheet_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/screen/bus_bill_detail_page.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class BusPassengerDetailWidget extends StatefulWidget {
  final double totalFare;
  final ServiceList service;
  final BusTopBarModel busModel;
  final List selectedSeats;

  final selectedBusData;
  final UtilityResponseData response;

  const BusPassengerDetailWidget({
    Key? key,
    required this.service,
    required this.totalFare,
    required this.response,
    required this.selectedBusData,
    required this.busModel,
    required this.selectedSeats,
  }) : super(key: key);

  @override
  State<BusPassengerDetailWidget> createState() =>
      _BusPassengerDetailWidgetState();
}

class _BusPassengerDetailWidgetState extends State<BusPassengerDetailWidget> {
  final _formKey = GlobalKey<FormState>();

  final contactName =
      TextEditingController()
        ..text =
            RepositoryProvider.of<CustomerDetailRepository>(
              NavigationService.context,
            ).selectedAccount.value?.accountHolderName ??
            "";

  String _currentAmount = '';
  @override
  void initState() {
    _currentAmount = widget.totalFare.toString();
    super.initState();
  }

  final contactEmail = TextEditingController();

  final contactNumber = TextEditingController();
  final remarksController = TextEditingController();

  String? boardingPoint;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final List<dynamic> responseData = widget.response.findValue(
      primaryKey: "boardingPoints",
    );
    // final boardingPonit = responseData.findValue(primaryKey:"")

    return PageWrapper(
      body: CommonContainer(
        showAccountSelection: false,
        buttonName: "Procced",
        showDetail: true,
        title: "Contact Person Details",
        verificationAmount: _currentAmount,
        detail: widget.response.message,
        topbarName: widget.service.serviceCategoryName,
        body: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                title: 'Full Name',
                hintText: 'Full Name',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: contactName,
                validator:
                    (value) =>
                        FormValidator.validateFieldNotEmpty(value, "Name"),
              ),
              CustomTextField(
                title: 'Email',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                hintText: 'Email',
                controller: contactEmail,
                validator: (value) => FormValidator.validateEmail(value),
              ),
              CustomTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                title: 'Mobile Number',
                hintText: 'Mobile Number',
                controller: contactNumber,
                validator: (value) => FormValidator.validatePhoneNumber(value),
              ),
              CustomTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                title: 'Remarks',
                hintText: 'remarks',
                controller: remarksController..text = "Bus Booking",
                validator:
                    (value) =>
                        FormValidator.validateFieldNotEmpty(value, "Remarks"),
              ),
              CustomTextField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (boardingPoint == null) {
                    return "Please select boarding point";
                  }
                  return null;
                },
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (context) => BottomSheetWrapper(
                          title: "Boarding Points",
                          child: Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      boardingPoint = responseData[index];
                                    });
                                    NavigationService.pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                    ),
                                    child: Text(
                                      (index + 1).toString() +
                                          " " +
                                          responseData[index],
                                      style: _textTheme.titleLarge,
                                    ),
                                  ),
                                );
                              },
                              itemCount: responseData.length,
                            ),
                          ),
                        ),
                  );
                },
                readOnly: true,
                title: "Boarding Point",
                hintText: boardingPoint ?? "Select",
                customHintTextStyle: true,
              ),
            ],
          ),
        ),
        onButtonPressed: () {
          if (_formKey.currentState!.validate()) {
            NavigationService.push(
              target: BusBillDetailPage(
                remarks: remarksController.text,
                totalFare: widget.totalFare,
                response: widget.response,
                contactDetail: UserContactModel(
                  email: contactEmail.text,
                  fullName: contactName.text,
                  phoneNumber: contactNumber.text,
                ),
                boardingPoint: boardingPoint ?? "",
                selectedSeats: widget.selectedSeats,
                busModel: widget.busModel,
                service: widget.service,
                busData: widget.selectedBusData,
              ),
            );
          }
        },
      ),
    );
  }
}
