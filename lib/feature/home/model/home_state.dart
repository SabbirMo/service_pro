import 'package:service_pro/feature/home/model/category_model.dart';

class HomeState {
  final String selectedCategory;
  final List<CategoryModel> categories;

  const HomeState({
    this.selectedCategory = "All",
    this.categories = const [],
  });

  HomeState copyWith({
    String? selectedCategory,
    List<CategoryModel>? categories,
  }) {
    return HomeState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
    );
  }
}
