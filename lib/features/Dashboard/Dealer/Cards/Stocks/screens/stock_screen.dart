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
  final TextEditingController _itemNameController = TextEditingController();
  late StockBloc _stockBloc;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _stockBloc = StockBloc();

    if (widget.itemId != null) {
      _itemNameController.text = widget.itemId.toString();
      _stockBloc.add(FetchStockDetails(widget.itemId!));
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });

    if (value.trim().isNotEmpty) {
      // Search by item name instead of ID
      _stockBloc.add(FetchStockByName(value.trim()));
    }
  }

  void _clearSearch() {
    _itemNameController.clear();
    setState(() {
      searchQuery = '';
    });
  }

  void _onSearchPressed() {
    final itemNameText = _itemNameController.text.trim();
    if (itemNameText.isNotEmpty) {
      _stockBloc.add(FetchStockByName(itemNameText));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item name'),
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
          backgroundColor: Color(0xFFCEB007),
          elevation: 2,
          shadowColor: Color(0xFFCEB007).withOpacity(0.3),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text(
            'Stock Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          titleSpacing: 0,
        ),
        body: Column(
          children: [
            // Search Field Container
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                controller: _itemNameController,
                onChanged: _onSearchChanged,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Search by Item Name',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Colors.grey),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFCEB007),
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocBuilder<StockBloc, StockState>(
                  builder: (context, state) {
                    return _buildContent(state);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(StockState state) {
    if (state is StockLoading) {
      return const Center(child: Text('Loading stock details...'));
    }

    if (state is StockError) {
      return Center(child: Text(state.message, textAlign: TextAlign.center));
    }

    if (state is StockEmpty) {
      return const Center(child: Text('No stock details found'));
    }

    if (state is StockLoaded) {
      return _buildStockList(state.stockResponse);
    }

    return const Center(
      child: Text('Enter an item name to search for stock details'),
    );
  }

  Widget _buildStockList(StockResponse stockResponse) {
    final stockDetails = stockResponse.stockDetails;
    final itemName = stockDetails.isNotEmpty
        ? stockDetails.first.item.name
        : 'Unknown Item';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Item Information',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(itemName),
                const SizedBox(height: 4),
                Text('Item ID: ${stockDetails.first.itemId}'),
              ],
            ),
          ),
        ),
        // Card(
        //   child: Padding(
        //     padding: const EdgeInsets.all(16.0),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.start,
        //       children: [
        //         Text('Item Information'),
        //         const SizedBox(height: 8),
        //         Text(itemName),
        //         const SizedBox(height: 4),
        //         Text('Item ID: ${stockDetails.first.itemId}'),
        //       ],
        //     ),
        //   ),
        // ),
        const SizedBox(height: 16),
        Text('Stock Details (${stockDetails.length} locations)'),
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stock.warehouse.name),
            if (stock.warehouse.code != null)
              Text('Code: ${stock.warehouse.code}'),

            if (stock.warehouse.address != null ||
                stock.warehouse.city != null) ...[
              const SizedBox(height: 8),
              Text(
                [
                  stock.warehouse.address,
                  stock.warehouse.address2,
                  stock.warehouse.city,
                ].where((e) => e != null && e.isNotEmpty).join(', '),
              ),
            ],

            const SizedBox(height: 12),
            Text('Current Stock: ${stock.currentStock}'),
            Text('Pending Qty: ${stock.pendingPackageQuantity}'),
            if (stock.openingStock != 0)
              Text('Opening Stock: ${stock.openingStock}'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _stockBloc.close();
    super.dispose();
  }
}
