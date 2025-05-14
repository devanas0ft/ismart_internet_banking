import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class BusTopBarLocationBox extends StatelessWidget {
  final BusTopBarModel busModel;
  const BusTopBarLocationBox({Key? key, required this.busModel})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  busModel.sectorFrom,
                  style: _textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _theme.primaryColor,
                  ),
                ),
              ),
              Expanded(
                child: SvgPicture.asset(
                  Assets.busSideIcon,
                  height: 20,
                  color: _theme.primaryColor,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    busModel.sectorTo,
                    style: _textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _theme.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.hp),
        Text(
          busModel.selectedDate,
          style: _textTheme.titleSmall!.copyWith(
            fontWeight: FontWeight.w600,
            color: _theme.primaryColor,
          ),
        ),
      ],
    );
  }
}

class BusTopBarModel {
  final String sectorFrom;
  final String sectorTo;
  final String selectedDate;

  BusTopBarModel({
    required this.sectorFrom,
    required this.sectorTo,
    required this.selectedDate,
  });
}
