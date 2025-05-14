import 'package:flutter/material.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlLauncher {
  static Future<bool> launchWebsite({
    required BuildContext context,
    required String url,
  }) async {
    try {
      final _canLaunch = await canLaunchUrl(Uri.parse(url));
      if (_canLaunch) {
        launchUrl(Uri.parse(url));
        return true;
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "Unable to launch URL.",
        );
      }
      return false;
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
      return false;
    }
  }

  static Future<void> launchPhone({
    required BuildContext context,
    required String phone,
  }) async {
    try {
      final _canLaunch = await canLaunchUrl(Uri.parse("tel:$phone"));
      if (_canLaunch) {
        launchUrl(Uri.parse("tel:$phone"));
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "Unable to launch URL.",
        );
      }
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
    }
  }

  Future<void> launchSMS({
    required BuildContext context,
    required String phone,
  }) async {
    try {
      final _canLaunch = await canLaunchUrl(Uri.parse("sms:$phone"));
      if (_canLaunch) {
        launchUrl(Uri.parse("sms:$phone"));
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "Unable to launch URL.",
        );
      }
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
    }
  }

  static Future<void> launchEmail({
    required BuildContext context,
    required String email,
  }) async {
    try {
      final Uri _emailLaunchUri = Uri(scheme: 'mailto', path: email);
      final _canLaunch = await canLaunchUrl(_emailLaunchUri);
      if (_canLaunch) {
        launchUrl(_emailLaunchUri);
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "No email app found.",
        );
      }
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
    }
  }

  static Future<void> launchYoutubeChannel({
    required BuildContext context,
    required String channelId,
  }) async {
    try {
      final _url = Uri.parse('https://www.youtube.com/channel/$channelId');
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url);
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "Unable to launch URL.",
        );
      }
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
    }
  }

  static Future<void> launchUrlLink({
    required BuildContext context,
    required String url,
  }) async {
    try {
      final _url = Uri.parse(url);
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url);
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "Unable to launch URL.",
        );
      }
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
    }
  }

  static Future<void> launchGoogleMap({
    required BuildContext context,
    required String latitude,
    required String longitude,
  }) async {
    try {
      final _url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
      );
      if (await canLaunchUrl(_url)) {
        await launchUrl(_url);
      } else {
        SnackBarUtils.showErrorBar(
          context: context,
          message: "Unable to launch URL.",
        );
      }
    } catch (e) {
      SnackBarUtils.showErrorBar(
        context: context,
        message: "Unable to launch URL.",
      );
    }
  }
}
