import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/test_loading_widget.dart';

showLoadingDialogBox(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const LoadingDialogBox();
    },
  );
}

class LoadingDialogBox extends StatelessWidget {
  const LoadingDialogBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TestLoadingWidget(ringColor: CustomTheme.primaryColor),
              // Image.asset(
              //   Assets.loader,
              //   height: 80,
              //   width: 80,
              // ),
              // const SizedBox(height: 14),
              // Text(
              //   "Loading...",
              //   style: _textTheme.titleLarge!.copyWith(
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
