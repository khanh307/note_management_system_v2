import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:note_management_system_v2/models/Dashboard/dashboardDTO.dart';
import 'package:note_management_system_v2/models/Dashboard/dashboardModel.dart';
import 'package:note_management_system_v2/models/response.dart';
import 'package:note_management_system_v2/repository/api_constant.dart';

class DashboardRepository {
  final String email;

  DashboardRepository({required this.email});

  static const String urlRead =
      '${APIConstant.BASE_URL}/get?tab=Dashboard&email=';

  Future<List<DashboardModel>?> getAllChart() async {
    final uri = Uri.parse('$urlRead$email');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    if (parsed['status'] == 1 && parsed['data'] != null) {
      Response result = Response.fromJson(parsed);
      final list = result.data
          ?.map<DashboardModel>((status) => DashboardModel.fromArray(status))
          .toList();

      return list;
    } else {
      return null;
    }
  }

  Future<DashboardDTO?> getAllChartData() async {
    final uri = Uri.parse('$urlRead$email');
    final response = await http.get(uri);
    final parsed = jsonDecode(response.body);

    if (parsed['status'] == 1 && parsed['data'] != null) {
      Response result = Response.fromJson(parsed);
      int total = 0;
      final list = result.data?.map<DashboardModel>((item) {
        DashboardModel model = DashboardModel.fromArray(item);
        total = total + int.parse(model.counter!);
        return model;
      }).toList();
      return DashboardDTO(data: list, total: total);
    } else {
      return null;
    }
  }
}
