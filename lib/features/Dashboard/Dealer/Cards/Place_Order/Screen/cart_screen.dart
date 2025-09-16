import 'package:clone/constants/string_constants.dart';
import 'package:clone/features/Dashboard/Dealer/Cards/Place_Order/providers/cart_provider.dart';
import 'package:clone/core/di/injection.dart';
import 'package:clone/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final Map<String, TextEditingController> _controllers = {};
  bool _isProcessingCheckout = false;
  late UserService _userService;

  // Check if user is in UAE (you can modify this logic based on your app's user location detection)
  bool get isUAEUser =>
      true; // For now, set to true for testing. Replace with actual UAE detection logic

  // Tax rate (18% GST)
  static const double taxRate = 0.18;

  @override
  void initState() {
    super.initState();
    _userService = getIt<UserService>();
  }

  // API call method for checkout
  Future<void> _proceedToCheckout(CartProvider cartProvider) async {
    if (_isProcessingCheckout) return;

    setState(() {
      _isProcessingCheckout = true;
    });

    try {
      // Get current user's customer ID
      final customerId = await _userService.getCurrentCustomerIdWithFallback();

      // Prepare the mobile order items from cart
      List<Map<String, dynamic>> mobileOrderItems = cartProvider.items.map((
        item,
      ) {
        return {
          "id": 0,
          "referenceId": 0,
          "referenceType": "string",
          "companyId": 0,
          "mobileOrderId": 0,
          "itemId": int.tryParse(item.itemId) ?? 0,
          "itemQuantity": item.quantity,
          "completedQuantity": 0,
        };
      }).toList();

      // Prepare the request body
      Map<String, dynamic> requestBody = {
        "id": 0,
        "referenceId": 0,
        "referenceType": "string",
        "companyId": 0,
        "billTypeId": 0,
        "increment": 0,
        "invoice": "string",
        "customerId": customerId, // Use dynamic customer ID
        "mobileOrderStatusId": 1,
        "notes": "Notes",
        "mobileOrderItem": mobileOrderItems,
      };

      // Make the API call
      final response = await http.post(
        Uri.parse(
          'http://devapi.abm4trades.com/api/MobileOrder/NewMobileOrder',
        ),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer 659476889604ib26is5ods8ah9l',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['success'] == true) {
          // Success - clear cart and show success message
          cartProvider.clearCart();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  responseData['message'] ?? 'Order send successfully!',
                ),
                backgroundColor: Colors.black,
                duration: const Duration(seconds: 3),
              ),
            );

            // Navigate back or to order confirmation screen
            Navigator.of(context).pop();
          }
        } else {
          // API returned success: false
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  responseData['message'] ?? 'Failed to place order',
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }
      } else {
        // HTTP error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to place order. Status: ${response.statusCode}',
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Network or other error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error placing order: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingCheckout = false;
        });
      }
    }
  }

  void _updateQuantity(
    CartProvider cartProvider,
    String itemId,
    String value,
    BuildContext context,
  ) {
    int? newQuantity = int.tryParse(value);
    if (newQuantity != null && newQuantity > 0) {
      cartProvider.updateQuantity(itemId, newQuantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Quantity updated to $newQuantity'),
          backgroundColor: Colors.black,
          duration: const Duration(milliseconds: 800),
        ),
      );
    } else if (newQuantity == 0) {
      // Remove item if quantity is set to 0
      cartProvider.removeItem(itemId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item removed from cart'),
          backgroundColor: Colors.orange,
          duration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid quantity'),
          backgroundColor: Colors.red,
          duration: const Duration(milliseconds: 1000),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Color(0xFFCEB007),
        elevation: 2,
        shadowColor: Color(0xFFCEB007).withOpacity(0.3),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/logo1.png',
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
                                // Row(
                                //   children: [
                                //     Text(
                                //       'Price: ₹${item.price.toStringAsFixed(2)}',
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //         // fontWeight: FontWeight.w500,
                                //         fontSize: 12,
                                //       ),
                                //     ),
                                //     const SizedBox(width: 15),
                                //     Text(
                                //       'Total: ₹${item.total.toStringAsFixed(2)}',
                                //       style: TextStyle(
                                //         color: Colors.black,
                                //         // fontWeight: FontWeight.w600,
                                //         fontSize: 12,
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                // Only show price information if item has a price (not 0.0)
                                if (item.price > 0.0) ...[
                                  Row(
                                    children: [
                                      Text(
                                        'Price: ₹${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4), // Add some spacing
                                  // Show Total + Tax only for UAE users, otherwise show regular Total
                                  isUAEUser
                                      ? Text(
                                          'Total + Tax: ₹${(item.total + (item.total * taxRate)).toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            // fontWeight: FontWeight.w700,
                                            fontSize: 13,
                                          ),
                                        )
                                      : Text(
                                          'Total: ₹${item.total.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                ] else ...[
                                  // For items without price, show a message
                                  Text(
                                    'Price not available',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),

                          // Quantity Input + Tick Button + Delete - UPDATED TO MATCH PLACE ORDER SCREEN
                          Row(
                            children: [
                              // Quantity Input Field - UPDATED STYLE
                              Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 8),
                                child: TextFormField(
                                  controller: _controllers[item.itemId],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
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
                                    fillColor: item.quantity > 0
                                        ? Color(0xFFCEB007).withOpacity(0.1)
                                        : Colors.grey[100],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: item.quantity > 0
                                            ? Color(0xFFCEB007).withOpacity(0.5)
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFCEB007),
                                        width: 2,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: item.quantity > 0
                                            ? Color(0xFFCEB007).withOpacity(0.5)
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                              ),

                              // Tick Button - UPDATED STYLE
                              Container(
                                width: 50,
                                margin: const EdgeInsets.only(right: 8),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: item.quantity > 0
                                        ? Color(0xFFCEB007).withOpacity(0.1)
                                        : Colors.grey[100],
                                    padding: const EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: item.quantity > 0
                                            ? Color(0xFFCEB007).withOpacity(0.5)
                                            : Colors.grey[300]!,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    final value = _controllers[item.itemId]!
                                        .text
                                        .trim();
                                    _updateQuantity(
                                      cartProvider,
                                      item.itemId,
                                      value,
                                      context,
                                    );
                                  },
                                  child: Icon(
                                    Icons.check,
                                    color: item.quantity > 0
                                        ? Color(0xFFCEB007)
                                        : Colors.grey,
                                    size: 20,
                                  ),
                                ),
                              ),

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
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
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
                                                  backgroundColor: Colors.black,
                                                  duration: const Duration(
                                                    milliseconds: 1000,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Remove',
                                              style: TextStyle(
                                                color: Colors.black,
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
                    // Only show total amount if there are items with prices
                    if (cartProvider.totalAmount > 0.0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isUAEUser ? 'Total Amount + Tax:' : 'Total Amount:',
                            style: TextStyle(fontSize: 15),
                          ),
                          Text(
                            isUAEUser
                                ? '₹${(cartProvider.totalAmount + (cartProvider.totalAmount * taxRate)).toStringAsFixed(2)}'
                                : '₹${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: isUAEUser
                                  ? Colors.green[700]
                                  : Colors.black,
                              fontWeight: isUAEUser
                                  ? FontWeight.w700
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Amount:', style: TextStyle(fontSize: 15)),
                          Text(
                            'Prices not available',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
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
                              backgroundColor: Color(0xFFCEB007),
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
                            onPressed: _isProcessingCheckout
                                ? null
                                : () => _proceedToCheckout(cartProvider),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isProcessingCheckout
                                  ? Colors.grey
                                  : Color(0xFFCEB007),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: _isProcessingCheckout
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Processing...',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Text(
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
                      color: Color.fromARGB(255, 95, 91, 91),
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
