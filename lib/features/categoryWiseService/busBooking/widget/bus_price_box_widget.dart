import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/loan_key_value_tile.dart';

class BusPriceBoxWidget extends StatelessWidget {
  final int selectedSeatCount;
  final double ticketPrice;
  final double totalPrice;
  final Function() onPress;

  const BusPriceBoxWidget({
    Key? key,
    required this.selectedSeatCount,
    required this.ticketPrice,
    required this.totalPrice,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12),
          right: Radius.circular(12),
        ),
        color: CustomTheme.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          LoanKeyValueTile(
            title: "Ticket Price",
            value: ticketPrice.toString(),
            axis: Axis.vertical,
          ),
          LoanKeyValueTile(
            title: "No. of Seats",
            value: selectedSeatCount.toString(),
            axis: Axis.vertical,
          ),
          Center(
            child: LoanKeyValueTile(
              titleFontWeight: FontWeight.bold,
              title: "Total",
              value: "Rs" + totalPrice.toString(),
              axis: Axis.vertical,
            ),
          ),
          CustomRoundedButtom(title: "Book", onPressed: onPress),
        ],
      ),
    );
  }
}
