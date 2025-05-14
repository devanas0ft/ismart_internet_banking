import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/app_bar.dart';

class PageWrapper extends StatefulWidget {
  final bool useOwnAppBar;
  final Widget body;
  final bool useOwnScaffold;
  final bool showAppBar;
  final PreferredSizeWidget? appBar;
  final String? title;
  final Widget? leadingAppIcon;
  final List<Widget> appActions;
  final EdgeInsets? padding;
  final double appBarLeftPadding;
  final double appBarRightPadding;
  final Widget? floatinActionButton;
  final Widget? bottomNavBar;
  final Color? backgroundColor;
  final bool showChatBot;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final FloatingActionButtonType floatingActionButtonType;
  final Function()? onBackPressed;
  final bool showBackButton;

  const PageWrapper({
    this.scaffoldKey,
    this.useOwnAppBar = false,
    this.showChatBot = false,
    required this.body,
    this.showBackButton = false,
    this.useOwnScaffold = false,
    this.showAppBar = true,
    this.appBar,
    this.appActions = const [],
    this.leadingAppIcon,
    this.title,
    this.padding,
    this.bottomNavBar,
    this.appBarLeftPadding = CustomTheme.symmetricHozPadding,
    this.appBarRightPadding = CustomTheme.symmetricHozPadding,
    this.floatinActionButton,
    this.backgroundColor,
    this.floatingActionButtonLocation =
        FloatingActionButtonLocation.centerDocked,
    this.floatingActionButtonType = FloatingActionButtonType.Button,
    this.onBackPressed,
  });
  @override
  _PageWrapperState createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  @override
  Widget build(BuildContext context) {
    if (widget.useOwnScaffold) {
      return widget.body;
    } else {
      return Scaffold(
        key: widget.scaffoldKey,
        floatingActionButton:
            widget.floatingActionButtonType == FloatingActionButtonType.Button
                ? (widget.floatinActionButton != null
                    ? AnimatedSwitcher(
                      duration: const Duration(milliseconds: 50),
                      child:
                          MediaQuery.of(context).viewInsets.bottom > 0
                              ? Container()
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      left: CustomTheme.symmetricHozPadding,
                                      right: CustomTheme.symmetricHozPadding,
                                      bottom: 20.hp,
                                    ),
                                    child: widget.floatinActionButton,
                                  ),
                                ],
                              ),
                    )
                    : null)
                : widget.floatinActionButton,
        backgroundColor: widget.backgroundColor,
        bottomNavigationBar: widget.bottomNavBar,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
        appBar:
            widget.showAppBar
                ? (widget.useOwnAppBar
                    ? widget.appBar
                    : myAppbar(
                      showBackButton: widget.showBackButton,
                      showChatBot: widget.showChatBot,
                    ))
                : null,
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 300.w,
              // minWidth: 400,
            ),
            child: Container(
              width: double.infinity,
              padding:
                  widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: CustomTheme.symmetricHozPadding,
                  ),
              child: widget.body,
            ),
          ),
        ),
      );
    }
  }
}

enum FloatingActionButtonType { Button, IconButton }
