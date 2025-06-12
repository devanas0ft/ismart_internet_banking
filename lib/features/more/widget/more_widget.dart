import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:ismart_web/common/utils/url_launcher.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_gridview_container.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/more/calculator/calculator_screen.dart';
import 'package:ismart_web/features/more/download/screens/downloads_page.dart';
import 'package:ismart_web/features/more/feedback/screen/feedback_page.dart';
import 'package:ismart_web/features/more/transactionLimit/transaction_limit_widget.dart';
import 'package:ismart_web/features/setting/changeMpin/screen/change_mpin_page.dart';
import 'package:ismart_web/features/setting/screen/setting_page.dart';

String _supportContact = '9801132219';
// RepositoryProvider.of<AppContactRepository>(NavigationService.context)
//     .contactNumber;

// List<Map<String, dynamic>> _contactUsOptions = [
//   {
//     "title": "Call Support",
//     "action": () {
//       // NavigationService.pop();
//       // UrlLauncher.launchPhone(
//       //   context: NavigationService.context,
//       //   phone: _supportContact,
//       // );
//     },
//   },
//   {
//     "title": "Chat on Viber",
//     "action": () {
//       NavigationService.pop();
//       UrlLauncher.launchWebsite(
//         context: NavigationService.context,
//         url: "viber://chat?number=%2B977$_supportContact",
//       );
//     },
//   },
//   {
//     "title": "Chat on WhatsApp",
//     "action": () {
//       NavigationService.pop();
//       UrlLauncher.launchUrlLink(
//         context: NavigationService.context,
//         url: "https://wa.me/%2B977$_supportContact",
//       );
//     },
//   },
// ];

// ignore: must_be_immutable
class MoreWidget extends StatefulWidget {
  const MoreWidget({Key? key}) : super(key: key);

  @override
  State<MoreWidget> createState() => _MoreWidgetState();
}

class _MoreWidgetState extends State<MoreWidget> {
  final List<String> itemImage = [
    "assets/icons/pin-code-svgrepo-com 1.svg",
    Assets.transactionLimit,
    Assets.discountCalculator,
    Assets.downloadIcon,
    Assets.contactUsIcon,
    Assets.settingIcon,
    Assets.feedBackIcon,
  ];

  final List names = [
    "Change Security Pin",
    "Transaction Limits",
    "Calculator",
    "Downloads",
    "Support",
    "Settings",
    "FeedBack",
  ];
  String mPin = "";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contactList = _supportContact.split(",");
    final List tapFunction = [
      () {
        NavigationService.push(
          target: TransactionPinScreen(
            showBiometric: false,
            onValueCallback: (p0) {
              NavigationService.pop();

              if (p0 == mPin) {
                NavigationService.push(target: ChangeMpinPage(oldMpin: p0));
              } else {
                print("mpin is $mPin");
                SnackBarUtils.showErrorBar(
                  context: NavigationService.context,
                  message: "Invalid Security Pin .Please try again.",
                );
              }
            },
          ),
        );
      },
      () {
        NavigationService.push(target: const TransactionLimitWidget());
      },
      () {
        NavigationService.push(target: const CalculatorScreen());
      },
      () {
        NavigationService.push(target: DownloadPage());
      },
      () async {
        final _textTheme = Theme.of(NavigationService.context).textTheme;
        showModalBottomSheet(
          context: NavigationService.context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.hp),
              topRight: Radius.circular(30.hp),
            ),
          ),
          builder:
              (context) => Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 24, bottom: 24),
                      height: 4,
                      width: 55,
                      decoration: BoxDecoration(
                        color: CustomTheme.lightGray.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Text(
                      "Choose Option",
                      style: _textTheme.labelLarge!.copyWith(
                        color: CustomTheme.darkerBlack,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const Divider(height: 40),
                    ...List.generate(contactList.length, (index) {
                      return InkWell(
                        onTap: () {
                          NavigationService.pop();
                          UrlLauncher.launchPhone(
                            context: NavigationService.context,
                            phone: contactList[index],
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.hp,
                            vertical: 15.hp,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Call Support",
                                        style: _textTheme.bodyLarge!.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: CustomTheme.primaryColor,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        contactList[index],
                                        style: _textTheme.bodyLarge!.copyWith(
                                          color: CustomTheme.darkGray,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: CustomTheme.primaryColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
        );
      },
      () {
        NavigationService.push(target: const SettingPage());
      },
      () {
        NavigationService.push(target: const FeedBackPage());
      },
    ];

    return CommonContainer(
      showTitleText: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          int crossAxisCount = width ~/ 180;
          if (crossAxisCount < 1) crossAxisCount = 1;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: names.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
            ),
            itemBuilder: (context, index) {
              return CommonGridViewContainer(
                margin:
                    Responsive.isDesktop(context)
                        ? const EdgeInsets.all(24)
                        : const EdgeInsets.all(8),
                onContainerPress: () => tapFunction[index](),
                containerImage: itemImage[index],
                title: names[index],
              );
            },
          );
        },
      ),
      topbarName: "More",
      showBackBotton: false,
      showDetail: false,
      showRoundBotton: false,
    );
  }
}
