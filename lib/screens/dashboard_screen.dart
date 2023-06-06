import 'dart:math';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_management_system_v2/cubits/dashboard_cubit/dashboard_cubit.dart';
import 'package:note_management_system_v2/cubits/dashboard_cubit/dashboard_state.dart';
import 'package:note_management_system_v2/models/account.dart';
import 'package:note_management_system_v2/repository/dashboardRepository.dart';
// import 'package:note_management_system_v2/models/user.dart';

class DashboardScreen extends StatefulWidget {
  final Account user;
  const DashboardScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardCubit dashboardCubit;

  @override
  void initState() {
    super.initState();
    dashboardCubit =
        DashboardCubit(DashboardRepository(email: widget.user.email!));
    dashboardCubit.getAllStatusCharts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      child: BlocProvider.value(
        value: dashboardCubit,
        child: BlocConsumer<DashboardCubit, DashboardState>(
          listener: (context, state) {
            if (state is FailureChartState) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is InitialChartState || state is LoadingChartState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is SuccessGetAllChartState) {
              final listChart = state.listChartStatus;
              return Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: DChartPie(
                    data: listChart!.data!.map((e) {
                      return {
                        'domain': e.name,
                        'measure': double.parse(
                            (int.parse(e.counter!) / (listChart.total!) * 100)
                                .toStringAsFixed(2))
                      };
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
                    // labelFontSize: 13,
                    // labelLineThickness: 1,
                    // labelLinelength: 10,
                    // labelPadding: 10,
                    pieLabel: (Map<dynamic, dynamic> pieData, int? index) {
                      return pieData['domain'] +
                          ': ' +
                          pieData['measure'].toString() +
                          '%';
                    },
                    strokeWidth: 2,
                    animationDuration: const Duration(milliseconds: 2700),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text("Dashboard Empty!"),
              );
            }
          },
        ),
      ),
    ));
  }
}
