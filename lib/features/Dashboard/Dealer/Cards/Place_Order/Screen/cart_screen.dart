import 'package:clone/constants/string_constants.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
            const Text(
              'Cart Orders',
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

      // body: Padding(
      //   padding: const EdgeInsets.only(left: 16, bottom: 16, top: 8),
      //   child: Align(
      //     alignment: Alignment.centerLeft,
      //     child: Text(
      //       'App Version - ${StringConstant.version}',
      //       style: TextStyle(
      //         color: Colors.blue[700],
      //         fontWeight: FontWeight.w500,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
