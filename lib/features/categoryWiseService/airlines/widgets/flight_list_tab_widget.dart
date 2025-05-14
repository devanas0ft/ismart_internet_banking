import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/model/category_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/model/airlines_avliable_list_model.dart';
import 'package:ismart_web/features/categoryWiseService/airlines/widgets/flight_list_item_widget.dart';

class FlightListTabWidget extends StatefulWidget {
  const FlightListTabWidget({
    Key? key,
    required this.flightList,
    required this.selectedIndex,
    required this.calculateTotalPrice,
    required this.onSelectionChanged,
    required this.extraCallback,
    required this.serviceInfo,
  }) : super(key: key);
  final int selectedIndex;
  final Function() calculateTotalPrice;
  final Function(int) onSelectionChanged;
  final Function() extraCallback;

  final List<Flight> flightList;
  final ServiceList serviceInfo;
  @override
  State<FlightListTabWidget> createState() => _FlightListTabWidgetState();
}

class _FlightListTabWidgetState extends State<FlightListTabWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                if (widget.selectedIndex == index) {
                  widget.onSelectionChanged(-1);
                } else {
                  widget.onSelectionChanged(index);

                  widget.extraCallback();
                }
                widget.calculateTotalPrice();
                setState(() {});
              },
              child: Container(
                padding:
                    index == widget.selectedIndex
                        ? EdgeInsets.zero
                        : EdgeInsets.only(
                          left: 15.hp,
                          right: 15.hp,
                          top: 15.hp,
                          bottom: 15.hp,
                        ),
                child: FlightDetailsListItemWidget(
                  isSelected: index == widget.selectedIndex,
                  isAboveSelection: index == (widget.selectedIndex - 1),
                  flight: widget.flightList[index],
                  serviceInfo: widget.serviceInfo,
                ),
              ),
            ),
            // const Divider(
            //   height: 0.00,
            // ),
          ],
        );
      }, childCount: widget.flightList.length),
    );
  }
}
