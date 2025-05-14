// import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/wrapper/nested_tab_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/screen/passenger_detail_page.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/common_navigation_bar.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/flight_amount_with_button_widget.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/flight_list_tab_widget.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/flutter_location_widget.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../../utility_payment/cubit/utility_payment_cubit.dart';

class AvailableFlightsListWidget extends StatefulWidget {
  const AvailableFlightsListWidget({
    Key? key,
    required this.useServiceResponse,
    required this.isTwoWay,
    required this.fromSector,
    required this.toSector,
    // required this.services,
    required this.outboundFlights,
    required this.inboundFlights,
    required this.serviceInfo,
    required this.adultCount,
    required this.childrenCount,
  }) : super(key: key);

  final SearchFlightResponse useServiceResponse;
  final bool isTwoWay;
  final KeyValue fromSector;
  final KeyValue toSector;

  final int adultCount;
  final int childrenCount;
  // final ServiceList services;

  final List<Flight> outboundFlights;
  final List<Flight> inboundFlights;

  final ServiceList serviceInfo;
  @override
  State<AvailableFlightsListWidget> createState() =>
      _AvailableFlightsListWidgetState();
}

class _AvailableFlightsListWidgetState extends State<AvailableFlightsListWidget>
    with SingleTickerProviderStateMixin {
  // FlightUtils? _flightUtils;
  int selectedOutboundIndex = -1;
  int selectedInboundIndex = -1;
  List<Flight> _outboundValues = [];
  List<Flight> _inboundValue = [];

  bool isRefundableFilterApplied = false;
  bool isTimeFilterApplied = false;
  bool isPriceFilterApplied = false;
  bool isAirlinesFilterApplied = false;

  bool isTimeSortApplied = false;
  bool isPriceSortApplied = false;

  double totalPrice = 0.00;
  String bookindId = "";
  late TabController _tabController;

  KeyValue? toSectorBackup;
  KeyValue? fromSectorBackup;
  calculateTotalPrice() {
    totalPrice = 0.00;
    if (selectedInboundIndex != -1) {
      final double fareTotalInbound =
          _inboundValue[selectedInboundIndex].totalFare;
      totalPrice += fareTotalInbound;
    }

    if (selectedOutboundIndex != -1) {
      final double fareTotalInbound =
          _outboundValues[selectedOutboundIndex].totalFare;
      totalPrice += fareTotalInbound;
    }
  }

  List<String> _items = [];
  final ValueNotifier<int> _currentIndex = ValueNotifier(0);

  // final int _leastPrice = 0;
  // final int _highestPrice = 0;
  @override
  void initState() {
    super.initState();

    // _flightUtils = FlightUtils(
    //   inboundFlight: widget.inboundFlights,
    //   outBoundFlight: widget.outboundFlights,
    // );

    widget.isTwoWay ? _items = ["Departure", "Return"] : _items = ["Departure"];

    _outboundValues = widget.outboundFlights;
    _inboundValue = widget.inboundFlights;

    // _outboundValues.shuffle();
    // _inboundValue.shuffle();

    toSectorBackup = widget.toSector;
    fromSectorBackup = widget.fromSector;

    // _leastPrice = widget.outboundFlights
    //     .reduce((a, b) => a.fareTotal < b.fareTotal ? a : b)
    //     .fareTotal;
    // _highestPrice = widget.outboundFlights
    //     .reduce((a, b) => a.fareTotal > b.fareTotal ? a : b)
    //     .fareTotal;

    // print("$_leastPrice");
    // bookindId = widget.useServiceResponse.findValueString("booking_id");

    _tabController = TabController(length: _items.length, vsync: this)
      ..addListener(() {
        if (_tabController.index != _currentIndex.value) {
          _currentIndex.value = _tabController.index;
        }
      });

    // _outboundValues.forEach(
    //   (element) {
    //     if (!_airlinesList.contains(element))
    //       _airlinesList.add(element.airlineName);
    //   },
    // );

    // _inboundValue.forEach(
    //   (element) {
    //     if (!_airlinesList.contains(element))
    //       _airlinesList.add(element.airlineName);
    //   },
    // );
  }

  // final _airlinesList = <String>{};

  // onResetFilterCallback() {
  //   isTimeFilterApplied = false;
  //   isAirlinesFilterApplied = false;
  //   isPriceFilterApplied = false;
  //   isTimeSortApplied = false;
  //   isPriceSortApplied = false;

  //   _outboundValues = _flightUtils!.backupOutboundFlights;
  //   _inboundValue = _flightUtils!.backupInboundFlights;

  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;

  //   _flightUtils!.resetFilter([]);
  //   setState(() {});
  // }

  // onFilterCallback(RangeValues? priceRange, RangeValues? timeRange,
  //     Set<String> selectedAirlines) {
  //   List<Flight> _tempOutboundValues = _flightUtils!.backupOutboundFlights;
  //   List<Flight> _tempInboundValues = _flightUtils!.backupInboundFlights;
  //   List<Flight> _filteredOutboundValues = _flightUtils!.backupOutboundFlights;
  //   List<Flight> _filteredInboundValues = _flightUtils!.backupInboundFlights;

  //   if (priceRange != null ||
  //       timeRange != null ||
  //       selectedAirlines.isNotEmpty) {
  //     selectedOutboundIndex = -1;
  //     selectedInboundIndex = -1;

  //     _flightUtils!.appliedAirlinesFilter = {};
  //     if (selectedAirlines.isNotEmpty) {
  //       _filteredOutboundValues = _flightUtils!
  //           .applyAirlinesFilter(selectedAirlines, _filteredOutboundValues);
  //       _filteredInboundValues = _flightUtils!
  //           .applyAirlinesFilter(selectedAirlines, _filteredInboundValues);
  //       isAirlinesFilterApplied = true;
  //     }

  //     if (priceRange != null) {
  //       _filteredOutboundValues =
  //           _flightUtils!.applyPriceFilter(priceRange, _filteredOutboundValues);

  //       _filteredInboundValues =
  //           _flightUtils!.applyPriceFilter(priceRange, _filteredInboundValues);

  //       isPriceFilterApplied = true;
  //     }
  //     if (timeRange != null) {
  //       _filteredOutboundValues = _flightUtils!
  //           .applyTimeRangeFilter(timeRange, _filteredOutboundValues);

  //       _filteredInboundValues = _flightUtils!
  //           .applyTimeRangeFilter(timeRange, _filteredInboundValues);

  //       isTimeFilterApplied = true;
  //     }
  //     if (isTimeSortApplied) applyTimeSort();

  //     _outboundValues = _filteredOutboundValues;
  //     _inboundValue = _filteredInboundValues;
  //   } else {
  //     isTimeFilterApplied = false;
  //     isPriceFilterApplied = false;
  //     isAirlinesFilterApplied = false;
  //     _outboundValues = _tempOutboundValues;
  //     _inboundValue = _tempInboundValues;
  //   }

  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;
  //   setState(() {});
  // }

  // applyAirlinesFilter(
  //   Set<String> selectedValues,
  //   List<Flight> _tempOutboundValues,
  //   List<Flight> _tempInboundValues,
  // ) {
  //   _inboundValue = _flightUtils!.applyAirlinesFilter(
  //     selectedValues,
  //     isAirlinesFilterApplied ? _tempInboundValues : _inboundValue,
  //   );
  //   _outboundValues = _flightUtils!.applyAirlinesFilter(
  //     selectedValues,
  //     isAirlinesFilterApplied ? _tempOutboundValues : _outboundValues,
  //   );

  //   isAirlinesFilterApplied = true;
  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;
  // }

  // applyPriceFilter(RangeValues priceRange) {
  //   _outboundValues =
  //       _flightUtils!.applyPriceFilter(priceRange, _outboundValues);
  //   _inboundValue = _flightUtils!.applyPriceFilter(priceRange, _inboundValue);

  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;
  // }

  // applyRefundableFilter(bool value) {
  //   if (value) {
  //     _outboundValues =
  //         _flightUtils!.applyRefundableFilter(_outboundValues, value);
  //     _inboundValue = _flightUtils!.applyRefundableFilter(_inboundValue, value);
  //   } else {
  //     if (isRefundableFilterApplied) {
  //       onFilterCallback(
  //         _flightUtils!.appliedPriceFilter,
  //         _flightUtils!.appliedTimeRangeFilter,
  //         _flightUtils!.appliedAirlinesFilter ?? {},
  //       );
  //     } else {
  //       _outboundValues = _flightUtils!.backupOutboundFlights;
  //       _inboundValue = _flightUtils!.inboundFlight;
  //     }
  //   }

  //   isRefundableFilterApplied = value;
  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;
  // }

  // applyTimeSort() {
  //   if (!isTimeSortApplied) {
  //     _outboundValues = _flightUtils!.sortFlightsByTime(_outboundValues);
  //     _inboundValue = _flightUtils!.sortFlightsByTime(_inboundValue);
  //   } else {
  //     _outboundValues.shuffle();
  //     _inboundValue.shuffle();
  //   }

  //   isTimeSortApplied = !isTimeSortApplied;
  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;
  //   setState(() {});
  // }

  // applyPriceSort() {
  //   if (!isPriceSortApplied) {
  //     _outboundValues = _flightUtils!.sortFlightsByPrice(_outboundValues);
  //     _inboundValue = _flightUtils!.sortFlightsByPrice(_inboundValue);
  //   } else {
  //     _outboundValues.shuffle();
  //     _inboundValue.shuffle();
  //   }
  //   isPriceSortApplied = !isPriceSortApplied;
  //   selectedInboundIndex = -1;
  //   selectedOutboundIndex = -1;
  //   setState(() {});
  // }
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;

    return PageWrapper(
      // TODOFilter add
      // appActions: [
      //   IconButton(
      //     icon: const Icon(Icons.search),
      //     onPressed: () {
      //       NavigationService.push(
      //         target: AvailableFlightsFilterWidget(
      //           leastTicketPrice: _leastPrice,
      //           maxTicketPrice: _highestPrice,
      //           onApplyCallback: onFilterCallback,
      //           airlinesList: _airlinesList.toList(),
      //           onResetFilterCallback: onResetFilterCallback,
      //           selectedAirlines: _flightUtils!.appliedAirlinesFilter ?? {},
      //           selectedPriceRange: _flightUtils!.appliedPriceFilter,
      //           selectedTimeRange: _flightUtils!.appliedTimeRangeFilter,
      //         ),
      //       );
      //     },
      //   ),
      // ],
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
            if (_response.code == "M0000" ||
                _response.status.toLowerCase() == "Success".toLowerCase()) {
              NavigationService.push(
                target: PassengerDetailScreen(
                  isTwoWay: widget.isTwoWay,
                  airlineID: _response.findValueString("airlineId").toString(),
                  utilityResponseData: _response,
                  arrivalFlight:
                      widget.isTwoWay
                          ? _inboundValue[selectedInboundIndex]
                          : null,
                  totalFare: totalPrice,
                  service: widget.serviceInfo,
                  adultCount: widget.adultCount,
                  childrenCount: widget.childrenCount,
                  departureFlight: _outboundValues[selectedOutboundIndex],
                ),
              );
            } else {
              showPopUpDialog(
                context: context,
                message: _response.message,
                title: "Message",
                buttonCallback: () {
                  NavigationService.pop();
                },
                showCancelButton: false,
              );
            }
          } else {
            print("state is " + state.toString());
          }
        },
        child: Stack(
          children: [
            NestedScrollView(
              physics: const NeverScrollableScrollPhysics(),
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: MultiSliver(
                      children: [
                        SliverToBoxAdapter(
                          child: Container(
                            width: _width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.hp),
                              color: Colors.white,
                            ),
                            padding: EdgeInsets.all(15.hp),
                            margin: const EdgeInsets.symmetric(
                              horizontal: CustomTheme.symmetricHozPadding,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FlightLocationWidget(
                                  iconData: Icons.flight_takeoff,
                                  locationSlug: fromSectorBackup!.value,
                                  locationName: fromSectorBackup!.title,
                                ),
                                FlightLocationWidget(
                                  iconData: Icons.flight_land,
                                  locationSlug: toSectorBackup!.value,
                                  locationName: toSectorBackup!.title,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: SizedBox(height: 15.hp)),

                        // SliverToBoxAdapter(
                        //   child: Container(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: CustomTheme.symmetricHozPadding,
                        //     ),
                        //     child: Row(
                        //       children: [
                        //         Icon(
                        //           PaywellIcons.calendar,
                        //           color: _theme.primaryColor,
                        //         ),
                        //         if (_flightUtils!
                        //             .backupOutboundFlights.isNotEmpty)
                        //           Text(
                        //             "${_flightUtils!.backupOutboundFlights.first.flightDate}",
                        //           ),
                        //         if (_flightUtils!
                        //             .backupInboundFlights.isNotEmpty)
                        //           Text(
                        //             " - ${_flightUtils!.backupInboundFlights.first.flightDate}",
                        //           ),
                        //         SizedBox(
                        //           width: 10.hp,
                        //         ),
                        //         Icon(
                        //           PaywellIcons.user,
                        //           color: _theme.primaryColor,
                        //         ),
                        //         if (_flightUtils!
                        //             .backupOutboundFlights.isNotEmpty)
                        //           Text(
                        //             "${_flightUtils!.backupOutboundFlights.first.adult} Adults ${_flightUtils!.backupOutboundFlights.first.child} Childrens",
                        //           ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        if (widget.isTwoWay)
                          SliverToBoxAdapter(
                            child: CommonNavigationBar(
                              selectedIndex: _currentIndex,
                              borderRadius: 100,
                              onChanged: (index) {
                                _tabController.animateTo(index);
                              },
                              margin: EdgeInsets.only(
                                left: CustomTheme.symmetricHozPadding,
                                right: CustomTheme.symmetricHozPadding,
                                bottom: 20.hp,
                              ),
                              items: _items,
                            ),
                          ),

                        // SliverToBoxAdapter(
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //       horizontal: CustomTheme.symmetricHozPadding,
                        //     ),
                        //     child: DottedBorder(
                        //       child: Container(
                        //         width: _width,
                        //         padding: EdgeInsets.symmetric(
                        //           horizontal: 10.hp,
                        //         ),
                        //         child: Row(
                        //           mainAxisAlignment:
                        //               MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Row(
                        //               children: [
                        //                 FlightsFilterWidget(
                        //                   isFilterApplied:
                        //                       isTimeFilterApplied ||
                        //                           isTimeSortApplied,
                        //                   filterTitle: context.loc.flight.time,
                        //                   filterIcon: PaywellIcons.filter,
                        //                   onClickFilterCallback: applyTimeSort,
                        //                 ),
                        //                 SizedBox(
                        //                   width: 5.hp,
                        //                 ),
                        //                 FlightsFilterWidget(
                        //                   isFilterApplied:
                        //                       isPriceFilterApplied ||
                        //                           isPriceSortApplied,
                        //                   filterTitle: context.loc.flight.price,
                        //                   filterIcon: PaywellIcons.filter,
                        //                   onClickFilterCallback: applyPriceSort,
                        //                 ),
                        //               ],
                        //             ),
                        //             Row(
                        //               children: [
                        //                 Text(
                        //                   context.loc.flight.refundableOnly,
                        //                   style:
                        //                       _textTheme.titleSmall!.copyWith(
                        //                     color: CustomTheme.midGrayColor,
                        //                     fontWeight: FontWeight.normal,
                        //                   ),
                        //                 ),
                        //                 Switch(
                        //                   value: isRefundableFilterApplied,
                        //                   activeColor: _theme.primaryColor,
                        //                   onChanged: (val) {
                        //                     // isRefundableFilterApplied = val;
                        //                     applyRefundableFilter(val);
                        //                     setState(() {});
                        //                   },
                        //                 ),
                        //               ],
                        //             )
                        //           ],
                        //         ),
                        //       ),
                        //       radius: Radius.circular(20.hp),
                        //       borderType: BorderType.RRect,
                        //     ),
                        //   ),
                        // ),
                        SliverToBoxAdapter(child: SizedBox(height: 20.hp)),
                      ],
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: _tabController,
                children: [
                  NestedTabWrapper(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.zero,
                        sliver:
                            _outboundValues.isNotEmpty
                                ? FlightListTabWidget(
                                  selectedIndex: selectedOutboundIndex,
                                  calculateTotalPrice: calculateTotalPrice,
                                  onSelectionChanged: (val) {
                                    selectedOutboundIndex = val;
                                    setState(() {});
                                  },
                                  extraCallback: () {
                                    if (selectedInboundIndex == -1 &&
                                        widget.isTwoWay) {
                                      _tabController.animateTo(1);
                                    }
                                  },
                                  flightList: _outboundValues,
                                  serviceInfo: widget.serviceInfo,
                                )
                                : SliverToBoxAdapter(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          CustomTheme.symmetricHozPadding,
                                    ),
                                    child: Text(
                                      "No flight found.",
                                      style: _textTheme.titleLarge,
                                    ),
                                  ),
                                ),
                      ),
                    ],
                  ),
                  if (widget.isTwoWay)
                    NestedTabWrapper(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.zero,
                          sliver:
                              _inboundValue.isNotEmpty
                                  ? FlightListTabWidget(
                                    selectedIndex: selectedInboundIndex,
                                    calculateTotalPrice: calculateTotalPrice,
                                    onSelectionChanged: (val) {
                                      selectedInboundIndex = val;
                                      setState(() {});
                                    },
                                    flightList: _inboundValue,
                                    extraCallback: () {},
                                    serviceInfo: widget.serviceInfo,
                                  )
                                  : SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            CustomTheme.symmetricHozPadding,
                                      ),
                                      child: Text(
                                        "No flights found.",
                                        style: _textTheme.titleLarge,
                                      ),
                                    ),
                                  ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                child:
                    selectedOutboundIndex != -1
                        ? FlightAmountWidgetWithButton(
                          onButtonPress: () {
                            context.read<UtilityPaymentCubit>().makePayment(
                              serviceIdentifier: "ARS",
                              accountDetails: {},
                              body: {
                                "flightId":
                                    _outboundValues[selectedOutboundIndex]
                                        .flightId,
                                "returnFlightId":
                                    selectedInboundIndex.isNegative
                                        ? ""
                                        : _inboundValue[selectedInboundIndex]
                                            .flightId,
                                "amount": totalPrice,
                              },
                              apiEndpoint: "/api/arsflightreservation",
                              mPin: "",
                            );
                          },
                          adultCount: widget.adultCount,
                          childrenCount: widget.childrenCount,
                          outBoundValues: _outboundValues,
                          inBoundValues: _inboundValue,
                          selectedInboundIndex: selectedInboundIndex,
                          selectedOutboundIndex: selectedOutboundIndex,
                          isTwoWay: widget.isTwoWay,
                          services: widget.serviceInfo,
                          currentIndexNotifier: _currentIndex,
                          bookingId: bookindId,
                          totalPrice: totalPrice,
                        )
                        : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
