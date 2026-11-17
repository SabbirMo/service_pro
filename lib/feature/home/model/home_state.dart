import 'package:service_pro/feature/home/model/category_group_model.dart';
import 'package:service_pro/feature/home/model/service_model.dart';

class HomeState {
  final bool isLoading;
  final bool isFeaturedLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final List<String> categories;
  final String selectedCategory;
  final String searchQuery;
  final List<ServiceModel> featuredServices;
  final List<ServiceModel> services;
  final List<CategoryGroupModel> categoryGroups;

  // Pagination fields
  final int currentPage;
  final int limit;
  final int totalServices;
  final int totalPages;
  final bool hasNextPage;

  const HomeState({
    this.isLoading = false,
    this.isFeaturedLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.categories = const ['All'],
    this.selectedCategory = 'All',
    this.searchQuery = '',
    this.featuredServices = const [],
    this.services = const [],
    this.categoryGroups = const [],
    this.currentPage = 1,
    this.limit = 6,
    this.totalServices = 0,
    this.totalPages = 1,
    this.hasNextPage = false,
  });

  HomeState copyWith({
    bool? isLoading,
    bool? isFeaturedLoading,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearError = false,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    List<ServiceModel>? featuredServices,
    List<ServiceModel>? services,
    List<CategoryGroupModel>? categoryGroups,
    int? currentPage,
    int? limit,
    int? totalServices,
    int? totalPages,
    bool? hasNextPage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      isFeaturedLoading: isFeaturedLoading ?? this.isFeaturedLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      featuredServices: featuredServices ?? this.featuredServices,
      services: services ?? this.services,
      categoryGroups: categoryGroups ?? this.categoryGroups,
      currentPage: currentPage ?? this.currentPage,
      limit: limit ?? this.limit,
      totalServices: totalServices ?? this.totalServices,
      totalPages: totalPages ?? this.totalPages,
      hasNextPage: hasNextPage ?? this.hasNextPage,
    );
  }
}
