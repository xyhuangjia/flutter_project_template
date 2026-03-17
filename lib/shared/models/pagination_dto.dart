/// Pagination DTO for API responses.
///
/// This model represents pagination information from API responses.
library;

import 'package:flutter/foundation.dart';

/// Pagination data transfer object.
///
/// Contains pagination information for list endpoints.
@immutable
class PaginationDto {
  /// Creates a pagination DTO.
  const PaginationDto({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  /// Creates a pagination DTO from JSON map.
  factory PaginationDto.fromJson(Map<String, dynamic> json) => PaginationDto(
        page: json['page'] as int,
        pageSize: json['page_size'] as int,
        totalItems: json['total_items'] as int,
        totalPages: json['total_pages'] as int,
      );

  /// Current page number (1-indexed).
  final int page;

  /// Number of items per page.
  final int pageSize;

  /// Total number of items.
  final int totalItems;

  /// Total number of pages.
  final int totalPages;

  /// Converts the DTO to JSON map.
  Map<String, dynamic> toJson() => {
        'page': page,
        'page_size': pageSize,
        'total_items': totalItems,
        'total_pages': totalPages,
      };

  /// Creates a copy with optionally overridden fields.
  PaginationDto copyWith({
    int? page,
    int? pageSize,
    int? totalItems,
    int? totalPages,
  }) =>
      PaginationDto(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        totalItems: totalItems ?? this.totalItems,
        totalPages: totalPages ?? this.totalPages,
      );

  /// Returns true if there is a next page.
  bool get hasNextPage => page < totalPages;

  /// Returns true if there is a previous page.
  bool get hasPreviousPage => page > 1;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaginationDto &&
        other.page == page &&
        other.pageSize == pageSize &&
        other.totalItems == totalItems &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode => Object.hash(page, pageSize, totalItems, totalPages);

  @override
  String toString() =>
      'PaginationDto(page: $page, pageSize: $pageSize, totalItems: $totalItems, totalPages: $totalPages)';
}
