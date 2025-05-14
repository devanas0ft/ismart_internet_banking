import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/wrapper/bottom_sheet_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/resources/passenger_detail_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/airlines_bill_detail_widget.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/airlines_nationality.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/airlines_title_list.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

// ignore: must_be_immutable
class PassengerDetailWidget extends StatefulWidget {
  Flight? departureFlight;
  final String? airlineID;

  final bool isTwoWay;
  Flight? arrivalFlight;

  final double totalFare;
  final ServiceList service;

  PassengerDetailWidget({
    Key? key,
    required this.arrivalFlight,
    required this.adultCount,
    required this.childrenCount,
    required this.departureFlight,
    required this.service,
    required this.totalFare,
    this.airlineID,
    required this.isTwoWay,
  }) : super(key: key);

  final int adultCount;
  final int childrenCount;

  @override
  State<PassengerDetailWidget> createState() => _PassengerDetailWidgetState();
}

class _PassengerDetailWidgetState extends State<PassengerDetailWidget> {
  final _formKey = GlobalKey<FormState>();

  final contactName = TextEditingController();

  final contactEmail = TextEditingController();

  final contactNumber = TextEditingController();

  List<PassengerDetailModel> passengers = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.adultCount; i++) {
      passengers.add(
        PassengerDetailModel(
          nationalityName: "Select",
          firstname: "",
          remarks: "",
          lastname: "",
          gender: "",
          title: "Select",
          nationality: "",
          type: "ADULT",
        ),
      );
    }
    for (int i = 0; i < widget.childrenCount; i++) {
      passengers.add(
        PassengerDetailModel(
          nationality: "",
          nationalityName: "Select",
          gender: "",
          remarks: "",
          title: "Select",
          firstname: "",
          lastname: "",
          type: "CHILDREN",
        ),
      );
    }
    // for (int i = 0; i < widget.numberOfInfants; i++) {
    //   passengers
    //       .add(Passenger(name: '', phone: '', type: PassengerType.infant));
    // }
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    // final userDetail = RepositoryProvider.of<CustomerDetailRepository>(context);

    return PageWrapper(
      body: CommonContainer(
        showAccountSelection: false,
        buttonName: "Procced",
        showDetail: true,
        title: "Contact Person Details",
        detail: "Ticket will be sent to below input number",
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
              SizedBox(height: 10.hp),
              Text('Passenger Detail', style: _textTheme.displaySmall),
              Text(
                'Please enter following details of passenger traveling.',
                style: _textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.adultCount + widget.childrenCount,
                itemBuilder: (context, index) {
                  final passenger = passengers[index];
                  return Column(
                    children: [
                      CustomTextField(
                        readOnly: true,
                        customHintTextStyle: true,
                        hintText:
                            passenger.type == "ADULT" ? "Adult" : "Children",
                        title: "Type",
                        onChanged: (value) {
                          setState(() {
                            passenger.type =
                                passenger.type == "ADULT"
                                    ? "ADULT".toLowerCase()
                                    : "CHILDREN".toLowerCase();
                          });
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              validator: (value) {
                                if (passenger.title == "Select") {
                                  return "Please select Title";
                                }
                                return null;
                              },
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _theme.primaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                              18,
                                            ),
                                      ),
                                      child: BottomSheetWrapper(
                                        title: "Select Title",
                                        child: AirlinesTitleList(
                                          onPress: (p0) {
                                            NavigationService.pop();
                                            passenger.title = p0;
                                            passenger.gender =
                                                passenger.title == "Mr."
                                                    ? "M"
                                                    : "F";
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              readOnly: true,
                              title: "Title",
                              hintText: passenger.title,
                              customHintTextStyle: true,
                              onChanged: (value) {
                                setState(() {
                                  passenger.title = value;
                                });
                              },
                            ),
                          ),
                          SizedBox(width: 20.wp),
                          Expanded(
                            child: CustomTextField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (passenger.nationalityName == "Select") {
                                  return "Please select Nationality";
                                }
                                return null;
                              },
                              hintText: passenger.nationalityName,
                              customHintTextStyle: true,
                              readOnly: true,
                              title: "Nationality",
                              onTap: () {
                                showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _theme.primaryColor,
                                        ),
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                              18,
                                            ),
                                      ),
                                      child: BottomSheetWrapper(
                                        title: "Select Nationality",
                                        child: AirlinesNationalityList(
                                          onChanged: (value) {
                                            NavigationService.pop();
                                            passenger.nationalityName =
                                                value.title;
                                            passenger.nationality = value.value;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onChanged: (value) {
                                setState(() {
                                  // passenger.nationality = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: CustomTextField(
                                title: "First Name",
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onChanged: (value) {
                                  setState(() {
                                    passenger.firstname = value;
                                  });
                                },
                                validator:
                                    (value) =>
                                        FormValidator.validateFieldNotEmpty(
                                          value,
                                          "Name",
                                        ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20.wp),
                          Expanded(
                            child: Container(
                              child: CustomTextField(
                                title: "Last Name",
                                onChanged: (value) {
                                  setState(() {
                                    passenger.lastname = value;
                                  });
                                },
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator:
                                    (value) =>
                                        FormValidator.validateFieldNotEmpty(
                                          value,
                                          "Name",
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      CustomTextField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        title: "Remarks",
                        onChanged: (value) {
                          setState(() {
                            passenger.remarks = value;
                          });
                        },
                        validator:
                            (value) => FormValidator.validateFieldNotEmpty(
                              value,
                              "Remarks",
                            ),
                      ),
                      const Divider(thickness: 2),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        onButtonPressed: () {
          final numberOfPassenger = widget.adultCount + widget.childrenCount;
          final departureComission = double.parse(
            widget.departureFlight?.agencyCommission ?? "0",
          );
          final arrivalComission = double.parse(
            widget.arrivalFlight?.agencyCommission ?? "0",
          );
          final double totalAgencyComission =
              (departureComission + arrivalComission) * numberOfPassenger;
          final departureFee = double.parse(widget.departureFlight?.tax ?? "0");
          final arrivalFee = double.parse(widget.arrivalFlight?.tax ?? "0");

          final double feeTax = departureFee + arrivalFee;
          final List passengerList =
              passengers.map((passenger) => passenger.toJson()).toList();
          _formKey.currentState!.save();
          if (_formKey.currentState!.validate()) {
            NavigationService.pushReplacement(
              target: AirlinesBillDetailPage(
                isTwoWay: widget.isTwoWay,
                passengerList: passengerList,
                contactEmail: contactEmail.text,
                contactName: contactName.text,
                contactPhoneNumber: contactNumber.text,
                arrivalFlight: widget.arrivalFlight,
                departureFlight: widget.departureFlight,
                totalFare: widget.totalFare,
                accountDetails: const {},
                apiEndpoint: "/api/arsissueticket",
                apiBody: {
                  "accountNumber":
                      RepositoryProvider.of<CustomerDetailRepository>(
                        context,
                      ).selectedAccount.value!.accountNumber,
                  "agencyCommission": totalAgencyComission,
                  "airlineId": widget.airlineID,
                  "amount": widget.totalFare,
                  "channel": "MOBILE",
                  "serviceIdentifier": "ARS",
                  "contactEmail": contactEmail.text,
                  "contactName": contactName.text,
                  "contactNumber": contactNumber.text,
                  "feeTax": feeTax * numberOfPassenger,
                  "flightId": widget.departureFlight?.flightId ?? "",
                  "returnFlightId": widget.arrivalFlight?.flightId ?? "",
                  "reservationStatus": "OK",
                  "totalPassenger": numberOfPassenger,
                  "issueTicketRequest": passengerList,
                },
                service: widget.service,
                serviceIdentifier: widget.service.uniqueIdentifier,
              ),
            );
          }
        },
      ),
    );
  }
}
