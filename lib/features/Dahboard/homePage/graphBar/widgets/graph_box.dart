import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ismart_web/common/app/theme.dart';
import 'package:ismart_web/features/Dahboard/homePage/graphBar/widgets/balance_card.dart';

class GraphBox extends StatefulWidget {
  final String openingBalance;
  final String closingBalance;

  final List<double> monthlyData;
  const GraphBox({
    super.key,
    required this.monthlyData,
    required this.closingBalance,
    required this.openingBalance,
  });

  @override
  State<GraphBox> createState() => _GraphBoxState();
}

class _GraphBoxState extends State<GraphBox> {
  final bool isMonthlyView = true;
  bool showFullMonth = false;

  getMaxValue() {
    final val = widget.monthlyData.reduce((a, b) => a > b ? a : b);
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      height: 330,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaction Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CustomTheme.darkGray,
                  // fontFamily: 'poppins',
                ),
              ),
              Row(
                children: [
                  const Text('Show: '),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showFullMonth = !showFullMonth;
                      });
                    },
                    child: Text(
                      showFullMonth ? 'Full Monthly' : 'Compact View',
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
              BalanceCard(
                title: 'Opening Balance',
                amount: 'NRS ${widget.openingBalance}',
              ),
              BalanceCard(
                title: 'Closing Balance',
                amount: 'NRS ${widget.closingBalance}',
              ),
              const SizedBox(width: 80),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 500 > getMaxValue() ? 500 : getMaxValue(),
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.all(8),
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String amount = rod.toY.round().toString();
                      String day =
                          isMonthlyView ? '${groupIndex + 1}' : "week days";
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
                      interval: 500 > getMaxValue() ? 100 : getMaxValue() / 5,
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
                            isMonthlyView ? '${value.toInt() + 1}' : 'Weekdays';

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
                    return FlLine(color: Colors.grey.shade200, strokeWidth: 1);
                  },
                  drawVerticalLine: false,
                ),
                barGroups: _generateBarGroups(
                  showFullMonth
                      ? widget.monthlyData
                      : widget.monthlyData.sublist(0, 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(List<double> data) {
    return List.generate(data.length, (i) {
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
