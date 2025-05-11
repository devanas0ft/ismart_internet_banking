import 'package:flutter/material.dart';
import 'package:ismart_web/features/Dahboard/homePage/homePageTabbar/screen/category_page.dart';

class HomePageTabbarWidget extends StatefulWidget {
  const HomePageTabbarWidget({Key? key}) : super(key: key);

  @override
  State<HomePageTabbarWidget> createState() => _HomePageTabbarWidgetState();
}

class _HomePageTabbarWidgetState extends State<HomePageTabbarWidget> {
  int _selectedIndex = 0;
  static final List<String> tabTitle = [
    "Instant Payments",
    "Graph & Activities",
    "Favorite",
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              tabTitle.length,
              (index) => InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Text(
                    tabTitle[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          _selectedIndex == index
                              ? Colors.black
                              : Colors.black54,
                      fontSize: _selectedIndex == index ? 14 : 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_selectedIndex == 0) const CategoryPage(showAllServices: false),
        // if (_selectedIndex == 1) const GraphPage(),
        // if (_selectedIndex == 2) ListFavAccountPage(),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}


// import 'package:flutter/material.dart';

// import 'package:ismart/feature/dashboard/homePage/homePageTabbar/servicesTab/screen/category_page.dart';
// import 'package:ismart/feature/favorite/listFavAccount/screen/list_fav_account_page.dart';
// import 'package:ismart/feature/graph/ui/screen/graph_page.dart';

// import 'package:ismart/feature/graph/ui/widget/graph_widget.dart';

// class HomePageTabbarWidget extends StatelessWidget {
//   const HomePageTabbarWidget({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       initialIndex: 0,
//       length: 3,
//       child: Column(
//         children: const [
//           TabBar(
//             isScrollable: true,
//             labelColor: Colors.black,
//             unselectedLabelColor: Color(0xFF989898),
//             labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//             indicatorColor: Colors.transparent,
//             automaticIndicatorColorAdjustment: true,
//             tabs: [
//               Tab(text: "Instant Payments"),
//               Tab(text: "Graph & Activities"),
//               Tab(text: "Favorite"),
//             ],
//           ),
//           Expanded(
//             child: TabBarView(
//               children: [
//                 CategoryPage(
//                   showAllServices: false,
//                 ),
//                 GraphPage(),
//                 ListFavAccountPage(),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }