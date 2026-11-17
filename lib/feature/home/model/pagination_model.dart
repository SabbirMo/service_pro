class PaginationModel {
  final int currentPage;
  final int limit;
  final int totalServices;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  const PaginationModel({
    this.currentPage = 1,
    this.limit = 6,
    this.totalServices = 0,
    this.totalPages = 1,
    this.hasNextPage = false,
    this.hasPrevPage = false,
  });

  factory PaginationModel.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PaginationModel();
    return PaginationModel(
      currentPage: (json['currentPage'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 6,
      totalServices: (json['totalServices'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
      hasNextPage: json['hasNextPage'] as bool? ?? false,
      hasPrevPage: json['hasPrevPage'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentPage': currentPage,
      'limit': limit,
      'totalServices': totalServices,
      'totalPages': totalPages,
      'hasNextPage': hasNextPage,
      'hasPrevPage': hasPrevPage,
    };
  }
}
