import 'package:dash_generator/data.dart';

class Dash extends BaseDash {
  final String url;
  final DashRole role;

  Dash({
    required this.url,
    required super.agility,
    required super.wisdom,
    required super.strength,
    required super.charisma,
    required this.role,
  });

  factory Dash.fromDashBase(BaseDash dash, DashRole role, String url) {
    return Dash(
      agility: dash.agility,
      wisdom: dash.wisdom,
      strength: dash.strength,
      charisma: dash.charisma,
      role: role,
      url: url,
    );
  }

  String get filename => "$role/$agility$wisdom$strength$charisma.png";
}
