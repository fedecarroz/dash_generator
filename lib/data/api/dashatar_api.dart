import 'package:dash_generator/data.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String dashatarEndpoint =
    'https://us-central1-dashatar-dev.cloudfunctions.net/';

class DashApi {
  Future<http.Response> getDashUrl(Dash dash) {
    final url =
        '$dashatarEndpoint/createDashatar?agility=${dash.agility}&wisdom=${dash.wisdom}&strength=${dash.strength}&charisma=${dash.charisma}&role=${dash.role}';

    return http.get(Uri.parse(url));
  }

  Future<String> importPermutations() {
    return rootBundle.loadString('perm.csv');
  }

  Future<http.Response> downloadDashImage(String url) {
    return http.get(Uri.parse(url));
  }
}
