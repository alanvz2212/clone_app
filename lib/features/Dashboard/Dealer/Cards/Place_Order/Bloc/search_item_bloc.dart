import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/search_item_model.dart';
import '../repositories/search_item_repository.dart';
import 'search_item_event.dart';
import 'search_item_state.dart';
class SearchItemBloc extends Bloc<SearchItemEvent, SearchItemState> {
  final SearchItemRepository _repository;
  SearchItemBloc({required SearchItemRepository repository})
    : _repository = repository,
      super(const SearchItemState()) {
    on<SearchItemRequested>(_onSearchItemRequested);
    on<SearchItemCleared>(_onSearchItemCleared);
    on<SearchItemRemoved>(_onSearchItemRemoved);
  }
  Future<void> _onSearchItemRequested(
    SearchItemRequested event,
    Emitter<SearchItemState> emit,
  ) async {
    if (event.searchQuery.trim().isEmpty) {
      emit(
        state.copyWith(items: [], error: null, searchQuery: event.searchQuery),
      );
      return;
    }
    emit(
      state.copyWith(
        isLoading: true,
        error: null,
        searchQuery: event.searchQuery,
      ),
    );
    try {
      final request = SearchItemRequest(search: event.searchQuery);
      final response = await _repository.searchItems(request);
      if (response.success && response.items != null) {
        emit(
          state.copyWith(isLoading: false, items: response.items!, error: null),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            items: [],
            error: response.error ?? 'Search failed',
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          items: [],
          error: 'Search failed: ${e.toString()}',
        ),
      );
    }
  }
  Future<void> _onSearchItemCleared(
    SearchItemCleared event,
    Emitter<SearchItemState> emit,
  ) async {
    emit(const SearchItemState());
  }
  Future<void> _onSearchItemRemoved(
    SearchItemRemoved event,
    Emitter<SearchItemState> emit,
  ) async {
    final updatedItems = List<SearchItem>.from(state.items)
      ..removeWhere((item) => item.id == event.item.id);
    emit(
      state.copyWith(
        items: updatedItems,
      ),
    );
  }
}

