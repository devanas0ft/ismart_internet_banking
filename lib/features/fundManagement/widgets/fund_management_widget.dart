import 'package:flutter/material.dart';
import 'package:ismart_web/features/fundManagement/components/load_wallet_providers.dart';
import 'package:ismart_web/features/sendMoney/internalCooperative/screen/internal_cooperative_page.dart';

class FundManagementWidget extends StatefulWidget {
  const FundManagementWidget({super.key});

  @override
  State<FundManagementWidget> createState() => _FundManagementWidgetState();
}

class _FundManagementWidgetState extends State<FundManagementWidget> {
  final TextEditingController _walletIdController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  int _selectedTabIndex = 0;
  int? selectedWalletIndex;
  final List<String> _tabs = ['LOAD WALLET', 'LOAD FUND'];

  @override
  void dispose() {
    _walletIdController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Row(
              children: [
                ..._tabs.asMap().entries.map((entry) {
                  int index = entry.key;
                  String title = entry.value;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: _buildTab(title, _selectedTabIndex == index),
                    ),
                  );
                }),
                Spacer(),
              ],
            ),
          ),
          Divider(height: 1),
          const SizedBox(height: 30),
          if (_selectedTabIndex == 0) LoadWalletPageProviders(),
          if (_selectedTabIndex == 1) InternalCooperativePage(),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? const Color(0xFF1E3A8A) : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isActive ? const Color(0xFF1E3A8A) : const Color(0xFF666666),
        ),
      ),
    );
  }
}
