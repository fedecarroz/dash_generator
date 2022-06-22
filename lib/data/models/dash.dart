import 'package:dash_generator/data.dart';

class Dash {
  final String agility;
  final String wisdom;
  final String strength;
  final String charisma;
  final DashRole role;

  Dash({
    required this.agility,
    required this.wisdom,
    required this.strength,
    required this.charisma,
    required this.role,
  });

  String get filename => "$agility$wisdom$strength$charisma$role";
}
