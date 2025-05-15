import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

class LoanScheduleRowWidget extends StatelessWidget {
  final int index;
  final UtilityResponseData responseData;

  const LoanScheduleRowWidget({
    Key? key,
    required this.index,
    required this.responseData,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final response = responseData.findValue(primaryKey: "data");
    return Container(
      color:
          index.isEven
              ? CustomTheme.white
              : _theme.primaryColor.withOpacity(0.03),
      padding: EdgeInsets.symmetric(vertical: 10.hp),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(child: Center(child: Text("${index + 1}"))),
          ),
          Flexible(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Text(response[index]["scheduleDate"].toString()),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Container(
                        child: Center(
                          child: Text(
                            response[index]["scheduleAmount"].toString(),
                            style: const TextStyle(
                              color: CustomTheme.googleColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Text(response[index]["principal"].toString()),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Center(
                        child: Text(response[index]["interest"].toString()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
