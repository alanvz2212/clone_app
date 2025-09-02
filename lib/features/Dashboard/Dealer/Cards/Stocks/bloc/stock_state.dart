import 'package:equatable/equatable.dart';
import '../models/stock_model.dart';

abstract class StockState extends Equatable {
  const StockState();

  @override
  List<Object?> get props => [];
}

class StockInitial extends StockState {
  const StockInitial();
}

class StockLoading extends StockState {
  const StockLoading();
}

class StockLoaded extends StockState {
  final StockResponse stockResponse;

  const StockLoaded(this.stockResponse);

  @override
  List<Object> get props => [stockResponse];
}

class StockError extends StockState {
  final String message;

  const StockError(this.message);

  @override
  List<Object> get props => [message];
}

class StockEmpty extends StockState {
  const StockEmpty();
}