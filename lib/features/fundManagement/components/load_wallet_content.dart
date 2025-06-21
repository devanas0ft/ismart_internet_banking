import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/navigation_service.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/bloc/data_state.dart';
import 'package:ismart_web/common/models/coop_config.dart';
import 'package:ismart_web/common/utils/form_validator.dart';
import 'package:ismart_web/common/utils/responsive.dart';
import 'package:ismart_web/common/utils/size_utils.dart';
import 'package:ismart_web/common/utils/snack_bar_utils.dart';
import 'package:ismart_web/common/widget/common_loading_widget.dart';
import 'package:ismart_web/common/widget/custom_cached_network_image.dart';
import 'package:ismart_web/common/widget/custom_text_field.dart';
import 'package:ismart_web/common/widget/no_data_screen.dart';
import 'package:ismart_web/common/widget/primary_account_box.dart';
import 'package:ismart_web/common/widget/show_pop_up_dialog.dart';
import 'package:ismart_web/common/widget/transactipon_pin_screen.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_list_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_send_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/cubit/wallet_validate_cubit.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/model/wallet_model.dart';
import 'package:ismart_web/features/sendMoney/wallet_transfer/model/wallet_validation_model.dart';

class LoadWalletContent extends StatefulWidget {
  const LoadWalletContent({super.key});

  @override
  State<LoadWalletContent> createState() => _LoadWalletContentState();
}

class _LoadWalletContentState extends State<LoadWalletContent> {
  int? _selectedAmount;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _walletAccountController =
      TextEditingController();
  String _currentAmount = '';
  final TextEditingController _remarksController = TextEditingController();
  int? selectedWalletIndex;
  late WalletModel wallet1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _selectAmount(int amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

  String iconUrl(String param) {
    return "${RepositoryProvider.of<CoOperative>(context).baseUrl}ismart/serviceIcon/$param";
  }

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return Form(
        key: _formKey,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildListWallet()),
            VerticalDivider(width: 8.w),
            Expanded(child: _buildAccountSection()),
            VerticalDivider(width: 8.w),
            Expanded(child: _buildRemarksSection()),
          ],
        ),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildListWallet(),
          const SizedBox(height: 20),
          _buildAccountSection(),
          const SizedBox(height: 20),
          _buildRemarksSection(),
        ],
      );
    }
  }

  Widget _buildListWallet() {
    return BlocBuilder<WalletListCubit, CommonState>(
      builder: (context, state) {
        if (state is CommonStateSuccess<WalletValidationModel>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.data.status.toLowerCase() == "success" ||
                state.data.message.toLowerCase() ==
                    "validation not available") {
              final WalletValidationModel? _myValidationResult = state.data;

              // _isAccountValidated = true;
              // _validationResult = state.data;
              showPopUpDialog(
                context: context,
                message:
                    "Wallet ID Validated successfully. Do you want to continue transfer?",
                title: "Confirm",
                buttonCallback: () {
                  NavigationService.pop();
                  NavigationService.push(
                    target: TransactionPinScreen(
                      onValueCallback: (p0) {
                        NavigationService.pop();
                        context.read<WalletSendCubit>().sendToWallet(
                          mPin: p0,
                          remarks: _remarksController.text,
                          walletId: wallet1.id.toString(),
                          amount: _amountController.text,
                          customerName: _walletAccountController.text,
                          walletAccountNumber: _walletAccountController.text,
                          validationIdentifier:
                              _myValidationResult?.validationIdentifier ?? "",
                        );
                      },
                    ),
                  );
                },
              );
              // _isAccountValidated = false;

              // _validationResult = null;
            } else {
              SnackBarUtils.showErrorBar(
                context: context,
                message: state.data.message,
              );
            }
          });
        }
        if (state is CommonDataFetchSuccess<WalletModel>) {
          final List<WalletModel> walletsList = state.data;
          if (selectedWalletIndex == null && walletsList.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                wallet1 = walletsList[0];
                selectedWalletIndex = 0;
              });
            });
          }
          return SizedBox(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: walletsList.length,
              itemBuilder: (BuildContext context, int index) {
                final wallet = walletsList[index];
                final isSelected = selectedWalletIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedWalletIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue.shade50 : Colors.white,
                      border: Border.all(
                        color:
                            isSelected
                                ? CustomTheme.primaryColor
                                : Colors.grey.shade300,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),

                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CustomCachedNetworkImage(
                            url: iconUrl(wallet.icon),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        wallet.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected
                                  ? CustomTheme.primaryColor
                                  : Colors.black87,
                        ),
                      ),
                      trailing:
                          isSelected
                              ? Icon(
                                Icons.check_circle,
                                color: CustomTheme.primaryColor,
                              )
                              : null,
                    ),
                  ),
                );
              },
            ),
          );
        } else if (state is CommonError) {
          return const NoDataScreen(title: "No Wallet Found", details: "");
        }
        return CommonLoadingWidget();
      },
    );
  }

  Widget _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Account',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        PrimaryAccountBox(validateMobileBankingStatus: true),
        const SizedBox(height: 8),
        const Text(
          'Wallet ID',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          // title: "Wallet Id",
          hintText: "9856654121",
          controller: _walletAccountController,
          validator:
              (val) => FormValidator.validateFieldNotEmpty(val, "Wallet Id"),
          showSearchIcon: true,
          showSuffixImage: false,

          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            TextInputFormatter.withFunction((oldValue, newValue) {
              final String newText = newValue.text
                  .replaceAll('+977', '')
                  .replaceAll('-', '');
              return TextEditingValue(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length),
              );
            }),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Amount',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          // title: "Amount",
          hintText: "Enter the amount",
          onChanged: (value) {
            setState(() {
              _currentAmount = value;
            });
          },
          controller: _amountController,
          validator:
              (value) => FormValidator.validateAmount(
                val: value.toString(),
                minAmount: wallet1.minAmount,
                maxAmount: wallet1.maxAmount,
              ),
          textInputType: TextInputType.number,
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _buildAmountButton(10),
            _buildAmountButton(20),
            _buildAmountButton(50),
            _buildAmountButton(500),
            _buildAmountButton(1000),
            _buildAmountButton(2000),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountButton(int amount) {
    final isSelected = _selectedAmount == amount;
    return GestureDetector(
      onTap: () => _selectAmount(amount),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? CustomTheme.primaryColor : Colors.transparent,
          border: Border.all(
            color:
                isSelected ? CustomTheme.primaryColor : const Color(0xFFE0E0E0),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          amount.toString(),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildRemarksSection() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.topLeft,
          child: const Text(
            'Remarks',
            style: TextStyle(fontSize: 12, color: Color(0xFF666666)),
          ),
        ),
        const SizedBox(height: 8),
        CustomTextField(
          hintText: "Remarks",
          controller: _remarksController..text,
          validator:
              (val) => FormValidator.validateFieldNotEmpty(val, "Remarks"),
          maxLine: 8,
        ),
        const SizedBox(height: 15),
        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  side: const BorderSide(color: Color(0xFFE0E0E0)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (true) {
                    if (_formKey.currentState!.validate()) {
                      context.read<WalletValidationCubit>().validateWallet(
                        walletId: wallet1.id.toString(),
                        accountNumber: _walletAccountController.text,
                        amount: _amountController.text,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
