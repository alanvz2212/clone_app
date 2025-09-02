import 'package:equatable/equatable.dart';

abstract class StockEvent extends Equatable {
  const StockEvent();

  @override
  List<Object> get props => [];
}

class FetchStockDetails extends StockEvent {
  final int itemId;

  const FetchStockDetails(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class ClearStockDetails extends StockEvent {
  const ClearStockDetails();
}