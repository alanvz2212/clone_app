import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/stock_model.dart';
import '../bloc/stock_bloc.dart';
import '../bloc/stock_event.dart';
import '../bloc/stock_state.dart';

class StockScreen extends StatefulWidget {
  final int? itemId;
  
  const StockScreen({super.key, this.itemId});
  
  void _navigateToStocks(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const StockScreen()));
  }

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final TextEditingController _itemIdController = TextEditingController();
  late StockBloc _stockBloc;

  @override
  void initState() {
    super.initState();
    _stockBloc = StockBloc();
    
    if (widget.itemId != null) {
      _itemIdController.text = widget.itemId.toString();
      _stockBloc.add(FetchStockDetails(widget.itemId!));
    }
  }

  void _onSearchPressed() {
    final itemIdText = _itemIdController.text.trim();
    if (itemIdText.isNotEmpty) {
      final itemId = int.tryParse(itemIdText);
      if (itemId != null) {
        _stockBloc.add(FetchStockDetails(itemId));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid item ID'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item ID'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _stockBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Stock Details'),
          backgroundColor: Colors.blue[600],
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Section
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _itemIdController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Item ID',
                            hintText: 'Enter item ID (e.g., 85208)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      BlocBuilder<StockBloc, StockState>(
                        builder: (context, state) {
                          final isLoading = state is StockLoading;
                          return ElevatedButton(
                            onPressed: isLoading ? null : _onSearchPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text('Search'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Content Section
              Expanded(
                child: BlocBuilder<StockBloc, StockState>(
                  builder: (context, state) {
                    return _buildContent(state);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(StockState state) {
    if (state is StockLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading stock details...'),
          ],
        ),
      );
    }

    if (state is StockError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final itemIdText = _itemIdController.text.trim();
                if (itemIdText.isNotEmpty) {
                  final itemId = int.tryParse(itemIdText);
                  if (itemId != null) {
                    _stockBloc.add(FetchStockDetails(itemId));
                  }
                }
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is StockEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No stock details found',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try searching with a different item ID',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (state is StockLoaded) {
      return _buildStockList(state.stockResponse);
    }

    // Initial state
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Enter an item ID to search for stock details',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStockList(StockResponse stockResponse) {
    final stockDetails = stockResponse.stockDetails;
    final itemName = stockDetails.isNotEmpty ? stockDetails.first.item.name : 'Unknown Item';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Item Info Header
        Card(
          elevation: 4,
          color: Colors.blue[50],
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  itemName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Item ID: ${stockDetails.first.itemId}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        // Stock Details List
        Text(
          'Stock Details by Warehouse (${stockDetails.length} locations)',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        
        Expanded(
          child: ListView.builder(
            itemCount: stockDetails.length,
            itemBuilder: (context, index) {
              final stock = stockDetails[index];
              return _buildStockCard(stock);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStockCard(StockDetail stock) {
    final currentStock = stock.currentStock;
    final pendingQty = stock.pendingPackageQuantity;
    
    Color stockColor = Colors.grey;
    if (currentStock > 0) {
      stockColor = Colors.green;
    } else if (currentStock < 0) {
      stockColor = Colors.red;
    }

    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warehouse Header
            Row(
              children: [
                Icon(
                  Icons.warehouse,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    stock.warehouse.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (stock.warehouse.code != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      stock.warehouse.code!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            
            if (stock.warehouse.address != null || stock.warehouse.city != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.grey[600],
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      [
                        stock.warehouse.address,
                        stock.warehouse.address2,
                        stock.warehouse.city,
                      ].where((e) => e != null && e.isNotEmpty).join(', '),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            const Divider(height: 24),
            
            // Stock Information
            Row(
              children: [
                Expanded(
                  child: _buildStockInfo(
                    'Current Stock',
                    currentStock.toString(),
                    stockColor,
                    Icons.inventory,
                  ),
                ),
                Expanded(
                  child: _buildStockInfo(
                    'Pending Qty',
                    pendingQty.toString(),
                    Colors.orange,
                    Icons.pending_actions,
                  ),
                ),
              ],
            ),
            
            if (stock.openingStock != 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStockInfo(
                      'Opening Stock',
                      stock.openingStock.toString(),
                      Colors.blue,
                      Icons.start,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStockInfo(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    _stockBloc.close();
    super.dispose();
  }
}