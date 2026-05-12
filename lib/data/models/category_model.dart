import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    this.color = const Color(0xFF0A898D),
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCode': icon.codePoint,
      'colorValue': color.toARGB32(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: IconData(
        map['iconCode'] ?? Icons.grid_view_rounded.codePoint,
        fontFamily: 'MaterialIcons',
      ),
      color: Color(map['colorValue'] ?? 0xFF0A898D),
    );
  }

  static List<CategoryModel> get allCategories => [
    CategoryModel(
      id: 'all',
      name: 'All',
      icon: Icons.grid_view_rounded,
      color: const Color(0xFF0A898D),
    ),
    CategoryModel(
      id: 'tech',
      name: 'Technical',
      icon: Icons.code,
      color: Colors.blueAccent,
    ),
    CategoryModel(
      id: 'behavioral',
      name: 'Behavioral',
      icon: Icons.psychology,
      color: Colors.orangeAccent,
    ),
    CategoryModel(
      id: 'mgmt',
      name: 'Management',
      icon: Icons.leaderboard,
      color: Colors.purpleAccent,
    ),
    CategoryModel(
      id: 'soft_skills',
      name: 'Soft Skills',
      icon: Icons.chat_bubble_outline,
      color: Colors.pinkAccent,
    ),
  ];
}