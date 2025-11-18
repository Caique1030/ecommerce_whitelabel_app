import '../../domain/entities/user.dart';


class UserModel extends User {
UserModel({
required String id,
required String name,
required String email,
String? phone,
String? avatarUrl,
}) : super(id: id, name: name, email: email, phone: phone, avatarUrl: avatarUrl);


factory UserModel.fromJson(Map<String, dynamic> json) {
return UserModel(
id: json['id'].toString(),
name: json['name'] ?? '',
email: json['email'] ?? '',
phone: json['phone'],
avatarUrl: json['avatar_url'] ?? json['avatarUrl'],
);
}


Map<String, dynamic> toJson() {
return {
'id': id,
'name': name,
'email': email,
'phone': phone,
'avatar_url': avatarUrl,
};
}


factory UserModel.fromEntity(User user) {
return UserModel(
id: user.id,
name: user.name,
email: user.email,
phone: user.phone,
avatarUrl: user.avatarUrl,
);
}
}