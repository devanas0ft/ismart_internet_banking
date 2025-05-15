import 'package:flutter/material.dart';
import 'package:ismart_web/common/app/theme.dart';

class RecentActivityTable extends StatelessWidget {
  final List<Map<String, String>> data = [
    {
      "serviceName": "Internal Fund",
      "transferredTo": "001-001-GBK-0004567",
      "through": "Chq# 0 0518163707969801130007",
      "amount": "-NPR 1621.20",
    },
    {
      "serviceName": "Internal Fund",
      "transferredTo": "001-001-GBK-0004567",
      "through": "Chq# 0 0518163707969801130007",
      "amount": "-NPR 1621.20",
    },
    {
      "serviceName": "Internal Fund",
      "transferredTo": "001-001-GBK-0004567",
      "through": "Chq# 0 0518163707969801130007",
      "amount": "-NPR 1621.20",
    },
    {
      "serviceName": "Internal Fund",
      "transferredTo": "001-001-GBK-0004567",
      "through": "Chq# 0 0518163707969801130007",
      "amount": "NPR 1621.20",
    },
    {
      "serviceName": "Internal Fund",
      "transferredTo": "001-001-GBK-0004567",
      "through": "Chq# 0 0518163707969801130007",
      "amount": "NPR 1621.20",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomTheme.white,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Activity',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomTheme.darkGray,
              ),
            ),
          ),
          Container(
            color: Colors.blue.shade50,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Service Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Transferred to/from',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Through',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Amount',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SizedBox(
            height: 300,
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          item['serviceName'] ?? '',
                          style: TextStyle(
                            fontSize: 10,

                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(item['transferredTo'] ?? ''),
                      ),
                      Expanded(flex: 2, child: Text(item['through'] ?? '')),
                      Expanded(
                        flex: 1,
                        child: Text(
                          item['amount'] ?? '',
                          style: TextStyle(
                            color:
                                item['amount']?.startsWith('-') ?? false
                                    ? Colors.red
                                    : Colors.green,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
