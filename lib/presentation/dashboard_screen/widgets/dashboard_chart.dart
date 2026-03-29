import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pg_managment/core/utils/app_fonts.dart';
import 'package:pg_managment/core/utils/color_constant.dart';
import '../model/chart_stats_model.dart';

enum ChartType { line, bar, pie }

/// Which value from [ChartData] this chart displays (income vs expense only).
enum ChartMetric { income, expense }

class DashboardChart extends StatefulWidget {
  final List<ChartData> data;
  final String title;
  final ChartType initialType;
  final ChartMetric metric;

  const DashboardChart({
    super.key,
    required this.data,
    required this.metric,
    this.title = "Statistics",
    this.initialType = ChartType.bar,
  });

  @override
  State<DashboardChart> createState() => _DashboardChartState();
}

class _DashboardChartState extends State<DashboardChart> {
  late ChartType _selectedType;

  int _valueFor(ChartData d) =>
      widget.metric == ChartMetric.income ? (d.income ?? 0) : (d.expense ?? 0);

  String get _metricLabel =>
      widget.metric == ChartMetric.income ? 'Income' : 'Expense';

  Color get _metricColor => widget.metric == ChartMetric.income
      ? const Color(0xFF0F766E)
      : const Color(0xFFC2410C);

  Color get _metricLightSurface => widget.metric == ChartMetric.income
      ? const Color(0xFFCCFBF1)
      : const Color(0xFFFFEDD5);

  int get _periodTotal =>
      widget.data.fold(0, (sum, d) => sum + _valueFor(d));

  /// Headroom above max value so bars/lines do not touch the top edge.
  double _maxYAxis() {
    double maxVal = 0;
    for (final d in widget.data) {
      final v = _valueFor(d).toDouble();
      if (v > maxVal) maxVal = v;
    }
    if (maxVal <= 0) return 100;
    final padded = maxVal * 1.18;
    final exp = (math.log(padded) / math.ln10).floor();
    final step = math.pow(10.0, math.max(0, exp - 1)).toDouble();
    return ((padded / step).ceil() * step).toDouble();
  }

