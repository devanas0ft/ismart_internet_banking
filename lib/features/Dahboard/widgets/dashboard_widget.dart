import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('Dashboard')),
    Center(child: Text('Dashboard')),
    Center(child: Text('Account')),
    Center(child: Text('Fund Management')),
    Center(child: Text('Paynment')),
    Center(child: Text('Settings Page')),
    Center(child: Text('Dashboard')),
  ];

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
          const BottomNavigationBarItem(icon: SizedBox(width: 20), label: ''),
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 1 ? Icons.home : Icons.home_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2
                  ? Icons.account_balance
                  : Icons.account_balance_outlined,
            ),
            label: 'Account',
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
              _selectedIndex == 5 ? Icons.settings : Icons.settings_outlined,
            ),
            label: 'Settings',
          ),
          const BottomNavigationBarItem(icon: SizedBox(width: 20), label: ''),
        ],
      ),

      body: _pages[_selectedIndex],
    );
  }
}
