import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';


enum AddressType { home, work, other }

class AddressModel extends Equatable {
  final String      id;
  final String      label;
  final AddressType type;
  final String      street;
  final String      city;
  final String      state;
  final String      zip;
  final String?     instructions;
  final bool        isDefault;

  const AddressModel({
    required this.id, required this.label,
    this.type     = AddressType.home,
    required this.street, required this.city,
    required this.state,  required this.zip,
    this.instructions,
    this.isDefault = false,
  });

  String get fullAddress => '$street, $city, $state $zip';
  String get shortAddress => '$street, $city';

  IconData get icon {
    switch (type) {
      case AddressType.home: return Icons.home_rounded;
      case AddressType.work: return Icons.business_rounded;
      case AddressType.other: return Icons.location_on_rounded;
    }
  }

  AddressModel copyWith({bool? isDefault, String? instructions}) => AddressModel(
    id: id, label: label, type: type, street: street,
    city: city, state: state, zip: zip,
    instructions: instructions ?? this.instructions,
    isDefault:    isDefault    ?? this.isDefault,
  );

  @override
  List<Object> get props => [id, street, city, isDefault];
}