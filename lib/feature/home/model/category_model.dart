import 'package:flutter/material.dart';

class CategoryModel {
  final String title;
  final IconData icon;

  const CategoryModel({
    required this.title,
    required this.icon,
  });

  /// Dynamically maps backend category names to beautiful icons
  static IconData getIconForCategory(String categoryName) {
    final lower = categoryName.trim().toLowerCase();
    if (lower == 'all') {
      return Icons.dashboard_rounded;
    } else if (lower.contains('clean')) {
      return Icons.cleaning_services_rounded;
    } else if (lower.contains('spa') || lower.contains('massage') || lower.contains('beauty')) {
      return Icons.spa_rounded;
    } else if (lower.contains('plumb')) {
      return Icons.plumbing_rounded;
    } else if (lower.contains('electr')) {
      return Icons.bolt_rounded;
    } else if (lower.contains('paint')) {
      return Icons.format_paint_rounded;
    } else if (lower.contains('ac') || lower.contains('appliance')) {
      return Icons.ac_unit_rounded;
    }
    return Icons.handyman_rounded;
  }
}
