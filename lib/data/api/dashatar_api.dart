import 'package:dash_generator/data.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String dashatarEndpoint =
    'https://us-central1-dashatar-dev.cloudfunctions.net/';

class DashatarApi {
  Future<List<http.Response>> getDashTripletUrls(BaseDash dash) async {
    final baseUrl =
        '$dashatarEndpoint/createDashatar?agility=${dash.agility}&wisdom=${dash.wisdom}&strength=${dash.strength}&charisma=${dash.charisma}';

    final designerUrl = '$baseUrl&role=designer';
    final developerUrl = '$baseUrl&role=developer';
    final managerUrl = '$baseUrl&role=manager';

    final responses = <Future<http.Response>>[
      http.get(Uri.parse(designerUrl)),
      http.get(Uri.parse(developerUrl)),
      http.get(Uri.parse(managerUrl)),
    ];

    return Future.wait(responses);
  }

  Future<String> importPermutations() {
    return rootBundle.loadString('perm.csv');
  }

  Future<http.Response> downloadDashImage(String url) {
    return http.get(Uri.parse(url));
  }
}
