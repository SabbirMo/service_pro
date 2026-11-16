import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/home/model/category_model.dart';
import 'package:service_pro/feature/home/model/home_state.dart';

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState(
      categories: [
        CategoryModel(title: "Cleaning", icon: Icons.cleaning_services_rounded),
        CategoryModel(title: "Plumbing", icon: Icons.plumbing_rounded),
        CategoryModel(title: "Electric", icon: Icons.electrical_services_rounded),
        CategoryModel(title: "Painting", icon: Icons.format_paint_rounded),
      ],
    );
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }
}

final homeNotifierProvider =
    NotifierProvider.autoDispose<HomeNotifier, HomeState>(
      HomeNotifier.new,
    );
