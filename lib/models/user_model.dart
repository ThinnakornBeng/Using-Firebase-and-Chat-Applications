import 'dart:convert';

class UserModel {
  final String name;
  final String email;
  final String type;
  final String imageProfile;
  UserModel({
    required this.name,
    required this.email,
    required this.type,
    required this.imageProfile,
  });
 

  UserModel copyWith({
    String? name,
    String? email,
    String? type,
    String? imageProfile,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      type: type ?? this.type,
      imageProfile: imageProfile ?? this.imageProfile,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'name': name});
    result.addAll({'email': email});
    result.addAll({'type': type});
    result.addAll({'imageProfile': imageProfile});
  
    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? '',
      imageProfile: map['imageProfile'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, type: $type, imageProfile: $imageProfile)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is UserModel &&
      other.name == name &&
      other.email == email &&
      other.type == type &&
      other.imageProfile == imageProfile;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      email.hashCode ^
      type.hashCode ^
      imageProfile.hashCode;
  }
}
