import 'dart:convert';

import 'package:dash_generator/data.dart';

class DashRepo {
  final dashApi = DashApi();

  Future<String> getDashUrl(Dash dash) async {
    final response = await dashApi.getDashUrl(dash);
    if (response.statusCode != 200) {
      throw Exception('http exception');
    }

    final utf8body = utf8.decode(response.bodyBytes);
    final body = jsonDecode(utf8body);
    var rawData = Map<String, dynamic>.from(body);

    return rawData['url'];
  }
}