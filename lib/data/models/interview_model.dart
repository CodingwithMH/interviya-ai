import 'package:flutter/material.dart';
import 'package:interviya/data/models/category_model.dart';

class InterviewModel {
  String? id;
  String title;
  IconData icon;
  String categoryId;
  int count;
  String description;

  InterviewModel({
    this.id = '',
    this.title = '',
    this.icon = Icons.work_outline,
    this.categoryId = 'tech',
    this.count = 0,
    this.description = '',
  });

  CategoryModel get categoryData {
    return CategoryModel.allCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => CategoryModel.allCategories.firstWhere((cat) => cat.id == 'tech'),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'iconCode': icon.codePoint,
      'categoryId': categoryId,
      'count': count,
      'description': description,
      'createdAt': DateTime.now(),
    };
  }

  factory InterviewModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return InterviewModel(
      id: docId ?? map['id'] ?? '',
      title: map['title'] ?? '',
      icon: IconData(map['iconCode'] ?? Icons.work_outline.codePoint, fontFamily: 'MaterialIcons'),
      categoryId: map['categoryId'] ?? 'tech',
      count: map['count'] ?? 0,
      description: map['description'] ?? '',
    );
  }
}