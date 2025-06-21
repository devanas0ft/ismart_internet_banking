import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/common/widget/page_wrapper.dart';
import 'package:ismart_web/features/Dahboard/homePage/screen/home_page.dart';
import 'package:ismart_web/features/banking/screen/banking_page.dart';
import 'package:ismart_web/features/favourite/listFavAccount/widget/fav_section.dart';
import 'package:ismart_web/features/fundManagement/screens/fundmanagemt_page.dart';
import 'package:ismart_web/features/more/screen/more_page.dart';
import 'package:ismart_web/features/userAccount/Screens/user_account_page.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({super.key});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const UserAccountPage(),
    const Bankingpage(),
    const FundmanagemtPage(),
    const FavSection(),
    const MorePage(),
  ];

  List<String> offerBanners = [];
  @override
  void initState() {
    super.initState();
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
      backgroundColor: Color(0xFFd9d9d9),
      bottomNavBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: CustomTheme.white,
        elevation: 50,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          color: CustomTheme.darkGray.withAlpha(120),
        ),
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              'assets/icons/navbar/dashboard.svg',
              colorFilter: ColorFilter.mode(
                _selectedIndex == 0
                    ? CustomTheme.primaryColor
                    : CustomTheme.darkGray.withAlpha(120),
                BlendMode.srcIn,
              ),
            ),

            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              'assets/icons/navbar/user.svg',
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1
                    ? CustomTheme.primaryColor
                    : CustomTheme.darkGray.withAlpha(120),
                BlendMode.srcIn,
              ),
            ),
            label: 'User Account',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              'assets/icons/navbar/banking.svg',
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2
                    ? CustomTheme.primaryColor
                    : CustomTheme.darkGray.withAlpha(120),
                BlendMode.srcIn,
              ),
            ),
            label: 'Banking',
          ),

          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              'assets/icons/navbar/payment.svg',
              colorFilter: ColorFilter.mode(
                _selectedIndex == 3
                    ? CustomTheme.primaryColor
                    : CustomTheme.darkGray.withAlpha(120),
                BlendMode.srcIn,
              ),
            ),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              'assets/icons/navbar/favourite.svg',
              colorFilter: ColorFilter.mode(
                _selectedIndex == 4
                    ? CustomTheme.primaryColor
                    : CustomTheme.darkGray.withAlpha(120),
                BlendMode.srcIn,
              ),
            ),
            label: 'Favourite',
          ),

          // BottomNavigationBarItem(
          //   icon: SvgPicture.asset(
          //     height: 24,
          //     'assets/icons/navbar/history.svg',
          //     colorFilter: ColorFilter.mode(
          //       _selectedIndex == 5
          //           ? CustomTheme.primaryColor
          //           : CustomTheme.darkGray.withAlpha(120),
          //       BlendMode.srcIn,
          //     ),
          //   ),
          //   label: 'History',
          // ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              height: 24,
              'assets/icons/navbar/more.svg',
              colorFilter: ColorFilter.mode(
                _selectedIndex == 6
                    ? CustomTheme.primaryColor
                    : CustomTheme.darkGray.withAlpha(120),
                BlendMode.srcIn,
              ),
            ),
            label: 'More',
          ),
        ],
      ),

      body: _pages[_selectedIndex],
    );
  }
}
