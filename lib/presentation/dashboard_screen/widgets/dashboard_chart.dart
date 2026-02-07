import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import '../model/chart_stats_model.dart';

enum ChartType { line, bar, pie }

class DashboardChart extends StatefulWidget {
  final List<ChartData> data;
  final String title;
  final ChartType initialType;

  const DashboardChart({
    super.key,
    required this.data,
    this.title = "Statistics",
    this.initialType = ChartType.bar,
  });

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  late ChartType _selectedType;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.initialType;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: PMT.appStyle(
                size: 18,
                fontWeight: FontWeight.w700,
                fontColor: Colors.black87,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: DropdownButton<ChartType>(
                value: _selectedType,
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(
                    value: ChartType.bar,
                    child: Text("Bar Chart"),
                  ),
                  DropdownMenuItem(
                    value: ChartType.line,
                    child: Text("Line Chart"),
                  ),
                  DropdownMenuItem(
                    value: ChartType.pie,
                    child: Text("Pie Chart"),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedType = value;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          height: 320,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: _buildChart(),
        ),
        const SizedBox(height: 10),
        _buildLegend(),
      ],
    );
  }

  Widget _buildChart() {
    switch (_selectedType) {
      case ChartType.line:
        return _buildLineChart();
      case ChartType.bar:
        return _buildBarChart();
      case ChartType.pie:
        return _buildPieChart();
    }
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final flSpot = barSpot;
                return LineTooltipItem(
                  '${barSpot.barIndex == 0 ? "Income" : "Expense"}: ₹${flSpot.y.toInt()}',
                  const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
        gridData: const FlGridData(show: true, drawVerticalLine: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= widget.data.length)
                  return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.data[index].monthName?.split(" ").first ?? "",
                    style: PMT.appStyle(size: 10, fontColor: Colors.grey),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${(value / 1000).toStringAsFixed(0)}k',
                  style: PMT.appStyle(size: 10, fontColor: Colors.grey),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: widget.data
                .asMap()
                .entries
                .map((e) =>
                    FlSpot(e.key.toDouble(), (e.value.income ?? 0).toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.green,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData:
                BarAreaData(show: true, color: Colors.green.withOpacity(0.1)),
          ),
          LineChartBarData(
            spots: widget.data
                .asMap()
                .entries
                .map((e) =>
                    FlSpot(e.key.toDouble(), (e.value.expense ?? 0).toDouble()))
                .toList(),
            isCurved: true,
            color: Colors.red,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData:
                BarAreaData(show: true, color: Colors.red.withOpacity(0.1)),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipPadding: EdgeInsets.zero,
            tooltipMargin: 8,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '₹${rod.toY.toInt()}',
                TextStyle(
                  color: rod.color,
                  fontWeight: FontWeight.bold,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index < 0 || index >= widget.data.length)
                  return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.data[index].monthName?.split(" ").first ?? "",
                    style: PMT.appStyle(size: 10, fontColor: Colors.grey),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                return Text(
                  '₹${(value / 1000).toStringAsFixed(0)}k',
                  style: PMT.appStyle(size: 10, fontColor: Colors.grey),
                );
              },
            ),
          ),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: widget.data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            showingTooltipIndicators: [0, 1],
            barRods: [
              BarChartRodData(
                toY: (e.value.income ?? 0).toDouble(),
                color: Colors.green,
                width: 12,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              ),
              BarChartRodData(
                toY: (e.value.expense ?? 0).toDouble(),
                color: Colors.red,
                width: 12,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6), topRight: Radius.circular(6)),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart() {
    final latestData = widget.data.last;
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (FlTouchEvent event, pieTouchResponse) {
            // Handle touch if needed
          },
        ),
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            value: (latestData.income ?? 0).toDouble(),
            title: '₹${latestData.income}',
            color: Colors.green,
            radius: 60,
            titleStyle: PMT.appStyle(
                size: 12, fontWeight: FontWeight.bold, fontColor: Colors.white),
          ),
          PieChartSectionData(
            value: (latestData.expense ?? 0).toDouble(),
            title: '₹${latestData.expense}',
            color: Colors.red,
            radius: 60,
            titleStyle: PMT.appStyle(
                size: 12, fontWeight: FontWeight.bold, fontColor: Colors.white),
          ),
          PieChartSectionData(
            value: (latestData.profit ?? 0).toDouble(),
            title: '₹${latestData.profit}',
            color: Colors.blue,
            radius: 60,
            titleStyle: PMT.appStyle(
                size: 12, fontWeight: FontWeight.bold, fontColor: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Wrap(
      spacing: 20,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: [
        _legendItem("Income", Colors.green),
        _legendItem("Expense", Colors.red),
        if (_selectedType == ChartType.pie) _legendItem("Profit", Colors.blue),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: PMT.appStyle(size: 12, fontColor: Colors.black54),
        ),
      ],
    );
  }
}
