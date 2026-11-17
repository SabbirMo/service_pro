import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:service_pro/feature/home/model/home_state.dart';
import 'package:service_pro/feature/home/repository/home_repository.dart';

class HomeNotifier extends Notifier<HomeState> {
  HomeRepository get _repository => ref.read(homeRepositoryProvider);

  @override
  HomeState build() {
    Future.microtask(() => loadInitialData());
    return const HomeState(
      isLoading: true,
      isFeaturedLoading: true,
    );
  }

  /// Initial load:
  /// 1. Fetches all categories dynamically from backend
  /// 2. Fetches featured services
  /// 3. Fetches first page (page 1, limit 6) of services
  Future<void> loadInitialData() async {
    state = state.copyWith(
      isLoading: true,
      isFeaturedLoading: true,
      clearError: true,
      currentPage: 1,
    );

    // 1. Fetch featured services
    final featuredFuture = _repository.getServices(featured: true).then((response) {
      state = state.copyWith(
        isFeaturedLoading: false,
        featuredServices: response.allServices,
      );
    }).catchError((e) {
      state = state.copyWith(isFeaturedLoading: false);
    });

    // 2. Fetch all categories and first page of services
    final servicesFuture = _repository.getServices(page: 1, limit: state.limit).then((response) async {
      // Also fetch full categories if needed
      final dynamicCategories = <String>['All'];
      for (final group in response.data) {
        if (group.category.isNotEmpty && !dynamicCategories.contains(group.category)) {
          dynamicCategories.add(group.category);
        }
      }

      // If there are more categories across all pages, fetch them in the background
      _fetchAllCategoriesInBackground(dynamicCategories);

      state = state.copyWith(
        isLoading: false,
        categories: dynamicCategories,
        categoryGroups: response.data,
        services: response.allServices,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages,
        totalServices: response.pagination.totalServices,
        hasNextPage: response.pagination.hasNextPage,
      );
    }).catchError((e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    });

    await Future.wait([featuredFuture, servicesFuture]);
  }

  Future<void> _fetchAllCategoriesInBackground(List<String> currentCategories) async {
    try {
      final allRes = await _repository.getServices();
      final updatedCategories = <String>['All'];
      for (final group in allRes.data) {
        if (group.category.isNotEmpty && !updatedCategories.contains(group.category)) {
          updatedCategories.add(group.category);
        }
      }
      if (updatedCategories.length > currentCategories.length) {
        state = state.copyWith(categories: updatedCategories);
      }
    } catch (_) {}
  }

  /// Select a category tab (resets to page 1)
  Future<void> selectCategory(String category) async {
    if (state.selectedCategory == category && !state.isLoading) {
      return;
    }

    state = state.copyWith(
      selectedCategory: category,
      currentPage: 1,
      isLoading: true,
      clearError: true,
    );

    try {
      final response = await _repository.getServices(
        category: category,
        search: state.searchQuery,
        page: 1,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        services: response.allServices,
        categoryGroups: response.data,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages,
        totalServices: response.pagination.totalServices,
        hasNextPage: response.pagination.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Search services (resets to page 1)
  Future<void> searchServices(String query) async {
    state = state.copyWith(
      searchQuery: query,
      currentPage: 1,
      isLoading: true,
      clearError: true,
    );

    try {
      final response = await _repository.getServices(
        category: state.selectedCategory,
        search: query,
        page: 1,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        services: response.allServices,
        categoryGroups: response.data,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages,
        totalServices: response.pagination.totalServices,
        hasNextPage: response.pagination.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Clear search input
  Future<void> clearSearch() async {
    if (state.searchQuery.isEmpty) return;

    state = state.copyWith(
      searchQuery: '',
      currentPage: 1,
      isLoading: true,
      clearError: true,
    );

    try {
      final response = await _repository.getServices(
        category: state.selectedCategory,
        page: 1,
        limit: state.limit,
      );

      state = state.copyWith(
        isLoading: false,
        services: response.allServices,
        categoryGroups: response.data,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages,
        totalServices: response.pagination.totalServices,
        hasNextPage: response.pagination.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Load next page of services (pagination)
  Future<void> loadMoreServices() async {
    if (state.isLoadingMore || !state.hasNextPage || state.isLoading) {
      return;
    }

    state = state.copyWith(isLoadingMore: true);

    try {
      final nextPage = state.currentPage + 1;
      final response = await _repository.getServices(
        category: state.selectedCategory,
        search: state.searchQuery,
        page: nextPage,
        limit: state.limit,
      );

      // Append new services
      final newServices = response.allServices;
      state = state.copyWith(
        isLoadingMore: false,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages,
        totalServices: response.pagination.totalServices,
        hasNextPage: response.pagination.hasNextPage,
        services: [...state.services, ...newServices],
        categoryGroups: [...state.categoryGroups, ...response.data],
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  /// Reset all filters (category & search) back to page 1
  Future<void> resetFilters() async {
    state = state.copyWith(
      selectedCategory: 'All',
      searchQuery: '',
      currentPage: 1,
      isLoading: true,
      clearError: true,
    );

    try {
      final response = await _repository.getServices(page: 1, limit: state.limit);
      state = state.copyWith(
        isLoading: false,
        services: response.allServices,
        categoryGroups: response.data,
        currentPage: response.pagination.currentPage,
        totalPages: response.pagination.totalPages,
        totalServices: response.pagination.totalServices,
        hasNextPage: response.pagination.hasNextPage,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Pull-to-refresh
  Future<void> refresh() async {
    await loadInitialData();
  }
}

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);