  String _formatAxisRupee(double value) {
    final v = value.abs();
    if (v >= 10000000) return '${(v / 10000000).toStringAsFixed(1)}Cr';
    if (v >= 100000) return '${(v / 100000).toStringAsFixed(1)}L';
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}k';
    return v.toInt().toString();
  }

  String _formatTooltipRupee(double value) {
    final n = value.round();
    final sign = n < 0 ? '-' : '';
    final abs = n.abs();
    final s = abs.toString();
    if (s.length <= 3) return '$sign₹$abs';
    final parts = <String>[];
    var i = s.length;
    parts.add(s.substring(i - 3, i));
    i -= 3;
    while (i > 0) {
      final len = i >= 2 ? 2 : i;
      parts.insert(0, s.substring(i - len, i));
      i -= len;
    }
    return '$sign₹${parts.join(',')}';
  }

  String _monthShortLabel(ChartData d) {
    final raw = d.monthName?.trim();
    if (raw == null || raw.isEmpty) return '—';
    final parts = raw.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final mon = parts[0].length > 3
          ? parts[0].substring(0, 3)
          : parts[0];
      return '$mon\n${parts[1].length > 2 ? parts[1].substring(parts[1].length - 2) : parts[1]}';
    }
    return parts.first.length > 4 ? parts.first.substring(0, 4) : parts.first;
  }

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

    final maxY = _maxYAxis();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        const SizedBox(height: 14),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE8ECF1)),
            boxShadow: [
              BoxShadow(
                color: ColorConstant.shadowColor.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Row(
                  children: [
                    Icon(
                      widget.metric == ChartMetric.income
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 20,
                      color: _metricColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tap chart for details · Y-axis in ₹ (k = thousand, L = lakh)',
                        style: PMT.appStyle(
                          size: 11,
                          fontColor: ColorConstant.textGreyColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(19),
                ),
                child: Container(
                  height: 300,
                  width: double.infinity,
                  color: ColorConstant.lightGrey,
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 12,
                    top: 12,
                    bottom: 8,
                  ),
                  child: _buildChartBody(maxY),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildLegend(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: PMT.appStyle(
                      size: 19,
                      fontWeight: FontWeight.w700,
                      fontColor: ColorConstant.textDarkBrown,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: _metricLightSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _metricColor.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Text(
                          'Total (all months)',
                          style: PMT.appStyle(
                            size: 12,
                            fontColor: ColorConstant.textGreyColor,
                          ),
                        ),
                        Text(
                          _formatTooltipRupee(_periodTotal.toDouble()),
                          style: PMT.appStyle(
                            size: 15,
                            fontWeight: FontWeight.w700,
                            fontColor: _metricColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.topRight,
              child: _buildChartTypeControl(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChartTypeControl() {
    return Material(
      color: Colors.transparent,
      child: SegmentedButton<ChartType>(
        style: ButtonStyle(
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          ),
        ),
        showSelectedIcon: false,
        segments: [
          ButtonSegment<ChartType>(
            value: ChartType.bar,
            icon: const Icon(Icons.bar_chart_rounded, size: 18),
            label: Text(
              'Bar',
              style: PMT.appStyle(size: 11, fontWeight: FontWeight.w600),
            ),
          ),
          ButtonSegment<ChartType>(
            value: ChartType.line,
            icon: const Icon(Icons.show_chart_rounded, size: 18),
            label: Text(
              'Line',
              style: PMT.appStyle(size: 11, fontWeight: FontWeight.w600),
            ),
          ),
          ButtonSegment<ChartType>(
            value: ChartType.pie,
            icon: const Icon(Icons.pie_chart_outline_rounded, size: 18),
            label: Text(
              'Pie',
              style: PMT.appStyle(size: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
        selected: {_selectedType},
        onSelectionChanged: (Set<ChartType> next) {
          if (next.isEmpty) return;
          setState(() => _selectedType = next.first);
        },
      ),
    );
  }

  Widget _buildChartBody(double maxY) {
    switch (_selectedType) {
      case ChartType.line:
        return _buildLineChart(maxY);
      case ChartType.bar:
        return _buildBarChart(maxY);
      case ChartType.pie:
        return _buildPieChart();
    }
  }

  Widget _buildLineChart(double maxY) {
    final color = _metricColor;
    return LineChart(
      LineChartData(
        minX: -0.05,
        maxX: (widget.data.length - 1).toDouble() + 0.05,
        minY: 0,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            maxContentWidth: 220,
            tooltipBorderRadius: BorderRadius.circular(10),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            getTooltipColor: (_) => const Color(0xFF1E293B),
            getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
              return touchedBarSpots.map((barSpot) {
                final i = barSpot.x.round().clamp(0, widget.data.length - 1);
                final month = widget.data[i].monthName ?? '';
                return LineTooltipItem(
                  '',
                  const TextStyle(fontSize: 0, height: 0),
                  children: [
                    TextSpan(
                      text: '$month\n',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        height: 1.3,
                      ),
                    ),
                    TextSpan(
                      text:
                          '$_metricLabel  ${_formatTooltipRupee(barSpot.y)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.35,
                      ),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY > 0 ? maxY / 4 : null,
          getDrawingHorizontalLine: (v) => FlLine(
            color: const Color(0xFFCBD5E1).withValues(alpha: 0.6),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: 1,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= widget.data.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _monthShortLabel(widget.data[index]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: PMT.appStyle(
                      size: 10,
                      fontColor: ColorConstant.textGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: maxY > 0 ? maxY / 4 : null,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    '₹${_formatAxisRupee(value)}',
                    textAlign: TextAlign.end,
                    style: PMT.appStyle(
                      size: 10,
                      fontColor: ColorConstant.textGreyColor,
                    ),
                  ),
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
                .map(
                  (e) => FlSpot(
                    e.key.toDouble(),
                    _valueFor(e.value).toDouble(),
                  ),
                )
                .toList(),
            isCurved: true,
            curveSmoothness: 0.22,
            color: color,
            barWidth: 3.5,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.white,
                  strokeWidth: 2.5,
                  strokeColor: color,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  color.withValues(alpha: 0.22),
                  color.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart(double maxY) {
    final c = _metricColor;
    return BarChart(
      BarChartData(
        minY: 0,
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 10,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            maxContentWidth: 220,
            tooltipBorderRadius: BorderRadius.circular(10),
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            tooltipMargin: 8,
            getTooltipColor: (_) => const Color(0xFF1E293B),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final i = group.x.toInt();
              if (i < 0 || i >= widget.data.length) {
                return null;
              }
              final month = widget.data[i].monthName ?? '';
              return BarTooltipItem(
                '',
                const TextStyle(fontSize: 0, height: 0),
                textAlign: TextAlign.start,
                children: [
                  TextSpan(
                    text: '$month\n',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  TextSpan(
                    text:
                        '$_metricLabel  ${_formatTooltipRupee(rod.toY)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.35,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= widget.data.length) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _monthShortLabel(widget.data[index]),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: PMT.appStyle(
                      size: 10,
                      fontColor: ColorConstant.textGreyColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: maxY > 0 ? maxY / 4 : null,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    '₹${_formatAxisRupee(value)}',
                    textAlign: TextAlign.end,
                    style: PMT.appStyle(
                      size: 10,
                      fontColor: ColorConstant.textGreyColor,
                    ),
                  ),
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
            showingTooltipIndicators: [0],
            barRods: [
              BarChartRodData(
                toY: _valueFor(e.value).toDouble(),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    c.withValues(alpha: 0.85),
                    c,
                  ],
                ),
                width: 22,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: maxY,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPieChart() {
    final base = _metricColor;
    final positive = widget.data
        .asMap()
        .entries
        .where((e) => _valueFor(e.value) > 0)
        .toList();
    if (positive.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.pie_chart_outline_rounded,
              size: 48,
              color: ColorConstant.textGreyColor.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 12),
            Text(
              'No $_metricLabel to show',
              style: PMT.appStyle(
                size: 14,
                fontWeight: FontWeight.w600,
                fontColor: ColorConstant.textGreyColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Amounts are zero for every month in this view.',
              textAlign: TextAlign.center,
              style: PMT.appStyle(
                size: 12,
                fontColor: ColorConstant.textGreyColor,
              ),
            ),
          ],
        ),
      );
    }

    final total = positive.fold<double>(
      0,
      (s, e) => s + _valueFor(e.value).toDouble(),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final radius = math.min(constraints.maxWidth, constraints.maxHeight) *
            0.28;
        return Stack(
          alignment: Alignment.center,
          children: [
            PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  enabled: true,
                  touchCallback: (event, response) {},
                ),
                sectionsSpace: 2,
                centerSpaceRadius: radius * 0.55,
                sections: positive.asMap().entries.map((me) {
                  final e = me.value;
                  final idx = me.key;
                  final v = _valueFor(e.value).toDouble();
                  final label =
                      e.value.monthName?.split(' ').first ?? '${e.key + 1}';
                  final pct = total > 0 ? (v / total * 100) : 0.0;
                  final t = v >= 100000
                      ? '₹${(v / 100000).toStringAsFixed(1)}L'
                      : '₹${(v / 1000).toStringAsFixed(1)}k';
                  return PieChartSectionData(
                    value: v,
                    title: '$label\n$t\n${pct.toStringAsFixed(0)}%',
                    color: Color.lerp(
                      base,
                      Colors.white,
                      (idx % 6) * 0.1,
                    )!,
                    radius: radius,
                    titleStyle: PMT.appStyle(
                      size: 9,
                      fontWeight: FontWeight.w700,
                      fontColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: PMT.appStyle(
                    size: 11,
                    fontColor: ColorConstant.textGreyColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatTooltipRupee(total),
                  style: PMT.appStyle(
                    size: 14,
                    fontWeight: FontWeight.w800,
                    fontColor: _metricColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLegend() {
    if (_selectedType == ChartType.pie) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 16,
              color: ColorConstant.textGreyColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Pie slices are share of total $_metricLabel for months that have data.',
                style: PMT.appStyle(
                  size: 12,
                  fontColor: ColorConstant.textGreyColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _metricLightSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _metricColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _metricLabel,
                style: PMT.appStyle(
                  size: 13,
                  fontWeight: FontWeight.w600,
                  fontColor: ColorConstant.textDarkBrown,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
