import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/pending_invoice_bloc.dart';
import '../bloc/pending_invoice_event.dart';
import '../bloc/pending_invoice_state.dart';
import '../models/pending_invoice_model.dart';
import '../services/pending_invoice_service.dart';
import 'package:abm4customerapp/constants/string_constants.dart';

class PendingInvoicesScreen extends StatelessWidget {
  const PendingInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PendingInvoiceBloc(PendingInvoiceService()),
      child: const _PendingInvoicesScreenContent(),
    );
  }
}

class _PendingInvoicesScreenContent extends StatefulWidget {
  const _PendingInvoicesScreenContent();

  @override
  State<_PendingInvoicesScreenContent> createState() =>
      _PendingInvoicesScreenContentState();
}

class _PendingInvoicesScreenContentState
    extends State<_PendingInvoicesScreenContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PendingInvoiceBloc>().add(LoadPendingInvoices());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFCEB007),
        elevation: 2,
        shadowColor: const Color(0xFFCEB007).withOpacity(0.3),
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
            const SizedBox(width: 15),
            const Text(
              'Pending Invoices',
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
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<PendingInvoiceBloc, PendingInvoiceState>(
              builder: (context, state) {
                if (state is PendingInvoiceLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCEB007)),
                  );
                } else if (state is PendingInvoiceError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading pending invoices',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<PendingInvoiceBloc>().add(
                              LoadPendingInvoices(),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCEB007),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is PendingInvoiceLoaded) {
                  if (state.invoices.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No pending invoices found',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You have no outstanding dues',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<PendingInvoiceBloc>().add(
                        RefreshPendingInvoices(),
                      );
                    },
                    color: const Color(0xFFCEB007),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.invoices.length,
                      itemBuilder: (context, index) {
                        final invoice = state.invoices[index];
                        return _buildInvoiceCard(invoice);
                      },
                    ),
                  );
                }
                return const Center(
                  child: Text('Pull to refresh to load data'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'App Version - ${StringConstant.version}',
                  style: const TextStyle(
                    color: Color.fromARGB(255, 95, 91, 91),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Image.asset('assets/33.png', width: 100, height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _calculateTotalOutstanding(List<PendingInvoiceModel> invoices) {
    return invoices.fold(
      0.0,
      (sum, invoice) => sum + invoice.outStandingAmount,
    );
  }

  Widget _buildInvoiceCard(PendingInvoiceModel invoice) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    invoice.billNo,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: invoice.type == 'Dr'
                        ? Colors.grey[600]
                        : Colors.grey[500],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    invoice.type == 'Dr' ? 'Dr' : 'Cr',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Row(children: [
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  'Bill Date: ${_formatDate(invoice.billDate)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const SizedBox(width: 8),
                Text(
                  'Due Date: ${_formatDate(invoice.dueDate)}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (invoice.debit > 0)
                        Text(
                          'Debit: ₹${invoice.debit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      if (invoice.credit > 0)
                        Text(
                          'Credit: ₹${invoice.credit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'Outstanding: ₹${invoice.outStandingAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
