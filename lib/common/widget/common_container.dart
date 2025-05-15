import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/fonts.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/custom_round_button.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/scaffold_topbar.dart';
import 'package:ismart_web/features/history/models/recent_transaction_model.dart';
import 'package:ismart_web/features/history/screen/recent_transaction_service_page.dart';

import '../app/navigation_service.dart';

class CommonContainer extends StatefulWidget {
  final bool? validateMobileBankingStatus;
  final Widget body;
  final String? serviceName;
  final String serviceCategoryId;
  final String? serviceId;

  final String associatedId;
  final bool showRecentTransaction;
  final String accountTitle;
  final bool showAccountSelection;
  final String topbarName;
  final String title;
  final bool showDetail;
  final String buttonName;
  final String detail;
  final bool showBackBotton;
  final bool showRoundBotton;
  final bool showTitleText;

  final double verticalPadding;
  final double horizontalPadding;
  final VoidCallback? onBackPressed;
  final String? verificationAmount;
  final String? subTitle;

  final Function(RecentTransactionModel)? onRecentTransactionPressed;

  final Function()? onButtonPressed;
  const CommonContainer({
    this.subTitle,
    this.serviceCategoryId = "",
    this.showDetail = false,
    this.showRecentTransaction = false,
    this.accountTitle = "From Account",
    this.showAccountSelection = false,
    this.verticalPadding = 20.0,
    this.horizontalPadding = 20.0,
    this.showTitleText = true,
    this.showBackBotton = true,
    this.buttonName = "Button Name",
    this.showRoundBotton = true,
    required this.body,
    required this.topbarName,
    this.onButtonPressed,
    this.title = "",
    this.detail = "",
    this.associatedId = "",
    this.serviceName,
    this.onRecentTransactionPressed,
    this.serviceId = "",
    this.onBackPressed,
    this.validateMobileBankingStatus = true,
    this.verificationAmount,
  });

  @override
  State<CommonContainer> createState() => _CommonContainerState();
}

class _CommonContainerState extends State<CommonContainer> {
  late DraggableScrollableController _controller;
  double initialChildSize = 0.07;
  static const double minChildSize = 0.07;
  static const double maxChildSize = 0.9;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }

  void _toggleSheet() {
    isExpanded = !isExpanded;
    setState(() {
      if (isExpanded) {
        _controller.animateTo(
          isExpanded ? maxChildSize : minChildSize,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        isExpanded = !isExpanded;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _height = SizeUtils.height;
    //  final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    // bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    // print('is keyboard opened: ${isKeyboardOpen}');
    return PageWrapper(
      showAppBar: false,
      padding: EdgeInsets.zero,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.hp),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ScaffoldTopBar(
                  subTitle: widget.subTitle ?? '',
                  name: widget.topbarName,
                  showBackButton: widget.showBackBotton,
                  onBackPressed:
                      widget.onBackPressed ?? () => NavigationService.pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                        ),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        horizontal: widget.horizontalPadding,
                        vertical: widget.verticalPadding,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (widget.title.isNotEmpty)
                                      Text(
                                        widget.title,
                                        style: _textTheme.displaySmall!
                                            .copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    if (widget.detail.isNotEmpty)
                                      Text(
                                        widget.detail,
                                        style: _textTheme.titleLarge,
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: _height * 0.01),
                          widget.showAccountSelection
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.accountTitle,
                                    style: const TextStyle(
                                      fontFamily: Fonts.poppin,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: CustomTheme.lightTextColor,
                                    ),
                                  ),
                                  PrimaryAccountBox(
                                    validateMobileBankingStatus:
                                        widget.validateMobileBankingStatus,
                                  ),
                                ],
                              )
                              : Container(),
                          widget.body,
                          SizedBox(height: _height * 0.03),
                          widget.showRoundBotton
                              ? CustomRoundedButtom(
                                verificationAmount: widget.verificationAmount,
                                title: widget.buttonName,
                                onPressed: widget.onButtonPressed,
                              )
                              : Container(),
                          SizedBox(height: _height * 0.25),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (widget.showRecentTransaction)
            DraggableScrollableSheet(
              initialChildSize: initialChildSize,
              minChildSize: minChildSize,
              maxChildSize: maxChildSize,
              controller: _controller,
              snap: true,
              snapSizes: [initialChildSize, 0.2, maxChildSize],
              builder: (
                BuildContext context,
                ScrollController scrollController,
              ) {
                return GestureDetector(
                  onTap: _toggleSheet,
                  child: Container(
                    color: CustomTheme.white,
                    child: SafeArea(
                      top: false,
                      child: Container(
                        decoration: BoxDecoration(
                          color: CustomTheme.white,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(15),
                              blurRadius: 4,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: CustomScrollView(
                          controller: scrollController,
                          slivers: [
                            SliverPersistentHeader(
                              pinned: true,
                              delegate: _SliverHeaderDelegate(
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      child: Container(
                                        height: 4,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.grey[300],
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 3,
                                      ),
                                      child: Text(
                                        "Recent Transaction",
                                        style: _textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverFillRemaining(
                              hasScrollBody: true,
                              child: RecentTransactionServiceScreen(
                                serviceId: widget.serviceId ?? "",
                                onRecentTransactionPressed:
                                    widget.onRecentTransactionPressed ?? (v) {},
                                service: widget.serviceName,
                                serviceCategoryId: widget.serviceCategoryId,
                                associatedId: widget.associatedId,
                                onListTap: () {
                                  _controller.animateTo(
                                    initialChildSize,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _SliverHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      child: Material(elevation: 0, child: child),
    );
  }

  @override
  double get maxExtent => 55.0;
  @override
  double get minExtent => 55.0;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
