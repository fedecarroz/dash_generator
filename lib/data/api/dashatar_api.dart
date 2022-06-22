import 'package:dash_generator/data.dart';
import 'package:http/http.dart' as http;

const String dashatarEndpoint =
    'https://us-central1-dashatar-dev.cloudfunctions.net/';

class DashApi {
  Future<http.Response> getDashUrl(Dash dash) {
    final url =
        '$dashatarEndpoint/createDashatar?agility=${dash.agility}&wisdom=${dash.wisdom}&strength=${dash.strength}&charisma=${dash.charisma}&role=${dash.role}';

    return http.get(Uri.parse(url));
  }
}
