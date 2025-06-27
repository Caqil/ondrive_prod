import 'package:serverpod/serverpod.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pagination.g.dart';

@JsonSerializable()
class Pagination extends SerializableEntity {
  @override
  int? id;

  int page;
  int limit;
  int totalItems;
  int totalPages;
  bool hasNext;
  bool hasPrevious;
  int? nextPage;
  int? previousPage;
  int offset;
  PaginationLinks? links;

  Pagination({
    this.id,
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    this.nextPage,
    this.previousPage,
    required this.offset,
    this.links,
  });

  factory Pagination.fromParams({
    required int page,
    required int limit,
    required int totalItems,
    String? baseUrl,
  }) {
    final totalPages = (totalItems / limit).ceil();
    final hasNext = page < totalPages;
    final hasPrevious = page > 1;
    final offset = (page - 1) * limit;

    PaginationLinks? links;
    if (baseUrl != null) {
      links = PaginationLinks.fromParams(
        baseUrl: baseUrl,
        page: page,
        limit: limit,
        totalPages: totalPages,
        hasNext: hasNext,
        hasPrevious: hasPrevious,
      );
    }

    return Pagination(
      page: page,
      limit: limit,
      totalItems: totalItems,
      totalPages: totalPages,
      hasNext: hasNext,
      hasPrevious: hasPrevious,
      nextPage: hasNext ? page + 1 : null,
      previousPage: hasPrevious ? page - 1 : null,
      offset: offset,
      links: links,
    );
  }

  factory Pagination.fromJson(Map<String, dynamic> json) =>
      _$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}

@JsonSerializable()
class PaginationLinks extends SerializableEntity {
  @override
  int? id;

  String? first;
  String? last;
  String? previous;
  String? next;
  String current;

  PaginationLinks({
    this.id,
    this.first,
    this.last,
    this.previous,
    this.next,
    required this.current,
  });

  factory PaginationLinks.fromParams({
    required String baseUrl,
    required int page,
    required int limit,
    required int totalPages,
    required bool hasNext,
    required bool hasPrevious,
  }) {
    final cleanBaseUrl =
        baseUrl.contains('?') ? '$baseUrl&page=' : '$baseUrl?page=';

    return PaginationLinks(
      first: totalPages > 0 ? '${cleanBaseUrl}1&limit=$limit' : null,
      last: totalPages > 0 ? '$cleanBaseUrl$totalPages&limit=$limit' : null,
      previous: hasPrevious ? '$cleanBaseUrl${page - 1}&limit=$limit' : null,
      next: hasNext ? '$cleanBaseUrl${page + 1}&limit=$limit' : null,
      current: '$cleanBaseUrl$page&limit=$limit',
    );
  }

  factory PaginationLinks.fromJson(Map<String, dynamic> json) =>
      _$PaginationLinksFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationLinksToJson(this);
}

@JsonSerializable()
class PaginationRequest extends SerializableEntity {
  @override
  int? id;

  int page;
  int limit;
  String? sortBy;
  SortOrder? sortOrder;
  Map<String, dynamic>? filters;

  PaginationRequest({
    this.id,
    this.page = 1,
    this.limit = 20,
    this.sortBy,
    this.sortOrder,
    this.filters,
  });

  int get offset => (page - 1) * limit;

  factory PaginationRequest.fromJson(Map<String, dynamic> json) =>
      _$PaginationRequestFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationRequestToJson(this);
}

enum SortOrder {
  asc,
  desc,
}
