import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/stock_model.dart';
import '../bloc/stock_bloc.dart';
import '../bloc/stock_event.dart';
import '../bloc/stock_state.dart';
import '../../../../../../constants/string_constants.dart';
import '../../Place_Order/models/search_item_model.dart';
import '../../Place_Order/bloc/search_item_bloc.dart';
import '../../Place_Order/bloc/search_item_event.dart';
import '../../Place_Order/bloc/search_item_state.dart';
import '../../../../../../core/di/injection.dart';

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
  final TextEditingController _searchController = TextEditingController();
  late StockBloc _stockBloc;
  late SearchItemBloc _searchItemBloc;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _stockBloc = StockBloc();
    _searchItemBloc = getIt<SearchItemBloc>();
    if (widget.itemId != null) {
      _searchController.text = widget.itemId.toString();
      _stockBloc.add(FetchStockDetails(widget.itemId!));
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
    if (value.trim().isNotEmpty) {
      _searchItemBloc.add(SearchItemRequested(searchQuery: value.trim()));
    } else {
      _searchItemBloc.add(const SearchItemCleared());
      _stockBloc.add(const ClearStockDetails());
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchQuery = '';
    });
    _searchItemBloc.add(const SearchItemCleared());
    _stockBloc.add(const ClearStockDetails());
  }

  void _onItemSelected(SearchItem item) {
    _searchController.text = item.name ?? '';
    setState(() {
      searchQuery = item.name ?? '';
    });
    _searchItemBloc.add(const SearchItemCleared());
    if (item.id != null) {
      _stockBloc.add(FetchStockDetails(item.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _stockBloc),
        BlocProvider(create: (context) => _searchItemBloc),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFFCEB007),
          elevation: 3,
          shadowColor: const Color(0xFFCEB007).withOpacity(0.4),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/logo1.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 20),
              const Text(
                'Stock Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Search Items...',
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
                      vertical: 14,
                    ),
                  ),
                ),
              ),

              Expanded(
                flex: 1,
                child: BlocBuilder<SearchItemBloc, SearchItemState>(
                  builder: (context, searchState) {
                    return BlocBuilder<StockBloc, StockState>(
                      builder: (context, stockState) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: _buildContent(searchState, stockState),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App Version - ${StringConstant.version}',
                    style: const TextStyle(
                      color: Color.fromARGB(255, 95, 91, 91),
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                  Image.asset('assets/33.png', width: 90, height: 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(SearchItemState searchState, StockState stockState) {
    if (stockState is StockLoaded) {
      return _buildStockList(stockState.stockResponse);
    }
    if (stockState is StockLoading || searchState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (stockState is StockError) {
      return _buildError(stockState.message);
    }
    if (stockState is StockEmpty) {
      return _buildEmpty('No stock details found');
    }
    if (searchState.error != null && searchQuery.isNotEmpty) {
      return _buildError(searchState.error!);
    }
    if (searchState.items.isNotEmpty) {
      return _buildSearchList(searchState.items);
    }
    if (searchState.items.isEmpty && searchQuery.isNotEmpty) {
      return _buildEmpty('No items found for "$searchQuery"');
    }
    return _buildEmpty('Search for items to view stock details');
  }

  Widget _buildError(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.red, fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 60, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(color: Colors.grey, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchList(List<SearchItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            title: Text(
              item.name ?? 'Unknown Item',
              style: const TextStyle(fontSize: 14),
            ),
            subtitle: item.description != null
                ? Text(
                    item.description!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                : null,
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey,
            ),
            onTap: () => _onItemSelected(item),
          ),
        );
      },
    );
  }

  Widget _buildStockList(StockResponse stockResponse) {
    final stockDetails = stockResponse.stockDetails;
    final itemName = stockDetails.isNotEmpty
        ? stockDetails.first.item.name
        : 'Unknown Item';
    final totalPendingQty = stockDetails.fold<int>(
      0,
      (sum, stock) => sum + (stock.pendingPackageQuantity ?? 0),
    );
    final totalStockQty = stockDetails.fold<int>(
      0,
      (sum, stock) => sum + (stock.currentStock ?? 0),
    );
    final netAvailableQty = totalStockQty - totalPendingQty;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Table(
              border: TableBorder.symmetric(
                inside: BorderSide(color: Colors.grey[300]!),
              ),
              children: [
                const TableRow(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'S.No.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Warehouse Name',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Stock',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                ...stockDetails.asMap().entries.map((entry) {
                  final i = entry.key + 1;
                  final stock = entry.value;
                  return TableRow(
                    children: [
                      _cell(i.toString(), align: TextAlign.center),
                      _cell(stock.warehouse.name ?? 'Unknown'),
                      _cell(
                        '${stock.currentStock ?? 0}',
                        align: TextAlign.center,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _infoCard('Pending Order Quantity:', '$totalPendingQty'),
          const SizedBox(height: 8),
          _infoCard('Net Available Quantity:', '$netAvailableQty'),
        ],
      ),
    );
  }

  Widget _cell(String text, {TextAlign align = TextAlign.left}) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      textAlign: align,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );

  Widget _infoCard(String label, String value) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[300]!),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _searchController.dispose();
    _stockBloc.close();
    _searchItemBloc.close();
    super.dispose();
  }
}
