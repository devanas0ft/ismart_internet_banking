import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/fonts.dart';
import 'package:ismart_web/common/models/common_contact_model.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_transaction_success_screen.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/key_value_tile.dart';
import 'package:ismart_web/common/widget/loan_key_value_tile.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

// ignore: must_be_immutable
class BusBillDetailWidget extends StatelessWidget {
  final BusTopBarModel busTopBarModel;
  final ServiceList service;
  final List selectedSeats;
  final selectedBusData;
  final String boardingPoint;
  final UserContactModel contactDetail;
  final UtilityResponseData response;
  final double totalFare;
  final String remarks;

  BusBillDetailWidget({
    Key? key,
    required this.service,
    required this.selectedBusData,
    required this.busTopBarModel,
    required this.selectedSeats,
    required this.boardingPoint,
    required this.contactDetail,
    required this.response,
    required this.totalFare,
    required this.remarks,
  }) : super(key: key);
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return PageWrapper(
      showBackButton: true,
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
              NavigationService.push(
                target: CommonTransactionSuccessPage(
                  serviceName: service.service,
                  body: Column(
                    children: [
                      KeyValueTile(
                        title: "From",
                        value: busTopBarModel.sectorFrom,
                      ),
                      KeyValueTile(title: "To", value: busTopBarModel.sectorTo),
                      KeyValueTile(
                        title: "Date Time",
                        value:
                            selectedBusData["date"] +
                            "-" +
                            selectedBusData["departureTime"],
                      ),
                      KeyValueTile(
                        title: "Operator",
                        value: selectedBusData["operator"],
                      ),
                      KeyValueTile(
                        title: "Bus Type",
                        value: selectedBusData["busType"],
                      ),
                      KeyValueTile(
                        title: "Selected Seats",
                        value: selectedSeats.toString(),
                      ),
                      KeyValueTile(
                        title: "Total Amount",
                        value:
                            response
                                        .findValueString("totalAmount")
                                        .toString() ==
                                    "null"
                                ? totalFare.toString()
                                : response.findValueString("tottalAmount"),
                      ),
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
            BusTopBarLocationBox(busModel: busTopBarModel),
            SizedBox(height: _height * 0.01),
            const Divider(thickness: 1),
            SizedBox(height: _height * 0.01),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "From Account",
                      style: TextStyle(
                        fontFamily: Fonts.poppin,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: CustomTheme.lightTextColor,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CustomTheme.white,
                      ),
                      child: PrimaryAccountBox(),
                    ),
                    SizedBox(height: _height * 0.01),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CustomTheme.white,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trip Details",
                            style: _textTheme.titleSmall!.copyWith(
                              color: _theme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.hp),
                          LoanKeyValueTile(
                            title: "Operator",
                            value: selectedBusData["operator"],
                          ),
                          LoanKeyValueTile(
                            title: "Date(NP)",
                            value: selectedBusData["date"],
                          ),
                          LoanKeyValueTile(
                            title: "Boarding Point",
                            value: boardingPoint,
                          ),
                          LoanKeyValueTile(
                            title: "Bus Type",
                            value: selectedBusData["busType"],
                          ),
                          LoanKeyValueTile(
                            title: "Departure Time",
                            value: selectedBusData["departureTime"],
                          ),
                          LoanKeyValueTile(
                            title: "Selected Seat",
                            value: selectedSeats.toString(),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: CustomTheme.white,
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Contact Details",
                            style: _textTheme.titleSmall!.copyWith(
                              color: _theme.primaryColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.hp),
                          LoanKeyValueTile(
                            title: "Full Name",
                            value: contactDetail.fullName,
                          ),
                          LoanKeyValueTile(
                            title: "Email",
                            value: contactDetail.email,
                          ),
                          LoanKeyValueTile(
                            title: "Mobile Number",
                            value: contactDetail.phoneNumber,
                          ),
                          LoanKeyValueTile(title: "Remarks", value: remarks),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1.0),
              child: CustomRoundedButtom(
                title: "Pay",
                onPressed: () {
                  NavigationService.push(
                    target: TransactionPinScreen(
                      onValueCallback: (p0) {
                        NavigationService.pop();
                        context.read<UtilityPaymentCubit>().makePayment(
                          serviceIdentifier: service.uniqueIdentifier,
                          body: {
                            "accountNo":
                                RepositoryProvider.of<CustomerDetailRepository>(
                                  context,
                                ).selectedAccount.value!.accountNumber,
                            "amount":
                                response
                                            .findValueString("totalAmount")
                                            .toString() ==
                                        "null"
                                    ? totalFare.toString()
                                    : response.findValueString("totalAmount"),
                            "from": busTopBarModel.sectorFrom,
                            "to": busTopBarModel.sectorTo,
                            "ticketId": response.findValueString("ticketSrlNo"),
                            "busId": selectedBusData["id"],
                            "remarks": remarks,
                            "seats": selectedSeats.toString(),
                            "contactName": contactDetail.fullName,
                            "contactNumber": contactDetail.phoneNumber,
                            "contactEmail": contactDetail.email,
                            "boardingPoint": boardingPoint,
                            "bookingHashValue": response.findValueString(
                              "bookingHashValue",
                            ),
                            "tripHashCode": selectedBusData["tripHashcode"],
                          },
                          accountDetails: {},
                          apiEndpoint: "/api/busSewa/payment",
                          mPin: p0,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
