import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';

class TimerScreen extends StatefulWidget {
  final int minutes;

  const TimerScreen({required this.minutes});

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late Timer _timer;
  late int _totalSeconds;

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.minutes * 60;
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_totalSeconds > 0) {
          _totalSeconds--;
        } else {
          _timer.cancel();
          showPopUpDialog(
            context: context,
            message: "The hold time for movie expired. Please try again.",
            title: "Time Expired",
            showCancelButton: false,
            buttonCallback: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardWidget(),
                ),
              );
            },
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get timerText {
    final int minutes = _totalSeconds ~/ 60;
    final int seconds = _totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Please fill the form within :",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black38,
            ),
          ),
          SizedBox(
            width: 10.w,
            child: Text(
              timerText,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
