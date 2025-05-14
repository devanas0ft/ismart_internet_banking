import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/models/key_value.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/screen/available_bus_page.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_location_widget.dart';
import 'package:ismart_web/features/categoryWiseService/busBooking/widget/bus_topbar_location_box.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class BusBookingWidget extends StatefulWidget {
  final ServiceList service;

  const BusBookingWidget({Key? key, required this.service}) : super(key: key);

  @override
  State<BusBookingWidget> createState() => _BusBookingWidgetState();
}

class _BusBookingWidgetState extends State<BusBookingWidget> {
  final _departureDateController = TextEditingController();
  bool _isLoading = false;
  DateTime departureDate = DateTime.now();

  final ValueNotifier<KeyValue?> _selectedSectorFrom = ValueNotifier(null);
  final ValueNotifier<KeyValue?> _selectedSectorTo = ValueNotifier(null);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List tripType = ["Day", "Night", "Both"];
  int selectedIndex = 0;
  String? selectedShift;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;

    return PageWrapper(
      body: CommonContainer(
        showDetail: true,
        title: widget.service.service,
        detail: widget.service.instructions,
        topbarName: widget.service.serviceCategoryName,
        buttonName: 'Search Bus',
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
              final _response = state.data;
              if (_response.status.toLowerCase() == "Success".toLowerCase()) {
                NavigationService.push(
                  target: AvailableBusPage(
                    response: _response,
                    service: widget.service,
                    busModel: BusTopBarModel(
                      sectorFrom: _selectedSectorFrom.value?.value ?? "",
                      sectorTo: _selectedSectorTo.value?.value ?? "",
                      selectedDate:
                          "${departureDate.year}-${departureDate.month}-${departureDate.day}",
                    ),
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
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            NavigationService.push(
                              target: BusLocationWidget(
                                onChanged: (value) {
                                  _selectedSectorFrom.value = value;
                                },
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
                      ),
                      Expanded(
                        child: SvgPicture.asset(Assets.busSideIcon, height: 20),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            NavigationService.push(
                              target: BusLocationWidget(
                                onChanged: (value) {
                                  _selectedSectorTo.value = value;
                                },
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('To', style: _textTheme.headlineSmall),
                                ValueListenableBuilder<KeyValue?>(
                                  valueListenable: _selectedSectorTo,
                                  builder: (context, val, child) {
                                    return Text(
                                      val != null ? val.title : 'Select',
                                      style: _textTheme.headlineMedium!
                                          .copyWith(
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
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  title: 'Date',
                  hintText: "Select Date",
                  controller: _departureDateController,
                  validator:
                      (value) =>
                          FormValidator.validateFieldNotEmpty(value, 'Date'),
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
                Container(
                  height: 45,
                  width: 300,
                  child: ListView.builder(
                    itemCount: tripType.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CustomRoundedButtom(
                          color:
                              selectedIndex == index
                                  ? _theme.primaryColor
                                  : _theme.primaryColor.withOpacity(0.5),
                          fontSize: 11,
                          title: tripType[index].toString(),
                          onPressed: () {
                            setState(() {
                              selectedShift = tripType[index];
                              selectedIndex = index;
                              print(selectedShift);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        onButtonPressed: () {
          if (_selectedSectorFrom.value != null &&
              _selectedSectorTo.value != null &&
              _formKey.currentState!.validate()) {
            context.read<UtilityPaymentCubit>().fetchDetails(
              serviceIdentifier: "",
              accountDetails: {
                "fromSector": _selectedSectorFrom.value?.value ?? "",
                "toSector": _selectedSectorTo.value?.value ?? "",
                "departureDate":
                    "${departureDate.year}-${departureDate.month}-${departureDate.day}",
                "shift": tripType[selectedIndex],
              },
              apiEndpoint: "/api/busSewa/getTrips",
            );
          } else {
            showPopUpDialog(
              context: context,
              message: "Select Select Sector",
              title: "Select Location",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
        },
      ),
    );
  }
}
