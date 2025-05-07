import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';

class StatementDetailBox extends StatelessWidget {
  final bool isCredit;
  final String balance;
  final String desc;
  final String amount;
  final String dateTime;
  final String imageUrl;
  final String status;

  const StatementDetailBox({
    Key? key,
    this.isCredit = false,
    required this.balance,
    required this.desc,
    required this.amount,
    required this.dateTime,
    required this.imageUrl,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: _width * 0.12,
              height: _height * 0.052,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    isCredit
                        ? Colors.green.withOpacity(0.08)
                        : Colors.red.withOpacity(0.08),
              ),
              child:
                  isCredit
                      ? SvgPicture.asset(Assets.arrowUp)
                      : RotatedBox(
                        quarterTurns: 10,
                        child: SvgPicture.asset(
                          Assets.arrowUp,
                          color: Colors.red,
                        ),
                      ),
            ),
            SizedBox(width: _width * 0.04),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateTime,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  Text(desc, style: Theme.of(context).textTheme.labelLarge),
                ],
              ),
            ),
            SizedBox(width: _width * 0.04),
            Column(
              children: [
                Text(
                  "NPR $amount",
                  style: TextStyle(
                    fontFamily: "popinsemibold",
                    fontSize: 12,
                    color: isCredit ? const Color(0xFF24BC7C) : Colors.red,
                  ),
                ),
                Container(
                  width: _width * 0.2,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: isCredit ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      status,
                      style: const TextStyle(
                        fontFamily: "popinsemibold",
                        color: CustomTheme.white,
                      ),
                    ),
                  ),
                ),
                Text(
                  "NPR $balance",
                  style: const TextStyle(
                    fontFamily: "popinsemibold",
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
