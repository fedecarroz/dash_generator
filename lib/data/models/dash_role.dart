enum DashRole {
  common("common"),
  designer("designer"),
  developer("developer"),
  manager("manager");

  final String role;

  const DashRole(this.role);

  @override
  String toString() => role;
}
