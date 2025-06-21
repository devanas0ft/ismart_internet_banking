// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:ismart/common/common/data_state.dart';
// import 'package:ismart/common/constant/env.dart';
// import 'package:ismart/common/navigation/navigation_service.dart';
// import 'package:ismart/common/route/routes.dart';
// import 'package:ismart/common/util/size_utils.dart';
// import 'package:ismart/common/widget/common_container.dart';
// import 'package:ismart/common/widget/common_detail_box.dart';
// import 'package:ismart/common/widget/page_wrapper.dart';
// import 'package:ismart/feature/appServiceManagement/cubit/app_service_cubit.dart';
// import 'package:ismart/feature/appServiceManagement/resource/app_service_repository.dart';

// class SendMoneyWidget extends StatelessWidget {
//   SendMoneyWidget({Key? key}) : super(key: key);
//   final appServiceRepo =
//       RepositoryProvider.of<AppServiceRepository>(NavigationService.context)
//           .appService;
//   @override
//   Widget build(BuildContext context) {
//     final _height = SizeUtils.height;

//     final filteredItems = RepositoryProvider.of<AppServiceRepository>(context)
//         .appService
//         .where((item) =>
//             item.type.toString().toLowerCase().contains("send".toLowerCase()) &&
//             item.status.toLowerCase() == "Active".toLowerCase())
//         .toList();

//     return PageWrapper(
//       body: BlocConsumer<AppServiceCubit, CommonState>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return CommonContainer(
//               horizontalPadding: 0,
//               showDetail: false,
//               showBackBotton: true,
//               showRoundBotton: false,
//               body: Column(
//                 children: [
//                   Container(
//                     height: _height * 0.6,
//                     child: ListView.builder(
//                       itemCount: filteredItems.length,
//                       itemBuilder: (context, index) {
//                         return Column(
//                           children: [
//                             CommonDetailBox(
//                               isNetworkImage: true,
//                               title: filteredItems[index].name,
//                               leadingImage:
//                                   "${RepositoryProvider.of<CoOperative>(context).baseUrl}${filteredItems[index].imageUrl}",
//                               onBoxPressed: () {
//                                 if (filteredItems[index]
//                                     .uniqueIdentifier
//                                     .toString()
//                                     .toLowerCase()
//                                     .contains("bank_transfer".toLowerCase())) {
//                                   NavigationService.pushNamed(
//                                       routeName: Routes.anyBank);
//                                 }
//                                 if (filteredItems[index]
//                                     .uniqueIdentifier
//                                     .toString()
//                                     .toLowerCase()
//                                     .contains("fund_transfer_dashboard"
//                                         .toLowerCase())) {
//                                   NavigationService.pushNamed(
//                                       routeName: Routes.internalCooperative);
//                                 } else if (filteredItems[index]
//                                         .uniqueIdentifier
//                                         .toString()
//                                         .toLowerCase() ==
//                                     "coop_transfer".toLowerCase()) {
//                                   NavigationService.pushNamed(
//                                       routeName: Routes.otherCooperative);
//                                 } else if (filteredItems[index]
//                                         .uniqueIdentifier
//                                         .toString()
//                                         .toLowerCase() ==
//                                     "load_wallet".toLowerCase()) {
//                                   NavigationService.pushNamed(
//                                       routeName: Routes.listWalletScreen);
//                                 }
//                                 // else {
//                                 //   NavigationService.pushNamed(
//                                 //       routeName: Routes.mobileTopup);
//                                 // }
//                               },
//                               detail: checkDesc(
//                                   filteredItems[index].uniqueIdentifier),
//                             ),
//                             const Divider(thickness: 1)
//                           ],
//                         );
//                       },
//                     ),
//                   )
//                 ],
//               ),
//               showTitleText: false,
//               topbarName: "Send Money");
//         },
//       ),
//     );
//   }

//   checkDesc(uniqueIdentifier) {
//     if (uniqueIdentifier
//         .toString()
//         .toLowerCase()
//         .contains("bank_transfer".toLowerCase())) {
//       return "Send Money to accounts maintained at different banks";
//     } else if (uniqueIdentifier
//         .toString()
//         .toLowerCase()
//         .contains("fund_transfer_dashboard".toLowerCase())) {
//       return "Send Money to accounts maintained at same cooperative";
//     } else if (uniqueIdentifier
//         .toString()
//         .toLowerCase()
//         .contains("coop_transfer".toLowerCase())) {
//       return "Send Money to accounts maintained at different cooperative";
//     } else if (uniqueIdentifier
//         .toString()
//         .toLowerCase()
//         .contains("load_wallet".toLowerCase())) {
//       return "Load Money to your Account";
//     } else {
//       return "";
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_container.dart';
import 'package:ismart_web/common/widget/common_detail_box.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/common/widget/show_loading_dialog.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/features/appServiceManagement/cubit/app_service_cubit.dart';
import 'package:ismart_web/features/appServiceManagement/model/app_service_management_model.dart';
import 'package:ismart_web/features/sendMoney/anyBank/screen/any_bank_page.dart';

