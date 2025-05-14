import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/screen/bus_passenger_detail_page.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_price_box_widget.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class BusSeatsListWidget extends StatefulWidget {
  final BusTopBarModel busModel;

  final ServiceList services;
  final List seatLayout;
  final columnNumber;
  final List<dynamic> busList;
  final int index;
  const BusSeatsListWidget({
    Key? key,
    required this.seatLayout,
    required this.columnNumber,
    required this.busList,
    required this.index,
    required this.services,
    required this.busModel,
  }) : super(key: key);

  @override
  State<BusSeatsListWidget> createState() => _BusSeatsListWidgetState();
}

class _BusSeatsListWidgetState extends State<BusSeatsListWidget> {
  getColor(index) {
    return widget.seatLayout[index]["bookingStatus"].toString().toLowerCase() !=
            "no"
        ? CustomTheme.darkGray.withOpacity(0.5)
        : CustomTheme.green;
  }

  bool _isLoading = false;
  final List<dynamic> selectedSeats = [];
  double? totalPrice;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      padding: EdgeInsets.zero,
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
                target: BusPassengerDetailPage(
                  selectedSeats: selectedSeats,
                  selectedBusData: widget.busList[widget.index],
                  service: widget.services,
                  totalFare: totalPrice ?? 0,
                  response: _response,
                  busModel: widget.busModel,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CustomTheme.symmetricHozPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BusTopBarLocationBox(busModel: widget.busModel),
                    SizedBox(height: 10.hp),
                    Text(
                      widget.busList[widget.index]["operator"],
                      style: _textTheme.titleLarge!.copyWith(
                        color: _theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.busList[widget.index]["busType"]} - ${widget.busList[widget.index]["departureTime"]}",
                      style: _textTheme.titleSmall,
                    ),
                    const Divider(thickness: 1),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.busSeatIcon,
                                height: 20.hp,
                                color: CustomTheme.green,
                              ),
                              SizedBox(width: 10.wp),
                              Text(
                                "Avaliable",
                                style: _textTheme.titleSmall!.copyWith(
                                  color: CustomTheme.green,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.busSeatIcon,
                                height: 20.hp,
                                color: CustomTheme.googleColor,
                              ),
                              SizedBox(width: 10.wp),
                              Text(
                                "Selected",
                                style: _textTheme.titleSmall!.copyWith(
                                  color: CustomTheme.googleColor,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                Assets.busSeatIcon,
                                height: 20.hp,
                                color: CustomTheme.darkGray.withOpacity(0.5),
                              ),
                              SizedBox(width: 10.wp),
                              Text(
                                "Booked",
                                style: _textTheme.titleSmall!.copyWith(
                                  color: CustomTheme.darkGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(thickness: 1),

                    Text("FRONT", style: _textTheme.titleLarge),
                    // Container(
                    //   height: 120,
                    //   child: ListView.builder(
                    //     itemCount: selectedSeats.length,
                    //     itemBuilder: (context, index) {
                    //       return Text(selectedSeats[index]);
                    //     },
                    //   ),
                    // ),
                    Expanded(
                      child: GridView.builder(
                        itemCount: widget.seatLayout.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widget.columnNumber,
                        ),
                        itemBuilder: (context, index) {
                          final isSelected = selectedSeats.contains(
                            widget.seatLayout[index]["displayName"],
                          );
                          return widget.seatLayout[index]["displayName"]
                                      .toString() !=
                                  "na"
                              ? InkWell(
                                onTap: () {
                                  if (widget.seatLayout[index]["bookingStatus"]
                                          .toString()
                                          .toLowerCase() ==
                                      "no")
                                    setState(() {
                                      if (isSelected) {
                                        selectedSeats.remove(
                                          widget
                                              .seatLayout[index]["displayName"],
                                        );
                                      } else {
                                        selectedSeats.add(
                                          widget
                                              .seatLayout[index]["displayName"],
                                        );
                                      }
                                      totalPrice =
                                          widget.busList[widget
                                              .index]["ticketPrice"] *
                                          selectedSeats.length;
                                    });
                                },
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SvgPicture.asset(
                                      Assets.busSeatIcon,
                                      height: 20.hp,
                                      color:
                                          isSelected
                                              ? CustomTheme.googleColor
                                              : getColor(index),
                                    ),
                                    Text(
                                      widget.seatLayout[index]["displayName"],
                                      style: _textTheme.titleSmall!.copyWith(
                                        color:
                                            isSelected
                                                ? CustomTheme.googleColor
                                                : getColor(index),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                              : Container();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BusPriceBoxWidget(
              onPress: () {
                context.read<UtilityPaymentCubit>().makePayment(
                  serviceIdentifier: widget.services.uniqueIdentifier,
                  accountDetails: {"amount": totalPrice},
                  body: {
                    "seats": selectedSeats,
                    "busId": widget.busList[widget.index]["id"],
                  },
                  apiEndpoint: "/api/busSewa/booking",
                  mPin: "",
                );
              },
              totalPrice: totalPrice ?? 0,
              ticketPrice: widget.busList[widget.index]["ticketPrice"],
              selectedSeatCount: selectedSeats.length,
            ),
          ],
        ),
      ),
    );
  }
}
