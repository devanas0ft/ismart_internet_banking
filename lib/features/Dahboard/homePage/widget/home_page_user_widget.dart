//Ui test for uttarganga

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/constants/assets.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/text_utils.dart';
import 'package:ismart_web/common/widget/account_list_box.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/customerDetail/resource/customer_detail_repository.dart';

// import '../../../../common/app/navigation_service.dart';

class HomePageUserWidget extends StatefulWidget {
  const HomePageUserWidget({
    super.key,
    this.selectedImage,
    this.isPreview = false,
  });

  final File? selectedImage;
  final bool isPreview;

  @override
  State<HomePageUserWidget> createState() => _HomePageUserWidgetState();
}

class _HomePageUserWidgetState extends State<HomePageUserWidget> {
  bool showAmountDetail = false;
  ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);
  ValueNotifier<AccountDetail?> selectedAccountNotifier = ValueNotifier(null);
  ValueNotifier<dynamic> accountDetail = ValueNotifier([]);
  String bannerImage = "";
  String? imageUrl;
  String? gender;

  @override
  void initState() {
    super.initState();
    customerDetail =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).customerDetailModel;
    accountDetail =
        RepositoryProvider.of<CustomerDetailRepository>(context).accountsList;
    selectedAccountNotifier =
        RepositoryProvider.of<CustomerDetailRepository>(
          context,
        ).selectedAccount;

    bannerImage = RepositoryProvider.of<CoOperative>(context).bannerImage;
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    final _width = SizeUtils.width;
    final _height = SizeUtils.height;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: _theme.scaffoldBackgroundColor,
            image: DecorationImage(
              image: AssetImage(
                RepositoryProvider.of<CoOperative>(
                  context,
                ).backgroundImage.toString(),
              ),
              fit: BoxFit.fill,
            ),
          ),
          child: ValueListenableBuilder<AccountDetail?>(
            valueListenable: selectedAccountNotifier,
            builder: (context, selectedAcc, _) {
              return ValueListenableBuilder<CustomerDetailModel?>(
                valueListenable: customerDetail,
                builder: (context, val, _) {
                  if (val != null) {
                    imageUrl = val.imageUrl;
                    gender = val.gender;
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      setState(() {});
                    });

                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      // NavigationService.pushNamed(
                                      //     routeName: Routes.profileScreen);
                                    },
                                    child:
                                        (gender?.toLowerCase() == 'male' ||
                                                gender == null)
                                            ? const CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                Assets.profilePicture,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            )
                                            : const CircleAvatar(
                                              radius: 20,
                                              backgroundImage: AssetImage(
                                                Assets.femaleProfilePicture,
                                              ),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                  ),
                                  SizedBox(width: _width * 0.02),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        TextUtils.generateGreet,
                                        style: _textTheme.headlineMedium
                                            ?.copyWith(
                                              color: CustomTheme.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                      Text(
                                        val.fullName,
                                        overflow: TextOverflow.ellipsis,
                                        style: _textTheme.headlineMedium
                                            ?.copyWith(
                                              fontSize: 13,
                                              color: CustomTheme.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  // Expanded(
                                  //   child: InkWell(
                                  //     onTap: () {
                                  //       NavigationService.push(
                                  //           target: QRScannerScreens());
                                  //     },
                                  //     child: Align(
                                  //       alignment: Alignment.centerRight,
                                  //       child: Padding(
                                  //         padding:
                                  //             EdgeInsets.only(right: 4.hp),
                                  //         child: SvgPicture.asset(
                                  //           Assets.qrCodeIcon,
                                  //           height: 30.hp,
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              SizedBox(height: 10.hp),

                              // const Spacer(),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => const AccountDetailBox(
                                              validateMobileBankingStatus:
                                                  false,
                                            ),
                                      );
                                    },
                                    child: Container(
                                      width: _width * 0.4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Text(
                                                    (selectedAcc?.accountTypeDescription)
                                                            .toString()
                                                            .isEmpty
                                                        ? (selectedAcc
                                                                ?.accountType ??
                                                            "")
                                                        : (selectedAcc
                                                                ?.accountTypeDescription ??
                                                            ""),
                                                    style: _textTheme.titleSmall
                                                        ?.copyWith(
                                                          color:
                                                              CustomTheme.white,
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                    // overflow: TextOverflow.clip,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: _width * 0.01),
                                              RotatedBox(
                                                quarterTurns: 5,
                                                child: SvgPicture.asset(
                                                  Assets.arrowRight,
                                                  color: CustomTheme.white,
                                                  height: _height * 0.015,
                                                ),
                                              ),
                                              SizedBox(width: _width * 0.02),
                                              if (selectedAcc?.primary
                                                      .toString() ==
                                                  "true")
                                                Container(
                                                  padding: const EdgeInsets.all(
                                                    2,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: CustomTheme.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "P",
                                                      style: _textTheme
                                                          .titleSmall
                                                          ?.copyWith(
                                                            color:
                                                                CustomTheme
                                                                    .primaryColor,
                                                            fontSize: 9,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          Text(
                                            "${selectedAcc?.mainCode}",
                                            style: _textTheme.titleSmall
                                                ?.copyWith(
                                                  color: CustomTheme.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Expanded(
                                  //   child: Align(
                                  //     alignment: Alignment.centerRight,
                                  //     child: Text(
                                  //       "Interest Rate: ${selectedAcc?.interestRate} %",
                                  //       style:
                                  //           _textTheme.titleSmall?.copyWith(
                                  //         color: CustomTheme.white,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 10.hp),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showAmountDetail = !showAmountDetail;
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              "Actual Balance",
                                              style: _textTheme.titleSmall!
                                                  .copyWith(
                                                    fontSize: 11,
                                                    color: CustomTheme.white,
                                                  ),
                                            ),
                                            const SizedBox(width: 10),
                                            InkWell(
                                              // onTap: () {
                                              //   setState(() {
                                              //     showAmountDetail = !showAmountDetail;
                                              //   });
                                              // },
                                              child: Icon(
                                                showAmountDetail
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: CustomTheme.white,
                                                size: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          showAmountDetail
                                              ? "NPR ${selectedAcc?.actualBalance}"
                                              : "XXXXXXXXX",
                                          style: _textTheme.titleLarge!
                                              .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10.hp),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Available Balance",
                                          style: _textTheme.titleSmall!
                                              .copyWith(
                                                fontSize: 11,
                                                color: CustomTheme.white,
                                              ),
                                        ),
                                        Text(
                                          showAmountDetail
                                              ? "NPR ${selectedAcc?.availableBalance}"
                                              : "XXXXXXXXX",
                                          style: _textTheme.titleLarge!
                                              .copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: CustomTheme.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              );
            },
          ),
        ),
        if ((imageUrl != null && imageUrl!.isNotEmpty) ||
            (widget.isPreview && widget.selectedImage != null))
          Positioned(
            right: 0,
            bottom: 0,
            child: Stack(
              children: [
                Container(
                  // clipBehavior: Clip.antiAlias,
                  // padding: const EdgeInsets.all(10),
                  height: 160,
                  width: 215,
                  decoration: BoxDecoration(
                    // border: Border.all(
                    color: CustomTheme.white.withOpacity(0.15),
                    // ),
                    // shape: BoxShape.circle,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                    ),
                  ),
                  // child:
                ),
                Positioned(
                  bottom: 0,
                  right: 7,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(100),
                      topRight: Radius.circular(100),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    child:
                        widget.selectedImage != null
                            ? Image.file(
                              widget.selectedImage!,
                              height: 150,
                              width: 200,
                              fit: BoxFit.cover,
                            )
                            : CustomCachedNetworkImage(
                              url: imageUrl!,
                              height: 150,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:ismart/app/theme.dart';
// import 'package:ismart/common/constant/assets.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/account_list_box.dart';
// import 'package:ismart/feature/customerDetail/model/customer_detail_model.dart';
// import 'package:ismart/feature/customerDetail/resource/customer_detail_repository.dart';
// import 'package:ismart/feature/qrscanner/screens/qrscanner_screen.dart';

// class HomePageUserWidget extends StatefulWidget {
//   const HomePageUserWidget({Key? key}) : super(key: key);

//   @override
//   State<HomePageUserWidget> createState() => _HomePageUserWidgetState();
// }

// class _HomePageUserWidgetState extends State<HomePageUserWidget> {
//   bool showAmountDetail = false;
//   ValueNotifier<CustomerDetailModel?> customerDetail = ValueNotifier(null);
//   ValueNotifier<AccountDetail?> selectedAccountNotifier = ValueNotifier(null);
//   ValueNotifier<dynamic> accountDetail = ValueNotifier([]);
//   String formattedDate = DateFormat('a').format(DateTime.now());

//   String bannerImage = "";
//   @override
//   void initState() {
//     customerDetail = RepositoryProvider.of<CustomerDetailRepository>(context)
//         .customerDetailModel;
//     accountDetail =
//         RepositoryProvider.of<CustomerDetailRepository>(context).accountsList;
//     selectedAccountNotifier =
//         RepositoryProvider.of<CustomerDetailRepository>(context)
//             .selectedAccount;

//     bannerImage = RepositoryProvider.of<CoOperative>(context).bannerImage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _theme = Theme.of(context);
//     final _textTheme = _theme.textTheme;
//     final _width = SizeUtils.width;
//     final _height = SizeUtils.height;
//     return Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(18), color: CustomTheme.white),
//         child: ValueListenableBuilder<AccountDetail?>(
//             valueListenable: selectedAccountNotifier,
//             builder: (context, selectedAcc, _) {
//               return ValueListenableBuilder<CustomerDetailModel?>(
//                   valueListenable: customerDetail,
//                   builder: (context, val, _) {
//                     if (val != null) {
//                       return Column(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 12, vertical: 12),
//                             height: _height * 0.16,
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: AssetImage(
//                                     RepositoryProvider.of<CoOperative>(context)
//                                         .backgroundImage
//                                         .toString()),
//                                 fit: BoxFit.fitWidth,
//                               ),
//                               borderRadius: BorderRadius.circular(15),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           formattedDate == 'AM'
//                                               ? 'Good Morning,'
//                                               : 'Good Afternoon,',
//                                           style: _textTheme.headlineMedium
//                                               ?.copyWith(
//                                             color: CustomTheme.white,
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           val.fullName,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: _textTheme.headlineMedium
//                                               ?.copyWith(
//                                             fontSize: 14,
//                                             color: CustomTheme.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     // Expanded(
//                                     //   child: InkWell(
//                                     //     onTap: () {
//                                     //       NavigationService.push(
//                                     //           target: QRScannerScreens());
//                                     //     },
//                                     //     child: Align(
//                                     //       alignment: Alignment.centerRight,
//                                     //       child: Padding(
//                                     //         padding:
//                                     //             EdgeInsets.only(right: 4.hp),
//                                     //         child: SvgPicture.asset(
//                                     //           Assets.qrCodeIcon,
//                                     //           height: 30.hp,
//                                     //         ),
//                                     //       ),
//                                     //     ),
//                                     //   ),
//                                     // )
//                                   ],
//                                 ),
//                                 // const Spacer(),
//                                 Row(
//                                   children: [
//                                     InkWell(
//                                       onTap: () {
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) =>
//                                               const AccountDetailBox(),
//                                         );
//                                       },
//                                       child: Row(
//                                         children: [
//                                           Container(
//                                             width: _width * 0.4,
//                                             child: Text(
//                                               "${selectedAcc?.accountType} A/C :\n${selectedAcc?.mainCode}",
//                                               style: _textTheme.titleSmall
//                                                   ?.copyWith(
//                                                 color: CustomTheme.white,
//                                                 fontSize: 10,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(width: _width * 0.02),
//                                           RotatedBox(
//                                             quarterTurns: 5,
//                                             child: SvgPicture.asset(
//                                               Assets.arrowRight,
//                                               color: CustomTheme.white,
//                                               height: _height * 0.015,
//                                             ),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Align(
//                                         alignment: Alignment.centerRight,
//                                         child: Text(
//                                           "Interest Rate: ${selectedAcc?.interestRate} %",
//                                           style:
//                                               _textTheme.titleSmall?.copyWith(
//                                             fontSize: 10,
//                                             color: CustomTheme.white,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                             child: InkWell(
//                               onTap: () {
//                                 setState(() {
//                                   showAmountDetail = !showAmountDetail;
//                                 });
//                               },
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Actual Balance",
//                                         style: _textTheme.titleSmall,
//                                       ),
//                                       Text(
//                                         showAmountDetail
//                                             ? "NPR ${selectedAcc?.actualBalance}"
//                                             : "XXXXXXXXX",
//                                         style: _textTheme.titleLarge!.copyWith(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                   InkWell(
//                                     // onTap: () {
//                                     //   setState(() {
//                                     //     showAmountDetail = !showAmountDetail;
//                                     //   });
//                                     // },
//                                     child: Icon(
//                                       showAmountDetail
//                                           ? Icons.visibility
//                                           : Icons.visibility_off,
//                                     ),
//                                   ),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Available Balance",
//                                         style: _textTheme.titleSmall,
//                                       ),
//                                       Text(
//                                         showAmountDetail
//                                             ? "NPR ${selectedAcc?.availableBalance}"
//                                             : "XXXXXXXXX",
//                                         style: _textTheme.titleLarge!.copyWith(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     } else {
//                       return Container();
//                     }
//                   });
//             }));
//   }
// }
