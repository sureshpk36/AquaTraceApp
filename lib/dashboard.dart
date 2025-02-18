import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double horizontalPadding = 16.0;

    return Scaffold(
      backgroundColor: const Color(0xFF0B619C),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Bar
                const SizedBox(height: 16),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'UB System Overview',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.notifications, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.settings, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // pH Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Current pH Level',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '7.2',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueGrey[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: double.infinity,
                              height: 2,
                              color: Colors.blueGrey,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: const [
                                Icon(Icons.check_circle,
                                    color: Colors.green, size: 20),
                                SizedBox(width: 6),
                                Text(
                                  'Safe Range (6.5 - 8.5)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Four small cards: TDS, Turbidity, Temperature, Conductivity
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallCard(
                        title: 'TDS',
                        value: '145 ppm',
                        icon: Icons.bubble_chart,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSmallCard(
                        title: 'Turbidity',
                        value: '2.1 NTU',
                        icon: Icons.opacity,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildSmallCard(
                        title: 'Temperature',
                        value: '23°C',
                        icon: Icons.thermostat,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildSmallCard(
                        title: 'Conductivity',
                        value: '410 μS/cm',
                        icon: Icons.flash_on,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 24h Monitoring Section with Real-Time Chart
                const Text(
                  '24h Monitoring',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: RealTimeChart(),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget for small cards
  Widget _buildSmallCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueGrey[700]),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RealTimeChart extends StatefulWidget {
  const RealTimeChart({Key? key}) : super(key: key);

  @override
  State<RealTimeChart> createState() => _RealTimeChartState();
}

class _RealTimeChartState extends State<RealTimeChart> {
  late List<ChartData> _phData;
  late List<ChartData> _tdsData;
  Timer? _timer;
  double _xValue = 0;

  @override
  void initState() {
    super.initState();
    _phData = [];
    _tdsData = [];
    _simulateIncomingData();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // Simulate incoming data every 2 seconds.
  void _simulateIncomingData() {
    final random = Random();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        _xValue += 1;
        final ph = 6.8 + random.nextDouble() * 0.5;
        final tds = 140 + random.nextDouble() * 20;
        _phData.add(ChartData(_xValue, ph));
        _tdsData.add(ChartData(_xValue, tds));

        // Keep the last 20 data points.
        if (_phData.length > 20) {
          _phData.removeAt(0);
          _tdsData.removeAt(0);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: true, position: LegendPosition.bottom),
      primaryXAxis: NumericAxis(
        labelStyle: const TextStyle(color: Colors.black54),
        axisLine: const AxisLine(color: Colors.black26),
        majorGridLines: const MajorGridLines(color: Colors.black12),
      ),
      primaryYAxis: NumericAxis(
        labelStyle: const TextStyle(color: Colors.black54),
        axisLine: const AxisLine(color: Colors.black26),
        majorGridLines: const MajorGridLines(color: Colors.black12),
      ),
      series: <LineSeries>[
        LineSeries<ChartData, double>(
          name: 'pH',
          dataSource: _phData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: Colors.green,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<ChartData, double>(
          name: 'TDS',
          dataSource: _tdsData,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y,
          color: Colors.blue,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartData {
  final double x;
  final double y;
  ChartData(this.x, this.y);
}
