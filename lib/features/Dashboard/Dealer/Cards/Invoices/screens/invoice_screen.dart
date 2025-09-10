import 'package:flutter/material.dart';
import '../models/invoice_model.dart';
import '../services/invoice_service.dart';

class InvoiceScreen extends StatefulWidget {
  final int customerId;

  const InvoiceScreen({Key? key, required this.customerId}) : super(key: key);

  @override
  State<InvoiceScreen> createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  List<InvoiceModel> invoices = [];
  bool isLoading = true;
  String errorMessage = '';
  late final InvoiceService _invoiceService;

  @override
  void initState() {
    super.initState();
    _invoiceService = InvoiceService();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      final fetchedInvoices = await _invoiceService.getCustomerInvoices(
        widget.customerId,
      );

      setState(() {
        invoices = fetchedInvoices;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _invoiceService.dispose();
    super.dispose();
  }

  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        width: 70,
                        height: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 33),
                      const Text(
                        'Invoices',
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red[600], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });
                      fetchInvoices();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : invoices.isEmpty
          ? const Center(
              child: Text(
                'No invoices found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: fetchInvoices,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: invoices.length,
                itemBuilder: (context, index) {
                  final invoice = invoices[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Invoice : ${invoice.invoice}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // Container(
                              //   padding: const EdgeInsets.symmetric(
                              //     horizontal: 8,
                              //     vertical: 4,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     color: Colors.green[100],
                              //     borderRadius: BorderRadius.circular(12),
                              //   ),
                              //   child: Text(
                              //     '₹${invoice.total.toStringAsFixed(2)}',
                              //     style: TextStyle(
                              //       fontSize: 16,
                              //       fontWeight: FontWeight.bold,
                              //       color: Colors.green[700],
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            'S.No',
                            (index + 1).toString(),
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Date',
                            formatDate(invoice.invoiceDate),
                          ),
                          // const SizedBox(height: 8),
                          // _buildInfoRow(
                          //   'Customer Name',
                          //   invoice.customer.name,
                          // ),
                          // const SizedBox(height: 8),
                          // _buildInfoRow(
                          //   'Salesman Name',
                          //   invoice.salesman.name,
                          // ),
                          const SizedBox(height: 8),
                          _buildInfoRow(
                            'Total Amount',
                            '₹${invoice.total.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
