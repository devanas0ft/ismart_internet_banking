import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyCircularBar extends StatelessWidget {
  final String centerText;
  final String title;
  final String primaryText;
  final String primaryDesc;
  final String maxLimit;
  final String maxLimitVal;
  final String remainLimit;
  final String remainLimitVal;
  final Color color;
  final double percent;

  const MyCircularBar({
    super.key,
    required this.centerText,
    required this.title,
    required this.primaryText,
    required this.primaryDesc,
    required this.maxLimit,
    required this.maxLimitVal,
    required this.remainLimit,
    required this.remainLimitVal,
    required this.percent,
    this.color = Colors.deepPurple,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: CircularPercentIndicator(
        animation: true,
        animationDuration: 1000,
        footer: Flexible(
          child: Column(
            children: [
              const SizedBox(height: 5),
              Column(
                children: [
                  Container(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 140,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: color.withOpacity(.1),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            primaryText,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            primaryDesc,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          maxLimit,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 9,
                          ),
                        ),
                        Text(
                          maxLimitVal,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    child: Column(
                      children: [
                        Text(
                          remainLimit,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          remainLimitVal,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        radius: 75,
        lineWidth: 17,
        percent: percent,
        progressColor: color,
        backgroundColor: color.withOpacity(.1),
        circularStrokeCap: CircularStrokeCap.round,
        center: Text(centerText, style: const TextStyle(fontSize: 17)),
      ),
    );
  }
}
