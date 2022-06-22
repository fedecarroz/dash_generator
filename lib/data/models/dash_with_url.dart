import 'package:dash_generator/data.dart';

class DashWithUrl extends Dash {
  final String url;

  DashWithUrl({
    required this.url,
    required super.agility,
    required super.wisdom,
    required super.strength,
    required super.charisma,
    required super.role,
  });

  factory DashWithUrl.fromDash(Dash dash, String url) {
    return DashWithUrl(
      agility: dash.agility,
      wisdom: dash.wisdom,
      strength: dash.strength,
      charisma: dash.charisma,
      role: dash.role,
      url: url,
    );
  }
}
