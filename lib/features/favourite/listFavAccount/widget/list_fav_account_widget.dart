import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/features/favourite/addAccount/screen/add_fav_account_page.dart';
import 'package:ismart_web/features/favourite/editAccount/screen/update_fav_account_page.dart';
import 'package:ismart_web/features/sendMoney/anyBank/screen/any_bank_page.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/internal_cooperative_page.dart';
import 'package:ismart_web/features/utility_payment/cubit/utility_payment_cubit.dart';
import 'package:ismart_web/features/utility_payment/models/utility_response_data.dart';

// ignore: must_be_immutable
class ListFavAccountWidget extends StatelessWidget {
  bool isBankTransfer = true;

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _textTheme = _theme.textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: Text(
                "Add Account",
                style: _textTheme.displaySmall!.copyWith(
                  fontSize: 12,
                  color: _theme.primaryColor,
                ),
              ),
              onPressed: () {
                NavigationService.push(target: const AddFavAccountPage());
              },
            ),
          ),
          BlocBuilder<UtilityPaymentCubit, CommonState>(
            builder: (context, state) {
              if (state is CommonStateSuccess<UtilityResponseData>) {
                final res = state.data.findValue(primaryKey: "data");

                if (res.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: res.length,
                    itemBuilder: (context, index) {
                      final bool isBankTransfer =
                          res[index]["serviceInfoType"].toString() ==
                                  "CONNECT_IPS"
                              ? true
                              : false;
                      return InkWell(
                        onTap: () {
                          isBankTransfer == true
                              ? NavigationService.push(
                                target: AnyBankpage(
                                  accountName:
                                      res[index]["data"]["destinationAccountName"],
                                  accountNumber:
                                      res[index]["data"]["destinationAccountNumber"],
                                  bankCode:
                                      res[index]["data"]["destinationBankCode"],
                                  bankName:
                                      res[index]["data"]["destinationBankName"],
                                ),
                              )
                              : NavigationService.push(
                                target: InternalCooperativePage(
                                  branchId:
                                      res[index]["data"]["destinationBankCode"],
                                  isFavAccount: true,
                                  branchName:
                                      res[index]["data"]["destinationBankName"],
                                  accountName:
                                      res[index]["data"]["destinationAccountName"],
                                  accountNumber:
                                      res[index]["data"]["destinationAccountNumber"],
                                  branchCode:
                                      res[index]["data"]["destinationBranchCode"],
                                ),
                              );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                            // color: _theme.primaryColor.withOpacity(0.1)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      res[index]["data"]["destinationAccountName"],
                                      style: _textTheme.labelLarge!.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      (isBankTransfer
                                              ? "Connect IPS "
                                              : "Fund Transfer ") +
                                          res[index]["data"]["destinationAccountNumber"],
                                      style: _textTheme.labelLarge!.copyWith(
                                        color: _theme.primaryColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      res[index]["data"]["destinationBankName"]
                                          .toString(),
                                      style: _textTheme.labelLarge!.copyWith(
                                        color: _theme.primaryColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  NavigationService.push(
                                    target: UpdateFavAccountPage(
                                      remainderType:
                                          res[index]["reminderType"].toString(),
                                      serviceInfoType:
                                          res[index]["serviceInfoType"]
                                              .toString(),
                                      id: res[index]["id"].toString(),
                                      isBankTransfer: isBankTransfer,
                                      accountName:
                                          res[index]["data"]["destinationAccountName"]
                                              .toString(),
                                      accountNumber:
                                          res[index]["data"]["destinationAccountNumber"],
                                      bankCode:
                                          res[index]["data"]["destinationBankCode"],
                                      bankName:
                                          res[index]["data"]["destinationBankName"],
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Icon(
                                    Icons.more_vert_outlined,
                                    size: 25.hp,
                                    color: _theme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const NoDataScreen(
                    showImage: true,
                    title: "No Account Found",
                    details:
                        "No favorite account found . Please try again later.",
                  );
                }
              }
              if (state is CommonLoading) {
                return const CommonLoadingWidget();
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
