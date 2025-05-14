import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/airlines_detail_bottomsheet.dart';

class FlightDetailsListItemWidget extends StatefulWidget {
  const FlightDetailsListItemWidget({
    Key? key,
    required this.flight,
    required this.isSelected,
    required this.isAboveSelection,
    required this.serviceInfo,
  }) : super(key: key);
  final bool isSelected;
  final bool isAboveSelection;

  final Flight flight;
  final ServiceList serviceInfo;

  @override
  State<FlightDetailsListItemWidget> createState() =>
      _FlightDetailsListItemWidgetState();
}

class _FlightDetailsListItemWidgetState
    extends State<FlightDetailsListItemWidget> {
  // final double _cashbackAmount = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    // _cashbackAmount =
    // widget.serviceInfo.calculateCashback(widget.flight.fareTotal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    return Container(
      width: _width,
      decoration: BoxDecoration(
        color: widget.isSelected ? _theme.primaryColor.withOpacity(0.15) : null,
        borderRadius: BorderRadius.circular(20.hp),
      ),
      padding: widget.isSelected ? EdgeInsets.all(15.hp) : EdgeInsets.zero,
      // margin: EdgeInsets.only(bottom: 15.hp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomCachedNetworkImage(
                url:
                    RepositoryProvider.of<CoOperative>(context).baseUrl +
                    widget.flight.airlineLogo,
                height: 40,
                width: 40,
                fit: BoxFit.fill,
              ),
              SizedBox(width: 15.hp),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.flight.airline,
                              style: _textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 5.hp),
                            Text(
                              widget.flight.flightNo,
                              style: _textTheme.titleSmall!.copyWith(
                                color: CustomTheme.darkGray,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.flight.currency +
                              " " +
                              widget.flight.totalFare.toString(),
                          style: _textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.hp),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              widget.flight.departureTime,
                              style: _textTheme.titleSmall!.copyWith(
                                color: CustomTheme.darkGray,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.hp),
                              child: Icon(
                                Icons.flight_takeoff,
                                color: _theme.primaryColor,
                              ),
                            ),
                            Text(
                              widget.flight.arrivalTime,
                              style: _textTheme.titleSmall!.copyWith(
                                color: CustomTheme.darkGray,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color:
                                widget.isSelected
                                    ? Colors.white
                                    : _theme.primaryColor,
                            borderRadius: BorderRadius.circular(10.hp),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.hp,
                            vertical: 3.hp,
                          ),
                          child: Text(
                            "Cashback: ${widget.flight.cashBack}",
                            style: _textTheme.titleMedium!.copyWith(
                              color:
                                  widget.isSelected
                                      ? _theme.primaryColor
                                      : Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.hp),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 2.5,
                              backgroundColor: _theme.primaryColor,
                            ),
                            SizedBox(width: 3.hp),
                            Text(
                              "Class " + widget.flight.flightClassCode,
                              style: _textTheme.titleMedium!.copyWith(
                                color: CustomTheme.darkGray,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 5.hp),
                            CircleAvatar(
                              radius: 2.5,
                              backgroundColor: _theme.primaryColor,
                            ),
                            SizedBox(width: 3.hp),
                            Text(
                              widget.flight.airline,
                              style: _textTheme.titleMedium!.copyWith(
                                color: CustomTheme.darkGray,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.flight.refundable
                              ? "Refundable"
                              : "Non-refundable",
                          style: _textTheme.titleMedium!.copyWith(
                            color:
                                widget.flight.refundable
                                    ? CustomTheme.green
                                    : Colors.red,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.hp),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 2.5,
                              backgroundColor: _theme.primaryColor,
                            ),
                            SizedBox(width: 3.hp),
                            Text(
                              widget.flight.freeBaggage,
                              style: _textTheme.titleMedium!.copyWith(
                                color: CustomTheme.darkGray,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                              ),
                              context: context,
                              builder: (context) {
                                return AirlinesDetailBottomSheet(
                                  flight: widget.flight,
                                );
                              },
                            );
                          },
                          child: Text(
                            "Fare Summary",
                            style: _textTheme.titleSmall!.copyWith(
                              decoration: TextDecoration.underline,
                              color: _theme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
