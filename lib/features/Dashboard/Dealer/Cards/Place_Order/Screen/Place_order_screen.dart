import 'package:clone/constants/string_constants.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/Screen/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_item_bloc.dart';
import '../bloc/search_item_event.dart';
import '../bloc/search_item_state.dart';
import '../models/search_item_model.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  SearchItem? selectedItem;
  Map<String, int> itemQuantities = {}; // Track quantities for each item
  Map<String, TextEditingController> quantityControllers =
      {}; // Controllers for quantity inputs

  List<Map<String, dynamic>> savedOrders = [];
  Map<String, SearchItem> itemsMap = {}; // Store item details for saved orders

  @override
  void dispose() {
    _searchController.dispose();
    // Dispose all quantity controllers
    for (var controller in quantityControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });

    if (value.trim().isNotEmpty) {
      // Trigger search with BLoC
      context.read<SearchItemBloc>().add(
        SearchItemRequested(searchQuery: value.trim()),
      );
    } else {
      // Clear search results
      context.read<SearchItemBloc>().add(const SearchItemCleared());
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      searchQuery = '';
      selectedItem = null;
    });
    context.read<SearchItemBloc>().add(const SearchItemCleared());
  }

  void _updateQuantity(String itemId, String value, SearchItem item) {
    int? quantity = int.tryParse(value);
    if (quantity != null && quantity >= 0) {
      setState(() {
        if (quantity == 0) {
          itemQuantities.remove(itemId);
        } else {
          itemQuantities[itemId] = quantity;
        }
      });

      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            quantity == 0
                ? '${item.name}: Removed from order'
                : '${item.name}: Quantity $quantity',
          ),
          backgroundColor: quantity == 0 ? Colors.orange : Colors.green,
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  TextEditingController _getQuantityController(String itemId) {
    if (!quantityControllers.containsKey(itemId)) {
      quantityControllers[itemId] = TextEditingController();
    }
    return quantityControllers[itemId]!;
  }

  void _saveOrder() {
    if (itemQuantities.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items to save'),
          backgroundColor: Colors.black,
          duration: Duration(milliseconds: 90),
        ),
      );
      return;
    }
    // Create order data
    List<Map<String, dynamic>> orderItems = [];
    double totalAmount = 0.0;
    int totalQuantity = 0;
    itemQuantities.forEach((itemId, quantity) {
      if (itemsMap.containsKey(itemId)) {
        final item = itemsMap[itemId]!;
        final itemTotal = (item.currentSalesPrice ?? 0.0) * quantity;
        totalAmount += itemTotal;
        totalQuantity += quantity;
        orderItems.add({
          'itemId': itemId,
          'name': item.name,
          'price': item.currentSalesPrice,
          'quantity': quantity,
          'total': itemTotal,
        });
      }
    });
    // Add to saved orders
    setState(() {
      savedOrders.add({
        'orderId': DateTime.now().millisecondsSinceEpoch.toString(),
        'timestamp': DateTime.now(),
        'items': orderItems,
        'totalAmount': totalAmount,
        'totalQuantity': totalQuantity,
        'totalItems': orderItems.length,
      });
      // Clear current order
      itemQuantities.clear();
      for (var controller in quantityControllers.values) {
        controller.clear();
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order saved successfully!${orderItems.length}items(Total:₹${totalAmount.toStringAsFixed(2)} )',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _removeOrder(int index) {
    setState(() {
      savedOrders.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order removed'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        elevation: 2,
        shadowColor: Colors.blue.withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo.png',
              width: 70,
              height: 35,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 25),
            const Text(
              'Place Order',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 90),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              icon: Icon(Icons.shopping_cart_outlined),
            ),
          ],
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
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products',
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
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          // Main Content Area - Search Results (Top Half)
          Expanded(
            flex: 1, // Top half of the screen
            child: BlocBuilder<SearchItemBloc, SearchItemState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.error != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.error}',
                          style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            if (searchQuery.isNotEmpty) {
                              context.read<SearchItemBloc>().add(
                                SearchItemRequested(searchQuery: searchQuery),
                              );
                            }
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                if (state.items.isEmpty && searchQuery.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items found for "$searchQuery"',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (state.items.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      final itemId = item.id?.toString() ?? index.toString();
                      final currentQuantity = itemQuantities[itemId] ?? 0;
                      final quantityController = _getQuantityController(itemId);

                      itemsMap[itemId] = item;

                      // Update controller text if quantity changed externally
                      if (quantityController.text !=
                          currentQuantity.toString()) {
                        quantityController.text = currentQuantity == 0
                            ? ''
                            : currentQuantity.toString();
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Row(
                          children: [
                            // Item Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name ?? 'Unknown Item',
                                    style: const TextStyle(
                                      // fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (item.currentSalesPrice != null)
                                    Text(
                                      '₹${item.currentSalesPrice!.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        color: Colors.green[600],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  if (currentQuantity > 0 &&
                                      item.currentSalesPrice != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Total: ₹${(item.currentSalesPrice! * currentQuantity).toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.blue[600],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Quantity Input Field
                            Container(
                              width: 80,
                              margin: const EdgeInsets.only(right: 8),
                              child: TextField(
                                controller: quantityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(
                                    4,
                                  ), // Max 4 digits
                                ],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Qty',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 12,
                                  ),
                                  filled: true,
                                  fillColor: currentQuantity > 0
                                      ? Colors.blue[50]
                                      : Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: currentQuantity > 0
                                          ? Colors.blue[200]!
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Colors.blue,
                                      width: 2,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: currentQuantity > 0
                                          ? Colors.blue[200]!
                                          : Colors.grey[300]!,
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                ),
                                onChanged: (value) {
                                  _updateQuantity(itemId, value, item);
                                },
                                onSubmitted: (value) {
                                  _updateQuantity(itemId, value, item);
                                },
                              ),
                            ),

                            // Remove Item Button
                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 24,
                              ),
                              onPressed: () {
                                // Remove item from the list and clear its quantity
                                setState(() {
                                  itemQuantities.remove(itemId);
                                  quantityControllers[itemId]?.clear();
                                });

                                context.read<SearchItemBloc>().add(
                                  SearchItemRemoved(item: item),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Removed: ${item.name}'),
                                    backgroundColor: Colors.red,
                                    duration: const Duration(milliseconds: 90),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }

                // Default state - no search
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'Search for products to place an order',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Save Button
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: _saveOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Add Item',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.grey[100],
          //       border: Border(
          //         top: BorderSide(color: Colors.grey[300]!, width: 1),
          //       ),
          //     ),
          //     child: Column(
          //       children: [
          //         Container(
          //           width: double.infinity,
          //           padding: EdgeInsets.all(16.0),
          //           decoration: BoxDecoration(
          //             color: Colors.white,
          //             border: Border(
          //               bottom: BorderSide(color: Colors.grey[200]!, width: 1),
          //             ),
          //           ),
          //           child: Text(
          //             savedOrders.isEmpty
          //                 ? 'Saved Items'
          //                 : 'Saved Items (${savedOrders.length})',
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.w400,
          //               fontFamily: 'Poppins',
          //               color: Colors.black87,
          //             ),
          //           ),
          //         ),
          //         // Orders List
          //         Expanded(
          //           child: savedOrders.isEmpty
          //               ? Center(
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.center,
          //                     children: [
          //                       Icon(
          //                         Icons.shopping_cart_outlined,
          //                         size: 64,
          //                         color: Colors.grey[400],
          //                       ),
          //                       const SizedBox(height: 16),
          //                       Text(
          //                         'No saved orders yet',
          //                         style: TextStyle(
          //                           color: Colors.grey[600],
          //                           fontSize: 16,
          //                         ),
          //                       ),
          //                       const SizedBox(height: 8),
          //                       Text(
          //                         'Add items and save to see them here',
          //                         style: TextStyle(
          //                           color: Colors.grey[500],
          //                           fontSize: 14,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 )
          //               : ListView.builder(
          //                   padding: EdgeInsets.all(16.0),
          //                   itemCount: savedOrders.length,
          //                   itemBuilder: (BuildContext context, int index) {
          //                     final order = savedOrders[index];
          //                     final orderItems =
          //                         order['items'] as List<Map<String, dynamic>>;
          //                     final timestamp = order['timestamp'] as DateTime;
          //                     return Container(
          //                       margin: const EdgeInsets.only(bottom: 12),
          //                       padding: const EdgeInsets.all(16),
          //                       decoration: BoxDecoration(
          //                         color: Colors.white,
          //                         borderRadius: BorderRadius.circular(12),
          //                         border: Border.all(color: Colors.grey[200]!),
          //                         boxShadow: [
          //                           BoxShadow(
          //                             color: Colors.grey.withOpacity(0.1),
          //                             spreadRadius: 1,
          //                             blurRadius: 4,
          //                             offset: const Offset(0, 2),
          //                           ),
          //                         ],
          //                       ),
          //                       child: Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceBetween,
          //                             children: [
          //                               Text(''),
          //                               Row(
          //                                 children: [
          //                                   const SizedBox(width: 12),
          //                                   IconButton(
          //                                     icon: const Icon(
          //                                       Icons.delete_outline,
          //                                       color: Colors.red,
          //                                       size: 24,
          //                                     ),
          //                                     onPressed: () =>
          //                                         _removeOrder(index),
          //                                     padding: EdgeInsets.zero,
          //                                     constraints:
          //                                         const BoxConstraints(),
          //                                   ),
          //                                 ],
          //                               ),
          //                             ],
          //                           ),
          //                           Container(
          //                             padding: EdgeInsets.symmetric(
          //                               horizontal: 12,
          //                               vertical: 8,
          //                             ),
          //                             child: Text(
          //                               'Total Qty: ${order['totalQuantity']}',
          //                               style: TextStyle(fontSize: 14),
          //                             ),
          //                           ),
          //                           Wrap(
          //                             spacing: 6,
          //                             runSpacing: 6,
          //                             children: orderItems.map((item) {
          //                               return Container(
          //                                 padding: const EdgeInsets.symmetric(
          //                                   horizontal: 10,
          //                                   vertical: 6,
          //                                 ),
          //                                 child: Text(
          //                                   '${item['name']}',
          //                                   style: TextStyle(fontSize: 12),
          //                                 ),
          //                               );
          //                             }).toList(),
          //                           ),
          //                         ],
          //                       ),
          //                     );
          //                   },
          //                 ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'App Version - ${StringConstant.version}',
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
