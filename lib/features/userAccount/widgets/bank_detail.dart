import 'package:flutter/material.dart';
import 'package:ismart_web/features/customerDetail/model/customer_detail_model.dart';
import 'package:ismart_web/features/userAccount/widgets/each_bank_helper.dart';

class BankDetail extends StatefulWidget {
  final AccountDetail? accountDetail;
  const BankDetail({super.key, this.accountDetail});

  @override
  State<BankDetail> createState() => _BankDetailState();
}

class _BankDetailState extends State<BankDetail> {
  bool moBank = false;
  bool isSMS = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 768 && size.width <= 1024;
    final isMobile = size.width <= 768;
    final isSmallMobile = size.width <= 480;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isSmallMobile) {
          return _buildSmallMobileLayout(context);
        } else if (isMobile) {
          return _buildMobileLayout(context);
        } else if (isTablet) {
          return _buildTabletLayout(context);
        } else {
          return _buildDesktopLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _buildAccountInfoColumn()),
        SizedBox(width: 40),
        Expanded(flex: 1, child: _buildBalanceColumn()),
        SizedBox(width: 40),
        Expanded(flex: 1, child: _buildInterestColumn()),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              ..._buildAccountInfoItems(),
              SizedBox(height: 20),
              ..._buildInterestItems(),
            ],
          ),
        ),
        SizedBox(width: 32),
        Expanded(flex: 1, child: _buildBalanceColumn()),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Account Information'),
        ..._buildAccountInfoItems(),
        SizedBox(height: 24),
        _buildSectionTitle('Balance Information'),
        ..._buildBalanceItems(),
        SizedBox(height: 24),
        _buildSectionTitle('Interest Information'),
        ..._buildInterestItems(),
      ],
    );
  }

  Widget _buildSmallMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompactSection('Account Information', [
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/branch name.svg',
            'Branch Name',
            widget.accountDetail?.branchName ?? 'Not Available',
          ),
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/branch code.svg',
            'Branch Code',
            widget.accountDetail?.branchCode ?? 'Not Available',
          ),
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/account no.svg',
            'Account Number',
            widget.accountDetail?.accountNumber ?? 'Not Available',
          ),
        ]),
        SizedBox(height: 20),
        _buildCompactSection('Balance Information', [
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/actual balance.svg',
            'Actual Balance',
            widget.accountDetail?.actualBalance ?? 'Not Available',
          ),
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/available balance.svg',
            'Available Balance',
            widget.accountDetail?.availableBalance ?? 'Not Available',
          ),
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/available balance.svg',
            'Minimum Balance',
            widget.accountDetail?.minimumBalance ?? 'Not Available',
          ),
        ]),
        SizedBox(height: 20),
        _buildCompactSection('Interest Information', [
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/interest accured.svg',
            'Interest Accrued',
            widget.accountDetail?.accruedInterest ?? 'Not Available',
          ),
          _buildCompactBankDetail(
            'assets/icons/user_account/bank_details/interest rate.svg',
            'Interest Rate',
            widget.accountDetail?.interestRate ?? 'Not Available',
          ),
        ]),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xff010c80),
        ),
      ),
    );
  }

  Widget _buildCompactSection(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff010c80),
            ),
          ),
          SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCompactBankDetail(String iconPath, String title, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xff010c80).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              Icons.account_balance, // Fallback icon since SVG might not load
              size: 16,
              color: Color(0xff010c80),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildAccountInfoItems(),
    );
  }

  Widget _buildBalanceColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildBalanceItems(),
    );
  }

  Widget _buildInterestColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildInterestItems(),
    );
  }

  List<Widget> _buildAccountInfoItems() {
    return [
      EachBankHelper(
        'assets/icons/user_account/bank_details/branch name.svg',
        'Branch Name',
        Text(
          widget.accountDetail?.branchName ?? 'Not Available',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
      EachBankHelper(
        'assets/icons/user_account/bank_details/branch code.svg',
        'Branch Code',
        Text(
          widget.accountDetail?.branchCode ?? 'Not Available',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
      EachBankHelper(
        'assets/icons/user_account/bank_details/account no.svg',
        'Account Number',
        Text(
          widget.accountDetail?.accountNumber ?? 'Not Available',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ),
    ];
  }

  List<Widget> _buildBalanceItems() {
    return [
      EachBankHelper(
        'assets/icons/user_account/bank_details/actual balance.svg',
        'Actual Balance',
        Text(
          _formatBalance(widget.accountDetail?.actualBalance),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      EachBankHelper(
        'assets/icons/user_account/bank_details/available balance.svg',
        'Available Balance',
        Text(
          _formatBalance(widget.accountDetail?.availableBalance),
          style: TextStyle(
            fontSize: 16,
            color: Colors.green[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      EachBankHelper(
        'assets/icons/user_account/bank_details/available balance.svg',
        'Minimum Balance Required',
        Text(
          _formatBalance(widget.accountDetail?.minimumBalance),
          style: TextStyle(
            fontSize: 16,
            color: Colors.orange[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildInterestItems() {
    return [
      EachBankHelper(
        'assets/icons/user_account/bank_details/interest accured.svg',
        'Interest Accrued',
        Text(
          _formatBalance(widget.accountDetail?.accruedInterest),
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      EachBankHelper(
        'assets/icons/user_account/bank_details/interest rate.svg',
        'Interest Rate',
        Text(
          _formatInterestRate(widget.accountDetail?.interestRate),
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ];
  }

  String _formatBalance(String? balance) {
    if (balance == null || balance.isEmpty) return 'Not Available';
    try {
      final double amount = double.parse(balance.replaceAll(',', ''));
      return 'Rs. ${amount.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
    } catch (e) {
      return balance;
    }
  }

  String _formatInterestRate(String? rate) {
    if (rate == null || rate.isEmpty) return 'Not Available';
    if (!rate.contains('%')) {
      return '$rate%';
    }
    return rate;
  }
}
