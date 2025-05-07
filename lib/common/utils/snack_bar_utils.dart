import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';

class SnackBarUtils {
  static void showSuccessBar({
    required BuildContext context,
    required String message,
  }) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomTheme.green,
        content: Text(
          message,
          style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  static void showErrorBar({
    required BuildContext context,
    required String message,
  }) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: CustomTheme.primaryColor,
        content: Text(
          message,
          style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
