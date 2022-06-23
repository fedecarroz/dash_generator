import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_generator/data.dart';

class DashatarRepo {
  final _dashApi = DashatarApi();

  Future<List<BaseDash>> _generateDashList() async {
    final permutations = await _dashApi.importPermutations().then((perms) {
      return perms.split('\n').map((perm) => perm.split(','));
    });

    final dashList = permutations
        .map(
          (perm) => BaseDash(
            agility: perm[0],
            wisdom: perm[1],
            strength: perm[2],
            charisma: perm[3],
          ),
        )
        .toList();

    return dashList;
  }

  Future<List<String>> _getDashTripletUrls(BaseDash dash) async {
    final responses = await _dashApi.getDashTripletUrls(dash);
    final urls = <String>[];

    for (var response in responses) {
      if (response.statusCode != 200) {
        throw Exception('http exception');
      }

      final utf8body = utf8.decode(response.bodyBytes);
      final body = jsonDecode(utf8body);
      var rawData = Map<String, dynamic>.from(body);

      urls.add(rawData['url']);
    }

    return urls;
  }

  Stream<List<Dash>> getDashesWithUrl({
    int bufferSize = 30,
  }) async* {
    final dashList = await _generateDashList();

    while (dashList.isNotEmpty) {
      final effectiveBufferSize =
          dashList.length < bufferSize ? dashList.length : bufferSize;

      final currentDashList = dashList.sublist(
        0,
        effectiveBufferSize,
      );

      dashList.removeRange(0, effectiveBufferSize);

      final requests = currentDashList.map(
        (dash) async {
          final urls = await _getDashTripletUrls(dash);
          if (urls[0] == urls[1] && urls[1] == urls[2]) {
            return [Dash.fromDashBase(dash, DashRole.common, urls[0])];
          } else {
            return [
              Dash.fromDashBase(dash, DashRole.designer, urls[0]),
              Dash.fromDashBase(dash, DashRole.developer, urls[1]),
              Dash.fromDashBase(dash, DashRole.manager, urls[2]),
            ];
          }
        },
      );

      final dashesWithUrl = await Future.wait(requests);

      yield dashesWithUrl.expand((element) => element).toList();
    }

    yield [];
  }

  Stream<MapEntry<String, Uint8List>> downloadDashImages(
      List<Dash> dashList) async* {
    for (var dash in dashList) {
      final response = await _dashApi.downloadDashImage(dash.url);

      if (response.statusCode > 299) {
        throw HttpException(
          'Http Error Code ${response.statusCode}',
          uri: Uri.parse(dash.url),
        );
      }

      yield MapEntry(dash.filename, response.bodyBytes);
    }
  }
}
