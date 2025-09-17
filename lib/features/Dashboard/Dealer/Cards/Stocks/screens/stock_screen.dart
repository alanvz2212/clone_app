import 'package:flutter/cupertino.dart';
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
  final TextEditingController _itemNameController = TextEditingController();
  late StockBloc _stockBloc;
  late SearchItemBloc _searchItemBloc;
  String searchQuery = '';
  bool _showSuggestions = false;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    _stockBloc = StockBloc();
    _searchItemBloc = getIt<SearchItemBloc>();
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
      _searchItemBloc.add(SearchItemRequested(searchQuery: value.trim()));
      _showSuggestions = true;
      _showOverlay();
    } else {
      _searchItemBloc.add(const SearchItemCleared());
      _hideOverlay();
    }
  }
  void _clearSearch() {
    _itemNameController.clear();
    setState(() {
      searchQuery = '';
    });
    _searchItemBloc.add(const SearchItemCleared());
    _hideOverlay();
  }
  void _onSearchPressed() {
    final itemNameText = _itemNameController.text.trim();
    if (itemNameText.isNotEmpty) {
      _stockBloc.add(FetchStockByName(itemNameText));
      _hideOverlay();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an item name'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }
  void _onItemSelected(SearchItem item) {
    _itemNameController.text = item.name ?? '';
    setState(() {
      searchQuery = item.name ?? '';
    });
    _hideOverlay();
    if (item.id != null) {
      _stockBloc.add(FetchStockDetails(item.id!));
    }
  }
  void _showOverlay() {
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: MediaQuery.of(context).size.width - 32,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 60),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: BlocBuilder<SearchItemBloc, SearchItemState>(
                bloc: _searchItemBloc,
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (state.items.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No items found'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.items.length > 5 ? 5 : state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          item.name ?? 'Unknown Item',
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: item.description != null
                            ? Text(
                                item.description!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        onTap: () => _onItemSelected(item),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }
  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() {
        _showSuggestions = false;
      });
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
          title: Row(
            children: [
              Image.asset(
                'assets/logo1.png',
               width: 80,
                        height: 80,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 25),
              const Text(
                'Stock Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          titleSpacing: 0,
        ),
        body: Column(
          children: [
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
              child: CompositedTransformTarget(
                link: _layerLink,
                child: TextField(
                  controller: _itemNameController,
                  onChanged: _onSearchChanged,
                  keyboardType: TextInputType.text,
                  onTap: () {
                    if (searchQuery.isNotEmpty) {
                      _showOverlay();
                    }
                  },
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
            ),
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
            Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 16,
                top: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'App Version - ${StringConstant.version}',
                    style: TextStyle(
                      color: Color.fromARGB(255, 95, 91, 91),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Image.asset('assets/33.png', width: 100, height: 50),
                ],
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Enter an item name to search for stock details',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              itemName,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Table(
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.grey[300]!),
                  verticalInside: BorderSide(color: Colors.grey[300]!),
                ),
                columnWidths: {
                  0: FixedColumnWidth(50),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!, width: 2),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'S.No.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Warehouse Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Stock',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  ...stockDetails.asMap().entries.map((entry) {
                    final index = entry.key;
                    final stock = entry.value;
                    return TableRow(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stock.warehouse.name ?? 'Unknown Warehouse',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (stock.warehouse.code != null)
                                Text(
                                  'Code: ${stock.warehouse.code}',
                                  style: TextStyle(fontSize: 10),
                                ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${stock.currentStock ?? 0}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Pending Order Quantity:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$totalPendingQty',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Net Available Quantity:',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '$netAvailableQty',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
    _hideOverlay();
    _itemNameController.dispose();
    _stockBloc.close();
    _searchItemBloc.close();
    super.dispose();
  }
}

