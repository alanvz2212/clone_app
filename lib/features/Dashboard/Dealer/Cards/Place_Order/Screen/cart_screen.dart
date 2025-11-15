import 'package:abm4customerapp/constants/string_constants.dart';
import 'package:abm4customerapp/constants/api_endpoints.dart';
import 'package:abm4customerapp/features/Dashboard/Dealer/Cards/Place_Order/providers/cart_provider.dart';
import 'package:abm4customerapp/core/di/injection.dart';
import 'package:abm4customerapp/services/user_service.dart';
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
  bool get isUAEUser => true;
  static const double taxRate = 0.18;
  @override
  void initState() {
    super.initState();
    _userService = getIt<UserService>();
  }

  Future<void> _proceedToCheckout(
    CartProvider cartProvider,
    String notes,
  ) async {
    if (_isProcessingCheckout) return;
    setState(() {
      _isProcessingCheckout = true;
    });
    try {
      final customerId = await _userService.getCurrentCustomerIdWithFallback();
      final mobileUser = await _userService.getMobileUser();
      final phoneNumber = await _userService.getPhoneNumber();
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
      Map<String, dynamic> requestBody = {
        "id": 0,
        "referenceId": 0,
        "referenceType": "string",
        "companyId": 0,
        "billTypeId": 0,
        "increment": 0,
        "invoice": "string",
        "customerId": customerId,
        "mobileOrderStatusId": 1,
        "notes": notes.isEmpty ? "No notes" : notes,
        "mobileOrderItem": mobileOrderItems,
        "mobileUserId": mobileUser.isNotEmpty ? mobileUser[0] : null,
        "phoneNumber": phoneNumber ?? "string",
      };
      final response = await http.post(
        Uri.parse(ApiEndpoints.newMobileOrder),
        headers: {
          'accept': '*/*',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
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
            Navigator.of(context).pop();
          }
        } else {
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

  void _showNotesDialog(CartProvider cartProvider) {
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Notes'),
          content: TextField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Enter any notes for your order...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFFCEB007),
                  width: 2,
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _proceedToCheckout(cartProvider, '');
              },
              child: const Text('Skip', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _proceedToCheckout(cartProvider, notesController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFCEB007),
                foregroundColor: Colors.white,
              ),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    ).then((_) {
      notesController.dispose();
    });
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
              width: 80,
              height: 80,
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (item.price > 0.0)
                                      Text(
                                        '  ₹ ${item.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                if (item.price > 0.0) ...[
                                  isUAEUser
                                      ? Text(
                                          'Total + Tax: ₹ ${(item.total + (item.total * taxRate)).toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                          ),
                                        )
                                      : Text(
                                          'Total: ₹ ${item.total.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                          ),
                                        ),
                                ] else ...[
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
                          Row(
                            children: [
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
                                ? '₹ ${(cartProvider.totalAmount + (cartProvider.totalAmount * taxRate)).toStringAsFixed(2)}'
                                : '₹ ${cartProvider.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 15,
                              color: isUAEUser ? Colors.black : Colors.black,
                              fontWeight: isUAEUser
                                  ? FontWeight.w600
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
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.black),
                                        ),
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
                                          style: TextStyle(color: Colors.black),
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
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isProcessingCheckout
                                ? null
                                : () => _showNotesDialog(cartProvider),
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
