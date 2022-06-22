import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dash_generator/data.dart';
import 'package:flutter/foundation.dart';

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

  Stream<List<DashWithUrl>> getDashImages({
    int bufferSize = 5,
  }) async* {
    final dashPermutations = await getDashPermutations();

    while (dashPermutations.isNotEmpty) {
      final effectiveBufferSize = dashPermutations.length < bufferSize
          ? dashPermutations.length
          : bufferSize;

      final currentPermutations = dashPermutations.sublist(
        0,
        effectiveBufferSize,
      );

      dashPermutations.removeRange(0, effectiveBufferSize);

      final requests = currentPermutations.map((dash) async {
        final url = await getDashUrl(dash);
        return DashWithUrl.fromDash(dash, url);
      });

      final dashesWithUrl = await Future.wait(requests);

      yield dashesWithUrl;
    }

    yield [];
  }

  Future downloadDashs() async {
    /// { key: filename, value: url }

    final commonDashUrls = <String, String>{};
    final developerDashUrls = <String, String>{};
    final designerDashUrls = <String, String>{};
    final managerDashUrls = <String, String>{};

    final dashImages = getDashImages(bufferSize: 20);

    await for (final dashBuffer in dashImages) {
      if (dashBuffer.isEmpty) break;

      for (final dash in dashBuffer) {
        final dashFilename = dash.filename;

        if (commonDashUrls.containsValue(dash.url)) continue;

        if (developerDashUrls.containsValue(dash.url) &&
            designerDashUrls.containsValue(dash.url) &&
            managerDashUrls.containsValue(dash.url)) {
          developerDashUrls.remove(dashFilename);
          designerDashUrls.remove(dashFilename);
          managerDashUrls.remove(dashFilename);
          commonDashUrls[dashFilename] = dash.url;
          continue;
        }

        switch (dash.role) {
          case DashRole.manager:
            managerDashUrls[dashFilename] = dash.url;
            break;
          case DashRole.designer:
            designerDashUrls[dashFilename] = dash.url;
            break;
          case DashRole.developer:
            developerDashUrls[dashFilename] = dash.url;
            break;
        }
      }
    }

    if (kDebugMode) {
      print(
        """
        Common => ${commonDashUrls.length}
        Dev => ${developerDashUrls.length}
        Des => ${designerDashUrls.length}
        Man => ${managerDashUrls.length}
        """,
      );
    }
  }

  Future<Uint8List> downloadDashImage(String url) async {
    final response = await dashApi.downloadDashImage(url);

    if (response.statusCode > 299) {
      throw HttpException(
        'Http Error Code ${response.statusCode}',
        uri: Uri.parse(url),
      );
    }

    return response.bodyBytes;
  }

  Future<List<Dash>> getDashPermutations() async {
    final perms = await dashApi.importPermutations().then((perms) {
      return perms.split('\n').map((perm) => perm.split(','));
    });

    final dashPerms = DashRole.values
        .map(
          (role) => perms.map(
            (perm) => Dash(
              agility: perm[0],
              wisdom: perm[1],
              strength: perm[2],
              charisma: perm[3],
              role: role,
            ),
          ),
        )
        .expand((dash) => dash)
        .toList();

    return dashPerms;
  }
}
