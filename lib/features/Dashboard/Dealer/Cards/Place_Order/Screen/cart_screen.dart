import 'package:clone/constants/string_constants.dart';
// import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/provider/cart_provider.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<String, TextEditingController> _controllers = {};

  void _updateQuantity(
    CartProvider cartProvider,
    String itemId,
    String value,
    BuildContext context,
  ) async {
    int? newQuantity = int.tryParse(value);
    if (newQuantity != null && newQuantity > 0) {
      await cartProvider.updateQuantity(itemId, newQuantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quantity updated to $newQuantity'),
          backgroundColor: Colors.green,
          duration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid quantity'),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Consumer<CartProvider>(
              builder: (context, cartProvider, child) {
                return Text(
                  'Cart (${cartProvider.totalItems} items)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ],
        ),
        titleSpacing: 0,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          if (cartProvider.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 70,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cartProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = cartProvider.items[index];

                    // Create a controller for each item to track text changes
                    _controllers[item.itemId] ??= TextEditingController(
                      text: '${item.quantity}',
                    );

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            spreadRadius: 0.5,
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Item Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Qty: ${item.quantity}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      '₹${item.total.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Quantity Input + Tick Button + Delete
                          Row(
                            children: [
                              // Quantity Input Field
                              Container(
                                width: 60,
                                height: 35,
                                child: TextFormField(
                                  controller: _controllers[item.itemId],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),

                              // Tick Button
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 22,
                                ),
                                onPressed: () {
                                  final value = _controllers[item.itemId]!.text
                                      .trim();
                                  _updateQuantity(
                                    cartProvider,
                                    item.itemId,
                                    value,
                                    context,
                                  );
                                },
                              ),

                              const SizedBox(width: 4),
                              // Delete Button
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Remove Item'),
                                        content: Text(
                                          'Remove ${item.name} from cart?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              cartProvider.removeItem(
                                                item.itemId,
                                              );
                                              Navigator.of(context).pop();
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    '${item.name} removed from cart',
                                                  ),
                                                  backgroundColor: Colors.red,
                                                  duration: const Duration(
                                                    milliseconds: 1000,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Remove',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                  size: 20,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 32,
                                  minHeight: 32,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Cart Summary
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey[200]!, width: 1),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Items:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '${cartProvider.totalItems}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Amount:',
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          '₹${cartProvider.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // Clear Cart Button
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Clear Cart'),
                                    content: const Text(
                                      'Are you sure you want to clear all items from the cart?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          cartProvider.clearCart();
                                          Navigator.of(context).pop();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text('Cart cleared'),
                                              backgroundColor: Colors.black,
                                              duration: Duration(
                                                milliseconds: 1000,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Clear',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Clear Cart',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Proceed to Checkout Button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: () {
                              // Checkout function here
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Proceed to Checkout',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // App Version
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
          );
        },
      ),
    );
  }
}
