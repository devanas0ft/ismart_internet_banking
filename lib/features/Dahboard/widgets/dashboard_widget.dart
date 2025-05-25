import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/screen/home_page.dart';
import 'package:ismart_web/features/banking/screen/banking_page.dart';
import 'package:ismart_web/features/customerDetail/cubit/customer_detail_cubit.dart';
import 'package:ismart_web/features/fundManagement/screens/fundmanagemt_page.dart';
import 'package:ismart_web/features/history/screen/recent_transaction_page.dart';
import 'package:ismart_web/features/history/screen/recent_transaction_service_page.dart';
import 'package:ismart_web/features/userAccount/widgets/user_account_widget.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    HomePage(),
    const UserAccountWidget(),
    const Bankingpage(),
    const FundmanagemtPage(),
    Center(child: Text('Paynment')),
    const RecentTransactionScreen(),
    Center(child: Text('Settings Page')),
  ];

  List<String> offerBanners = [];
  @override
  void initState() {
    super.initState();

    context.read<CustomerDetailCubit>().fetchCustomerDetail(
      isCalledAtStatup: true,
    );

    // offerBanners = RepositoryProvider.of<BannerRepository>(context).banners;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      showAppBar: true,
      showBackButton: false,
      bottomNavBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomTheme.white,
        elevation: 50,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          color: CustomTheme.darkGray.withAlpha(50),
        ),
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Icons.home : Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline,
            ),
            label: 'User Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? Icons.account_balance
                  : Icons.account_balance_outlined,
            ),
            label: 'Banking',
          ),

          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3
                  ? Icons.monetization_on
                  : Icons.monetization_on_outlined,
            ),
            label: 'Fund Management',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 4 ? Icons.payment : Icons.payment_outlined,
            ),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 5 ? Icons.history : Icons.history_outlined,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 5 ? Icons.settings : Icons.settings_outlined,
            ),
            label: 'Settings',
          ),
        ],
      ),

      body: _pages[_selectedIndex],
    );
  }
}
