// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) => Pagination(
      id: (json['id'] as num?)?.toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      totalItems: (json['totalItems'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasNext: json['hasNext'] as bool,
      hasPrevious: json['hasPrevious'] as bool,
      nextPage: (json['nextPage'] as num?)?.toInt(),
      previousPage: (json['previousPage'] as num?)?.toInt(),
      offset: (json['offset'] as num).toInt(),
      links: json['links'] == null
          ? null
          : PaginationLinks.fromJson(json['links'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'id': instance.id,
      'page': instance.page,
      'limit': instance.limit,
      'totalItems': instance.totalItems,
      'totalPages': instance.totalPages,
      'hasNext': instance.hasNext,
      'hasPrevious': instance.hasPrevious,
      'nextPage': instance.nextPage,
      'previousPage': instance.previousPage,
      'offset': instance.offset,
      'links': instance.links,
    };

PaginationLinks _$PaginationLinksFromJson(Map<String, dynamic> json) =>
    PaginationLinks(
      id: (json['id'] as num?)?.toInt(),
      first: json['first'] as String?,
      last: json['last'] as String?,
      previous: json['previous'] as String?,
      next: json['next'] as String?,
      current: json['current'] as String,
    );

Map<String, dynamic> _$PaginationLinksToJson(PaginationLinks instance) =>
    <String, dynamic>{
      'id': instance.id,
      'first': instance.first,
      'last': instance.last,
      'previous': instance.previous,
      'next': instance.next,
      'current': instance.current,
    };

PaginationRequest _$PaginationRequestFromJson(Map<String, dynamic> json) =>
    PaginationRequest(
      id: (json['id'] as num?)?.toInt(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      sortBy: json['sortBy'] as String?,
      sortOrder: $enumDecodeNullable(_$SortOrderEnumMap, json['sortOrder']),
      filters: json['filters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaginationRequestToJson(PaginationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'page': instance.page,
      'limit': instance.limit,
      'sortBy': instance.sortBy,
      'sortOrder': _$SortOrderEnumMap[instance.sortOrder],
      'filters': instance.filters,
    };

const _$SortOrderEnumMap = {
  SortOrder.asc: 'asc',
  SortOrder.desc: 'desc',
};
