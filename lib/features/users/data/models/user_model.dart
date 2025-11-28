import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    required String role, // ✅ ADICIONADO
    required String clientId, // ✅ ADICIONADO
  }) : super(
          id: id,
          name: name,
          email: email,
          phone: phone,
          avatarUrl: avatarUrl,
          role: role, // ✅ ADICIONADO
          clientId: clientId, // ✅ ADICIONADO
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
      role: json['role'] ?? 'user', // ✅ ADICIONADO (com valor padrão)
      clientId: json['clientId'] ?? json['client_id'] ?? '', // ✅ ADICIONADO (com valor padrão)
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'role': role, // ✅ ADICIONADO
      'clientId': clientId, // ✅ ADICIONADO
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      role: user.role, // ✅ ADICIONADO
      clientId: user.clientId, // ✅ ADICIONADO
    );
  }

  // ✅ MÉTODO ADICIONAL: Para criar cópia com atualizações
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    String? role,
    String? clientId,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      clientId: clientId ?? this.clientId,
    );
  }
}