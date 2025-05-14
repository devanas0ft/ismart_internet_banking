import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWebView extends StatefulWidget {
  final URLRequest urlRequest;
  final String receiptUrl;
  const PaymentWebView({
    Key? key,
    required this.urlRequest,
    required this.receiptUrl,
  }) : super(key: key);
  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      supportZoom: false,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
  );

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
      menuItems: [
        ContextMenuItem(
          androidId: 1,
          iosId: "1",
          title: "Special",
          action: () async {
            await webViewController?.clearFocus();
          },
        ),
      ],
      options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
      onCreateContextMenu: (hitTestResult) async {},
      onHideContextMenu: () {},
      onContextMenuActionItemClicked: (contextMenuItemClicked) async {},
    );

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: Colors.blue),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
            urlRequest: URLRequest(url: await webViewController?.getUrl()),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // String? _lastTrackedUri;
  final bool _hasBeenResponded = false;
  // final int _count = 0;
  _handleRedirection(Uri? uri) async {
    if (uri != null && !_hasBeenResponded) {
      if (uri.toString().toLowerCase().contains("exitme")) {
        if (uri.toString().toLowerCase().contains("success")) {
          showPopUpDialog(
            context: context,
            message: "Your load fund transaction is successfull.",
            title: "Success",
            buttonCallback: () {
              NavigationService.pushReplacement(
                target: const DashboardWidget(),
              );
            },
            showCancelButton: false,
          );
        } else {
          showPopUpDialog(
            context: context,
            message: "Your load fund transaction is failed.",
            title: "Failed",
            buttonCallback: () {
              NavigationService.pushReplacement(
                target: const DashboardWidget(),
              );
            },
            showCancelButton: false,
          );
        }

        return;
      }
      if (uri.toString().toLowerCase().contains("ismart.devanasoft.com")) {
        print(uri.toString().toLowerCase());
        // final String? merchantTxnId = uri.queryParameters['MerchantTxnId'];

        final Map<String, dynamic> _params = uri.queryParameters;
        if (_params.containsKey("status")) {
          if (_params['status'] == 200) {
            showPopUpDialog(
              context: context,
              message: "Your load fund transaction is successfull.",
              title: "Success",
              buttonCallback: () {
                NavigationService.pushReplacement(
                  target: const DashboardWidget(),
                );
              },
              showCancelButton: false,
            );
          } else {
            showPopUpDialog(
              context: context,
              message: "Your load fund transaction is failed.",
              title: "Failed",
              buttonCallback: () {
                NavigationService.pushReplacement(
                  target: const DashboardWidget(),
                );
              },
              showCancelButton: false,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      padding: EdgeInsets.zero,
      showBackButton: true,
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: widget.urlRequest,
              initialUserScripts: UnmodifiableListView<UserScript>([]),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) async {
                await _handleRedirection(url);
                urlController.text = this.url;
              },
              androidOnPermissionRequest: (
                controller,
                origin,
                resources,
              ) async {
                return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT,
                );
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about",
                ].contains(uri.scheme)) {
                  final _uri = Uri.tryParse(url);
                  if (_uri != null) {
                    if (await canLaunchUrl(_uri)) {
                      // Launch the App
                      await launchUrl(_uri);
                      // and cancel the request
                      return NavigationActionPolicy.CANCEL;
                    }
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                print("Error loading URL : ----------- ");
                print(url);
                print(code);
                print(message);
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) async {
                await _handleRedirection(url);
                // print(controller);
                // print("URL Issue : " + url.toString());
                // setState(() {
                //   this.url = url.toString();
                //   urlController.text = this.url;
                // });
              },
              onConsoleMessage: (controller, consoleMessage) async {
                await _handleRedirection(await controller.getUrl());
                // final Uri? _testUri = await controller.getUrl();
                // print("URL Controller : " + _testUri.toString());
                // print("Console Message: " +
                //     consoleMessage.message +
                //     consoleMessage.toString());
                // print("TEST URL: " + _testUri.toString());
                // if (_testUri != null &&
                //     _testUri.toString().contains("paywellcorp")) {
                //   print("Caught it ");
                //   final String? merchantTxnId =
                //       _testUri.queryParameters['MerchantTxnId'];

                //   if (merchantTxnId != null) {
                //     NavigationService.pop();
                //     context
                //         .read<CoreWalletCubit>()
                //         .getLoadFundReceipt(txnID: merchantTxnId);
                //   } else {
                //     NavigationService.pop();
                //   }
                // }
              },
            ),
            progress < 1.0
                ? LinearProgressIndicator(value: progress)
                : Container(),
          ],
        ),
      ),
    );
  }
}
