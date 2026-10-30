class UserModel {
  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final bool isVerified;
  final String? activeRole;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.isVerified,
    this.activeRole,
  });

  bool get isFarmer => roles.contains('farmer') || roles.contains('admin');
  bool get isAdmin => roles.contains('admin');
  bool get isGeneralUser => roles.contains('user');

  String get primaryRole {
    if (activeRole != null && activeRole!.isNotEmpty) return activeRole!;
    if (isAdmin) return 'admin';
    if (roles.contains('farmer')) return 'farmer';
    return 'user';
  }

  String get roleDisplayTitle {
    switch (primaryRole) {
      case 'admin':
        return 'Botanical Admin';
      case 'farmer':
        return 'Farmer / Grower';
      default:
        return 'Plant Enthusiast';
    }
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    List<String>? roles,
    bool? isVerified,
    String? activeRole,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      isVerified: isVerified ?? this.isVerified,
      activeRole: activeRole ?? this.activeRole,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json, {String? activeRole}) {
    final rawRoles = json['roles'];
    List<String> parsedRoles = [];
    if (rawRoles is List) {
      parsedRoles = rawRoles.map((e) => e.toString().toLowerCase()).toList();
    } else if (rawRoles is String) {
      parsedRoles = [rawRoles.toLowerCase()];
    }
    if (parsedRoles.isEmpty) parsedRoles = ['user'];

    return UserModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      roles: parsedRoles,
      isVerified: json['is_verified'] == true || json['is_verified'] == 1,
      activeRole: activeRole,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'is_verified': isVerified ? 1 : 0,
      'active_role': activeRole,
    };
  }
}
