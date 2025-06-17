import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/features/Dahboard/homePage/widget/full_statement_homepage/screens/full_statemenent_home_page.dart';
import 'package:ismart_web/features/Dahboard/homePage/widget/recent_transaction_actual_widget.dart';

class RecentActivityTable extends StatefulWidget {
  const RecentActivityTable({super.key});
  @override
  State<RecentActivityTable> createState() => _RecentActivityTableState();
}

class _RecentActivityTableState extends State<RecentActivityTable> {
  int activeIndex = 0;
  final List<String> _tabs = ['Full Statement', 'Recent Activity'];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomTheme.white,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,

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
                          activeIndex = index;
                        });
                      },
                      child: _buildTab(title, activeIndex == index),
                    ),
                  );
                }),
                Spacer(),
              ],
            ),
          ),
          Divider(height: 1),
          const SizedBox(height: 0),
          if (activeIndex == 0) FullStatemenentHomePage(),
          if (activeIndex == 1) RecentTransactionActualWidget(),
        ],
      ),
    );
  }

  Widget _buildTab(String title, bool isActive) {
    return Container(
      padding: const EdgeInsets.only(right: 12.0, left: 12, top: 12, bottom: 8),
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
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isActive ? const Color(0xFF1E3A8A) : const Color(0xFF666666),
        ),
      ),
    );
  }
}
