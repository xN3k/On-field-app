enum Role {
  admin,
  manager,
  worker;

  bool get isManager => this == Role.admin || this == Role.manager;
  bool get isWorker => this == Role.worker;

  static Role fromString(String value) => switch (value.toUpperCase()) {
        'ADMIN' => Role.admin,
        'MANAGER' => Role.manager,
        _ => Role.worker,
      };

  String get wire => name.toUpperCase();
}

class User {
  const User({
    required this.id,
    required this.email,
    required this.role,
    this.name,
    this.teamId,
  });

  final String id;
  final String email;
  final String? name;
  final Role role;
  final String? teamId;
}
