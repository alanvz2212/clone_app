import 'package:equatable/equatable.dart';
import '../models/search_item_model.dart';
class SearchItemState extends Equatable {
  final bool isLoading;
  final List<SearchItem> items;
  final String? error;
  final String searchQuery;
  const SearchItemState({
    this.isLoading = false,
    this.items = const [],
    this.error,
    this.searchQuery = '',
  });
  SearchItemState copyWith({
    bool? isLoading,
    List<SearchItem>? items,
    String? error,
    String? searchQuery,
  }) {
    return SearchItemState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
  @override
  List<Object?> get props => [isLoading, items, error, searchQuery];
}

