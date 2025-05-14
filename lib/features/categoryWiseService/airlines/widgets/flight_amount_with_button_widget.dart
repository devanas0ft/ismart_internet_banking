import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/flight_amount_column_widget.dart';

class FlightAmountWidgetWithButton extends StatelessWidget {
  const FlightAmountWidgetWithButton({
    Key? key,
    required this.outBoundValues,
    required this.inBoundValues,
    required this.selectedInboundIndex,
    required this.selectedOutboundIndex,
    required this.isTwoWay,
    required this.services,
    required this.currentIndexNotifier,
    required this.bookingId,
    required this.totalPrice,
    required this.adultCount,
    required this.childrenCount,
    required this.onButtonPress,
  }) : super(key: key);
  final List<Flight> outBoundValues;
  final Function onButtonPress;
  final List<Flight> inBoundValues;
  final int selectedInboundIndex;
  final int selectedOutboundIndex;
  final bool isTwoWay;
  final int adultCount;
  final int childrenCount;
  final ValueNotifier<int> currentIndexNotifier;
  final String bookingId;
  final double totalPrice;
  final ServiceList services;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.hp, vertical: 30.hp),
      child: Column(
        children: [
          Row(
            children: [
              FlightAmountDetailsColumnWidget(
                title: "Departure",
                price:
                    outBoundValues[selectedOutboundIndex].totalFare.toString(),
                cashBack:
                    outBoundValues[selectedOutboundIndex].cashBack.toString(),
              ),
              SizedBox(width: 10.hp),
              if (selectedInboundIndex != -1)
                FlightAmountDetailsColumnWidget(
                  title: "Return",
                  price:
                      inBoundValues[selectedInboundIndex].totalFare.toString(),
                  cashBack:
                      inBoundValues[selectedInboundIndex].cashBack == null
                          ? "0.00"
                          : inBoundValues[selectedInboundIndex].cashBack
                              .toString(),
                ),
              Container(
                height: 30.hp,
                child: VerticalDivider(
                  color: CustomTheme.darkGray,
                  thickness: 2.hp,
                  width: 20.hp,
                ),
              ),
              FlightAmountDetailsColumnWidget(
                title: "Total",
                price: "$totalPrice",
                cashBack: "0.00",
              ),
              SizedBox(width: 20.hp),
              Expanded(
                child: Container(
                  height: 45.hp,
                  child: CustomRoundedButtom(
                    // verificationAmount: totalPrice.toString(),
                    padding: EdgeInsets.zero,
                    title: "Book",
                    onPressed: () {
                      if (isTwoWay && selectedInboundIndex == -1) {
                        currentIndexNotifier.value = 1;
                        // setState(() {});
                      } else {
                        onButtonPress();
                        //   context.read<UtilityPaymentCubit>().makePayment(
                        //       serviceIdentifier: "ARS",
                        //       accountDetails: {},
                        //       body: {
                        //         "flightId":
                        //             outBoundValues[selectedOutboundIndex]
                        //                 .flightId,
                        //         "returnFlightId":
                        //             selectedInboundIndex.isNegative
                        //                 ? ""
                        //                 : inBoundValues[selectedInboundIndex]
                        //                     .flightId,
                        //         "amount": totalPrice,
                        //       },
                        //       apiEndpoint: "/api/arsflightreservation",
                        //       mPin: "");
                      }
                    },
                    textColor: _theme.primaryColor,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15.hp),
        ],
      ),
      // ),
    );
  }
}
