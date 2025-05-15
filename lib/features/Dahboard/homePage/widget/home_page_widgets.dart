import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/shared_pref.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/graphBar/widgets/transaction_summary_screen.dart';
import 'package:ismart_web/features/Dahboard/homePage/screen/homepage_money_page.dart';
import 'package:ismart_web/features/Dahboard/homePage/widget/Recent%20transition/recent_activity_widget.dart';
import 'package:ismart_web/features/Dahboard/widgets/dashboard_widget.dart';
import 'package:ismart_web/features/chatBot/intermediate_chat_page.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';
import 'package:ismart_web/features/sendMoney/screens/send_money_page.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

import '../../../../common/app/navigation_service.dart';
import '../../../splash/resource/startup_repository.dart';
import 'home_page_tabbar_widget.dart';
import 'home_page_user_widget.dart';
// Import TransactionSummaryScreen from its file

// Add this line to import the TransactionSummaryScreen
// import 'path/to/transaction_summary_screen.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  bool _shouldShowDifferentMenu = false;
  // ignore: unused_field
  List<String> _bannerImages = [];

  _checkMenu() {
    final List<String> _clientCodesListForDifferentMenu = [
      "9DZS5N3TOY", // Uttarganga
    ];

    String _clientCode = "";
    _clientCode = RepositoryProvider.of<CoOperative>(context).clientCode;

    _shouldShowDifferentMenu = _clientCodesListForDifferentMenu.contains(
      _clientCode,
    );
  }

  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _bannerImages = RepositoryProvider.of<StartUpRepository>(context).banners;
    customerDetail =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).customerDetailModel;
    _checkMenu();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;

    return PageWrapper(
      padding: EdgeInsets.zero,
      showAppBar: false,
      body: RefreshIndicator(
        onRefresh: () async {
          NavigationService.pushReplacement(target: const DashboardWidget());
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: ValueListenableBuilder<CustomerDetailModel?>(
                valueListenable: customerDetail,
                builder: (context, val, _) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: 30.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  Container(
                                    height: 30.h,
                                    child: const HomePageUserWidget(),
                                  ),
                                  SizedBox(height: _height * 0.01),
                                  if ((val?.instaLoanEnable ?? false) == true)
                                    if (_shouldShowDifferentMenu)
                                      SizedBox(
                                        height: 65.hp,
                                        child: const HomePageMoneyPage(),
                                      ),
                                  if (!_shouldShowDifferentMenu)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    onTap: () {},
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 7,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            offset:
                                                                const Offset(
                                                                  7,
                                                                  7,
                                                                ),
                                                            blurRadius: 8,
                                                            spreadRadius: -5,
                                                          ),
                                                        ],
                                                        color:
                                                            CustomTheme.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                _theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                      0.05,
                                                                    ),
                                                            child: SvgPicture.asset(
                                                              Assets
                                                                  .reveiceMoneyIcon,
                                                              height: 18.hp,
                                                              color:
                                                                  _theme
                                                                      .primaryColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                _width * 0.02,
                                                          ),
                                                          Text(
                                                            "Receive",
                                                            style: _textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: _width * 0.03),

                                                // Remit Button
                                                Expanded(
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    onTap: () {
                                                      // Your navigation code
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 7,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            offset:
                                                                const Offset(
                                                                  7,
                                                                  7,
                                                                ),
                                                            blurRadius: 8,
                                                            spreadRadius: -5,
                                                          ),
                                                        ],
                                                        color:
                                                            CustomTheme.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                _theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                      0.05,
                                                                    ),
                                                            child: Icon(
                                                              Icons
                                                                  .swap_horiz_outlined,
                                                              size: 22.hp,
                                                              color:
                                                                  CustomTheme
                                                                      .primaryColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                _width * 0.02,
                                                          ),
                                                          Text(
                                                            "Remit",
                                                            style: _textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(width: _width * 0.03),
                                                Expanded(
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    onTap: () {
                                                      NavigationService.push(
                                                        target: SendMoneyPage(),
                                                      );
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.symmetric(
                                                            vertical: 7,
                                                          ),
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                            offset:
                                                                const Offset(
                                                                  7,
                                                                  7,
                                                                ),
                                                            blurRadius: 8,
                                                            spreadRadius: -5,
                                                          ),
                                                        ],
                                                        color:
                                                            CustomTheme.white,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          CircleAvatar(
                                                            backgroundColor:
                                                                _theme
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                      0.05,
                                                                    ),
                                                            child: SvgPicture.asset(
                                                              Assets
                                                                  .sendMoneyIcon,
                                                              height: 22.hp,
                                                              color:
                                                                  _theme
                                                                      .primaryColor,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width:
                                                                _width * 0.02,
                                                          ),
                                                          Text(
                                                            "Send",
                                                            style: _textTheme
                                                                .titleLarge!
                                                                .copyWith(
                                                                  fontSize: 12,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            if (Responsive.isDesktop(context))
                              Expanded(
                                flex: 3,
                                child: Container(
                                  margin: EdgeInsets.only(left: 20),
                                  child: TransactionSummaryScreen(),
                                ),
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: _height * 0.02),
                      if (Responsive.isMobile(context) ||
                          Responsive.isTablet(context))
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: TransactionSummaryScreen(),
                        ),
                      // const HomePageTabbarWidget(),
                      RecentActivityTable(),
                    ],
                  );
                },
              ),
            ),

            FutureBuilder(
              future: SharedPref.getChatBotVisibility(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                final isChatBotVisible = snapshot.data ?? false;
                return isChatBotVisible
                    ? Positioned(
                      bottom: 15,
                      right: 15,
                      child: InkWell(
                        onTap: () {
                          onButtonPressed();
                        },
                        child: BlocListener<UtilityPaymentCubit, CommonState>(
                          listener: (context, state) {
                            if (state
                                is CommonStateSuccess<UtilityResponseData>) {
                              final UtilityResponseData response = state.data;
                              if (response.code == "M0000") {
                                NavigationService.push(
                                  target: IntermediateChatPage(
                                    id: response.detail['id'],
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomTheme.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(
                                color: CustomTheme.primaryColor.withOpacity(.7),
                                width: 1.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Image.asset(
                                  "assets/smart_fuchee.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  onButtonPressed() {
    context.read<UtilityPaymentCubit>().fetchDetailsPost(
      serviceIdentifier: "",
      accountDetails: {},
      apiEndpoint: "api/ai/create",
    );
  }
}
