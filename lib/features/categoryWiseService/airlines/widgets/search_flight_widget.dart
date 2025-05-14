import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/cubit/airlines_cubit.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/screen/available_flight_screen.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/location_list_widget.dart';

class SearchFlightWidget extends StatefulWidget {
  final ServiceList service;

  const SearchFlightWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<SearchFlightWidget> createState() => _SearchFlightWidgetState();
}

class _SearchFlightWidgetState extends State<SearchFlightWidget> {
  int _adultCount = 1;
  int _childrenCount = 0;
  // AirlinesSectorList fromPlace = AirlinesSectorList();
  // AirlinesSectorList toPlace = AirlinesSectorList();
  final TextEditingController tripTypeController = TextEditingController();

  final _departureDateController = TextEditingController();
  final _arrivalDateController = TextEditingController();
  bool isRoundTrip = false;
  bool _isLoading = false;
  DateTime departureDate = DateTime.now();

  final ValueNotifier<KeyValue?> _selectedSectorFrom = ValueNotifier(null);
  final ValueNotifier<KeyValue?> _selectedSectorTo = ValueNotifier(null);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return PageWrapper(
      body: CommonContainer(
        serviceCategoryId: widget.service.categoryId.toString(),
        showRecentTransaction: true,
        showTitleText: false,
        showDetail: false,
        topbarName: 'Book Flight',
        buttonName: 'Search Flight',
        body: BlocListener<AirlinesCubit, CommonState>(
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

            if (state is CommonStateSuccess<SearchFlightResponse>) {
              final SearchFlightResponse _response = state.data;

              if (_response.responseStatus.toLowerCase() ==
                  "Success".toLowerCase()) {
                print("this is the adata ${_response}");
                NavigationService.push(
                  target: AvailableFlightPage(
                    fromSector: KeyValue(
                      title: _selectedSectorFrom.value?.title ?? "",
                      value: _selectedSectorFrom.value?.value ?? "",
                    ),
                    toSector: KeyValue(
                      title: _selectedSectorTo.value?.title ?? "",
                      value: _selectedSectorTo.value?.value ?? "",
                    ),
                    service: widget.service,
                    adultCount: _adultCount,
                    childrenCount: _childrenCount,
                    flightDetail: _response,
                    isTwoWay: isRoundTrip,
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
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: CustomTheme.lightGray,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          NavigationService.push(
                            target: FlightsSearchPage(
                              onChanged: (value) {
                                _selectedSectorFrom.value = value;
                              },
                              selectedValue: _selectedSectorFrom.value,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('From', style: _textTheme.headlineSmall),
                            ValueListenableBuilder<KeyValue?>(
                              valueListenable: _selectedSectorFrom,
                              builder: (context, val, child) {
                                return Text(
                                  val != null ? val.title : 'Select',
                                  style: _textTheme.headlineMedium!.copyWith(
                                    fontSize: 14,
                                    color: CustomTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SvgPicture.asset(
                          'assets/icons/airplane.svg',
                          height: 30,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigationService.push(
                            target: FlightsSearchPage(
                              onChanged: (value) {
                                _selectedSectorTo.value = value;
                              },
                              selectedValue: _selectedSectorTo.value,
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('To', style: _textTheme.headlineSmall),
                            ValueListenableBuilder<KeyValue?>(
                              valueListenable: _selectedSectorTo,
                              builder: (context, val, child) {
                                return Text(
                                  val != null ? val.title : 'Select',
                                  style: _textTheme.headlineMedium!.copyWith(
                                    fontSize: 14,
                                    color: CustomTheme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller:
                      tripTypeController
                        ..text = isRoundTrip ? "Round Trip" : "Single Trip",
                  title: 'Flight Mode',
                  readOnly: true,
                  suffixIcon: Icons.abc,
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        isRoundTrip = !isRoundTrip;
                      });
                    },
                    icon: const Icon(Icons.swap_vert_circle_outlined, size: 40),
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  title: 'Departure Date',
                  hintText: "Select Date",
                  controller: _departureDateController,
                  validator:
                      (value) => FormValidator.validateFieldNotEmpty(
                        value,
                        'Departure Date',
                      ),
                  readOnly: true,
                  onTap: () async {
                    final DateTime? date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 90)),
                    );
                    setState(() {
                      departureDate = date ?? DateTime.now();
                      _departureDateController.text =
                          "${date!.day}-${date.month}-${date.year}";
                    });
                  },
                  suffixIcon: Icons.calendar_month_rounded,
                  showSearchIcon: true,
                ),
                isRoundTrip
                    ? CustomTextField(
                      title: 'Arrival Date',
                      hintText: "Select Date",
                      controller: _arrivalDateController,
                      validator:
                          (value) => FormValidator.validateFieldNotEmpty(
                            value,
                            'Arrival Date',
                          ),
                      readOnly: true,
                      onTap: () async {
                        final DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: departureDate,
                          firstDate: departureDate,
                          lastDate: DateTime.now().add(
                            const Duration(days: 90),
                          ),
                        );
                        setState(() {
                          _arrivalDateController.text =
                              "${date!.day}-${date.month}-${date.year}";
                        });
                      },
                      suffixIcon: Icons.calendar_month_rounded,
                      showSearchIcon: true,
                    )
                    : Container(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Adult', style: _textTheme.titleLarge),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomTheme.darkGray),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomTheme.lightGray,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_adultCount > 1) {
                                        _adultCount--;
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                _adultCount.toString(),
                                style: _textTheme.headlineSmall!.copyWith(),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _adultCount++;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: CustomTheme.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Children', style: _textTheme.titleLarge),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: CustomTheme.darkGray),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomTheme.lightGray,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_childrenCount > 0) {
                                        _childrenCount--;
                                      }
                                    });
                                  },
                                  icon: const Icon(Icons.remove),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                _childrenCount.toString(),
                                style: _textTheme.headlineSmall!.copyWith(),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: CustomTheme.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _childrenCount++;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: CustomTheme.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        onButtonPressed: () {
          if (_selectedSectorFrom.value != null &&
              _selectedSectorTo.value != null &&
              _formKey.currentState!.validate()) {
            context.read<AirlinesCubit>().fetchFlight(
              accountDetails: {},
              body: {
                "adultNumber": _adultCount,
                "childNumber": _childrenCount,
                "flightDate": _departureDateController.text,
                "nationality": "NP",
                "returnDate": _arrivalDateController.text,
                "sectorFrom": _selectedSectorFrom.value?.value ?? "",
                "sectorTo": _selectedSectorTo.value?.value ?? "",
                "serviceIdentifier": widget.service.uniqueIdentifier,
                "tripType": isRoundTrip ? "R" : "O",
              },
            );
          } else if (_selectedSectorFrom.value == null &&
              _selectedSectorTo.value == null) {
            showPopUpDialog(
              context: context,
              message: "Select Sector",
              title: "Select Location",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
          // context.read<AirlinesCubit>().fetchFlight(accountDetails: {}, body: {
          //   "sectorFrom": "KTM",
          //   "sectorTo": "PKR",
          //   "adultNumber": _adultCount,
          //   "childNumber": _childrenCount,
          //   "flightDate": "20-09-2023",
          //   "returnDate": "20-10-2023",
          //   "tripType": "R",
          //   "nationality": "NP"
          // });
          // }
        },
      ),
    );
  }
}
