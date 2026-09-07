import 'package:flutter/material.dart';
import 'lesson.dart';

class Course {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final List<Lesson> lessons;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.lessons,
  });
}
