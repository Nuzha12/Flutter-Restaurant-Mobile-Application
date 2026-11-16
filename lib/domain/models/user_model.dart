import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String   id;
  final String   name;
  final String   email;
  final String?  phone;
  final String?  avatarUrl;
  final int      loyaltyPoints;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.loyaltyPoints = 0,
    required this.createdAt,
  });

  String get initials => name.split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();

  UserModel copyWith({
    String? name, String? phone, String? avatarUrl, int? loyaltyPoints,
  }) => UserModel(
    id: id, email: email, createdAt: createdAt,
    name:          name          ?? this.name,
    phone:         phone         ?? this.phone,
    avatarUrl:     avatarUrl     ?? this.avatarUrl,
    loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
  );

  @override
  List<Object?> get props => [id, name, email, phone, loyaltyPoints];
}