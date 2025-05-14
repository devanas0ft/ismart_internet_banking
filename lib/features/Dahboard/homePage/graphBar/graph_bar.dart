import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TransactionSummaryScreen extends StatefulWidget {
  const TransactionSummaryScreen({super.key});

  @override
  State<TransactionSummaryScreen> createState() =>
      _TransactionSummaryScreenState();
}

class _TransactionSummaryScreenState extends State<TransactionSummaryScreen> {
  // Toggle between weekly and monthly view
  bool isMonthlyView = true;

  // Sample data for monthly view (amount spent per day)
  final List<double> monthlyData = [
    320.0,
    180.0,
    420.0,
    290.0,
    340.0,
    260.0,
    340.0,
    180.0,
    430.0,
    290.0,
    330.0,
    180.0,
    220.0,
    310.0,
    250.0,
    370.0,
    290.0,
    180.0,
    420.0,
    310.0,
    230.0,
    280.0,
    350.0,
    270.0,
    190.0,
    240.0,
    300.0,
    360.0,
    410.0,
    290.0,
  ];

  // Sample data for weekly view (amount spent per day of week)
  final List<double> weeklyData = [
    420.0, // Monday
    310.0, // Tuesday
    380.0, // Wednesday
    290.0, // Thursday
    450.0, // Friday
    270.0, // Saturday
    190.0, // Sunday
  ];

  // Day labels for weekly view
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(color: Colors.blue.withOpacity(0.5), width: 1),
        ),
        height: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Transaction Summary',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Toggle button in the same row as title
                Row(
                  children: [
                    const Text('Show: '),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isMonthlyView = !isMonthlyView;
                        });
                      },
                      child: Text(
                        isMonthlyView ? 'Monthly' : 'Weekly',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _BalanceCard(
                  title: 'Opening Balance',
                  amount: 'NRS 2093876729',
                ),
                _BalanceCard(
                  title: 'Closing Balance',
                  amount: 'NRS 875823582389',
                ),
                const SizedBox(
                  width: 80,
                ), // Space for the toggle that's now at the top
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 500, // Adjust max Y value to better fit the data
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor: Colors.blueGrey.shade50,
                      tooltipPadding: const EdgeInsets.all(8),
                      tooltipMargin: 8,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        String amount = rod.toY.round().toString();
                        String day =
                            isMonthlyView
                                ? '${groupIndex + 1}'
                                : weekDays[groupIndex];
                        return BarTooltipItem(
                          '$day: NRS $amount',
                          const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 100,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox.shrink();
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          String text =
                              isMonthlyView
                                  ? '${value.toInt() + 1}'
                                  : weekDays[value.toInt()];

                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        },
                        reservedSize: 20,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                      left: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 100,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey.shade200,
                        strokeWidth: 1,
                      );
                    },
                    drawVerticalLine: false,
                  ),
                  barGroups: _generateBarGroups(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    final List<double> data =
        isMonthlyView
            ? monthlyData.sublist(0, 12) // Use first 12 days for monthly view
            : weeklyData;

    final int dataCount = data.length;

    return List.generate(dataCount, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: data[i],
            color: i % 2 == 0 ? Colors.indigo.shade900 : Colors.blue.shade700,
            width: 16,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
        showingTooltipIndicators: [],
      );
    });
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final String amount;

  const _BalanceCard({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.18,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0FC),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
