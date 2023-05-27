import 'dart:math';

import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final data = [
    {'domain': 'Doing', 'measure': 28},
    {'domain': 'Processing', 'measure': 27},
    {'domain': 'Done', 'measure': 20},
    {'domain': 'Woking', 'measure': 15},
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? const Center(
            child: Text('Dashboard is empty!'),
          )
        : Center(
            child: AspectRatio(
              aspectRatio: 1,
              child: DChartPie(
                data: data.map((e) {
                  return {'domain': e['domain'], 'measure': e['measure']};
                }).toList(),
                fillColor: (pieData, index) {
                  switch (pieData['domain'].toString().toLowerCase()) {
                    case 'processing':
                      return Colors.grey[600];
                    case 'done':
                      return Colors.blue[900];
                    case 'pending':
                      return Colors.red;
                    default:
                      return Color.fromARGB(
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256),
                          Random().nextInt(256));
                  }
                },
                labelColor: Colors.white,
                labelPosition: PieLabelPosition.inside,
                labelFontSize: 15,
                labelLineThickness: 1,
                labelLinelength: 16,
                labelPadding: 5,
                pieLabel: (Map<dynamic, dynamic> pieData, int? index) {
                  return pieData['domain'] +
                      ': ' +
                      pieData['measure'].toString() +
                      '%';
                },
                strokeWidth: 2,
                animationDuration: const Duration(milliseconds: 1200),
              ),
            ),
          );
  }
}