class SendMoneyWidget extends StatefulWidget {
  const SendMoneyWidget({Key? key}) : super(key: key);

  @override
  State<SendMoneyWidget> createState() => _SendMoneyWidgetState();
}

class _SendMoneyWidgetState extends State<SendMoneyWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AppServiceCubit>().fetchAppService();
  }

  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final _height = SizeUtils.height;
    return PageWrapper(
      body: BlocConsumer<AppServiceCubit, CommonState>(
        listener: (context, state) {
          if (state is CommonLoading && !_isLoading) {
            _isLoading = true;
            showLoadingDialogBox(context);
          } else if (state is! CommonLoading && _isLoading) {
            _isLoading = false;
            NavigationService.pop();
          }

          if (state is CommonError) {
            showPopUpDialog(
              context: context,
              message: state.message,
              title: "Error",
              showCancelButton: false,
              buttonCallback: () {
                NavigationService.pop();
              },
            );
          }
        },
        builder: (context, state) {
          if (state is CommonDataFetchSuccess<AppServiceManagementModel>) {
            // final filteredItems =
            //     state.data
            //         .where(
            //           (item) =>
            //               item.type.toString().toLowerCase().contains(
            //                 "send".toLowerCase(),
            //               ) &&
            //               item.status.toLowerCase() == "Active".toLowerCase(),
            //         )
            //         .toList();
            final filteredItems =
                state.data
                    .where(
                      (item) =>
                          item.type.toString().toLowerCase().contains("send") &&
                          item.status.toLowerCase() == "active" &&
                          item.uniqueIdentifier.toLowerCase() !=
                              "load_wallet" &&
                          item.uniqueIdentifier.toLowerCase() !=
                              "fund_transfer_dashboard",
                    )
                    .toList();

            return CommonContainer(
              horizontalPadding: 0,
              showDetail: false,
              showBackBotton: true,
              showRoundBotton: false,
              body: Column(
                children: [
                  Container(
                    height: _height * 0.6,
                    child: ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            CommonDetailBox(
                              isNetworkImage: true,
                              title: filteredItems[index].name,
                              leadingImage:
                                  "${RepositoryProvider.of<CoOperative>(context).baseUrl}${filteredItems[index].imageUrl}",
                              onBoxPressed: () {
                                // checkNivigation(filteredItems[index].name);
                                if (filteredItems[index].uniqueIdentifier
                                    .toString()
                                    .toLowerCase()
                                    .contains("bank_transfer".toLowerCase())) {
                                  NavigationService.push(target: AnyBankpage());
                                }
                                if (filteredItems[index].uniqueIdentifier
                                    .toString()
                                    .toLowerCase()
                                    .contains(
                                      "fund_transfer_dashboard".toLowerCase(),
                                    )) {
                                  // NavigationService.pushNamed(
                                  //     routeName: Routes.internalCooperative);
                                } else if (filteredItems[index].uniqueIdentifier
                                        .toString()
                                        .toLowerCase() ==
                                    "coop_transfer".toLowerCase()) {
                                  // NavigationService.pushNamed(
                                  //     routeName: Routes.otherCooperative);
                                } else if (filteredItems[index].uniqueIdentifier
                                        .toString()
                                        .toLowerCase() ==
                                    "load_wallet".toLowerCase()) {
                                  // NavigationService.pushNamed(
                                  //     routeName: Routes.listWalletScreen);
                                }
                                // else {
                                //   NavigationService.pushNamed(
                                //       routeName: Routes.mobileTopup);
                                // }
                              },
                              detail: checkDesc(
                                filteredItems[index].uniqueIdentifier,
                              ),
                            ),
                            const Divider(thickness: 1),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
              showTitleText: false,
              topbarName: "Send Money",
            );
          } else if (state is CommonLoading) {
            return const CommonLoadingWidget();
          }
          // else {
          //   return const NoDataScreen(
          //     title: "Services unavailable now.",
          //     details:
          //         'Currently all our services seem to be under maintenance. We will update you as soon as our services get back to operation.',
          //   );
          // }

          return Container();
        },
      ),
    );
  }

  checkDesc(uniqueIdentifier) {
    if (uniqueIdentifier.toString().toLowerCase().contains(
      "bank_transfer".toLowerCase(),
    )) {
      return "Send Money to accounts maintained at different banks";
    } else if (uniqueIdentifier.toString().toLowerCase().contains(
      "fund_transfer_dashboard".toLowerCase(),
    )) {
      return "Send Money to accounts maintained at same cooperative";
    } else if (uniqueIdentifier.toString().toLowerCase().contains(
      "coop_transfer".toLowerCase(),
    )) {
      return "Send Money to accounts maintained at different cooperative";
    } else if (uniqueIdentifier.toString().toLowerCase().contains(
      "load_wallet".toLowerCase(),
    )) {
      return "Load Money to your Account";
    } else {
      return "";
    }
  }
}
