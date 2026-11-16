import 'package:service_pro/feature/home/model/category_model.dart';

class HomeState {
  final String selectedCategory;
  final List<CategoryModel> categories;
  final bool isLoading;

  const HomeState({
    this.selectedCategory = "All",
    this.categories = const [],
    this.isLoading = false,
  });

  HomeState copyWith({
    String? selectedCategory,
    List<CategoryModel>? categories,
    bool? isLoading,
  }) {
    return HomeState(
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
