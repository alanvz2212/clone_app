import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/stock_service.dart';
import 'stock_event.dart';
import 'stock_state.dart';

class StockBloc extends Bloc<StockEvent, StockState> {
  final StockService stockService;

  StockBloc({StockService? stockService}) 
      : stockService = stockService ?? StockService(),
        super(const StockInitial()) {
    on<FetchStockDetails>(_onFetchStockDetails);
    on<ClearStockDetails>(_onClearStockDetails);
    on<FetchStockByName>(_onFetchStockByName);
  }

  Future<void> _onFetchStockDetails(
    FetchStockDetails event,
    Emitter<StockState> emit,
  ) async {
    emit(const StockLoading());

    try {
      final stockResponse = await StockService.getItemStockDetails(event.itemId);
      
      if (stockResponse != null) {
        if (stockResponse.success && stockResponse.stockDetails.isNotEmpty) {
          emit(StockLoaded(stockResponse));
        } else {
          emit(const StockEmpty());
        }
      } else {
        emit(const StockError('Failed to load stock details'));
      }
    } catch (e) {
      emit(StockError('Error: ${e.toString()}'));
    }
  }

  void _onClearStockDetails(
    ClearStockDetails event,
    Emitter<StockState> emit,
  ) {
    emit(const StockInitial());
  }

  Future<void> _onFetchStockByName(
    FetchStockByName event,
    Emitter<StockState> emit,
  ) async {
    emit(const StockLoading());

    try {
      final stockResponse = await StockService.getItemStockDetailsByName(event.itemName);
      
      if (stockResponse != null) {
        if (stockResponse.success && stockResponse.stockDetails.isNotEmpty) {
          emit(StockLoaded(stockResponse));
        } else {
          emit(const StockEmpty());
        }
      } else {
        emit(const StockError('No items found with that name'));
      }
    } catch (e) {
      emit(StockError('Error: ${e.toString()}'));
    }
  }
}