import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Client extends Equatable {
  final String id;
  final String name;
  final String domain;
  final String? logo;
  final String? primaryColor;
  final String? secondaryColor;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Client({
    required this.id,
    required this.name,
    required this.domain,
    this.logo,
    this.primaryColor,
    this.secondaryColor,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Converte a string primaryColor em um objeto Color
  Color? get primaryColorValue {
    if (primaryColor == null) return null;
    try {
      // Remove o '#' se existir e converte para int
      final hexColor = primaryColor!.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return null;
    }
  }

  /// Converte a string secondaryColor em um objeto Color
  Color? get secondaryColorValue {
    if (secondaryColor == null) return null;
    try {
      // Remove o '#' se existir e converte para int
      final hexColor = secondaryColor!.replaceAll('#', '');
      return Color(int.parse('FF$hexColor', radix: 16));
    } catch (e) {
      return null;
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        domain,
        logo,
        primaryColor,
        secondaryColor,
        isActive,
        createdAt,
        updatedAt,
      ];

  Client copyWith({
    String? id,
    String? name,
    String? domain,
    String? logo,
    String? primaryColor,
    String? secondaryColor,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      domain: domain ?? this.domain,
      logo: logo ?? this.logo,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
