import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/dues_bloc.dart';
import '../bloc/dues_event.dart';
import '../bloc/dues_state.dart';
import '../models/dues_model.dart';
import '../services/dues_service.dart';
import '../../../../../auth/dealer/bloc/dealer_auth_bloc.dart';
import '../../../../../auth/dealer/bloc/dealer_auth_state.dart';

class DuesScreen extends StatelessWidget {
  const DuesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DuesBloc(DuesService()),
      child: const _DuesScreenContent(),
    );
  }
}

class _DuesScreenContent extends StatefulWidget {
  const _DuesScreenContent();

  @override
  State<_DuesScreenContent> createState() => _DuesScreenContentState();
}

class _DuesScreenContentState extends State<_DuesScreenContent> {
  late TextEditingController _dateFromController;
  late TextEditingController _dateToController;

  @override
  void initState() {
    super.initState();
    _dateFromController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );
    _dateToController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    // Load initial data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDues();
    });
  }

  @override
  void dispose() {
    _dateFromController.dispose();
    _dateToController.dispose();
    super.dispose();
  }

  int _getLoggedInCustomerId() {
    // Get the logged-in user's customerId from DealerAuthState
    final authState = context.read<DealerAuthBloc>().state;
    if (authState.isAuthenticated && authState.dealer != null) {
      return authState.dealer!.customerId;
    }
    return 40807; // Fallback default
  }

  void _loadDues() {
    final customerId = _getLoggedInCustomerId();
    final request = DuesRequest(
      dateFrom: _dateFromController.text,
      dateTo: _dateToController.text,
      customerId: customerId,
    );

    context.read<DuesBloc>().add(LoadDues(request));
  }

  void _refreshDues() {
    final customerId = _getLoggedInCustomerId();
    final request = DuesRequest(
      dateFrom: _dateFromController.text,
      dateTo: _dateToController.text,
      customerId: customerId,
    );

    context.read<DuesBloc>().add(RefreshDues(request));
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
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
          SizedBox(height: 20),
          // Filter Section
          // Container(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     children: [
          //       // Show logged-in user info
          //       BlocBuilder<DealerAuthBloc, DealerAuthState>(
          //         builder: (context, authState) {
          //           if (authState.isAuthenticated && authState.dealer != null) {
          //             return Container(
          //               padding: const EdgeInsets.all(12.0),
          //               decoration: BoxDecoration(
          //                 borderRadius: BorderRadius.circular(8.0),
          //                 border: Border.all(color: Colors.grey[400]!),
          //               ),
          //               child: Row(
          //                 children: [
          //                   const Icon(Icons.person),
          //                   const SizedBox(width: 8),
          //                   Expanded(
          //                     child: Column(
          //                       crossAxisAlignment: CrossAxisAlignment.start,
          //                       children: [
          //                         Text(
          //                           authState.dealer!.name,
          //                           style: const TextStyle(
          //                             fontWeight: FontWeight.bold,
          //                             fontSize: 16,
          //                           ),
          //                         ),
          //                         Text(
          //                           'Customer ID: ${authState.dealer!.customerId}',
          //                           style: const TextStyle(
          //                             fontSize: 12,
          //                           ),
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             );
          //           }
          //           return const SizedBox.shrink();
          //         },
          //       ),
          //       const SizedBox(height: 16),
          //       Row(
          //         children: [
          //           Expanded(
          //             child: TextField(
          //               controller: _dateFromController,
          //               decoration: const InputDecoration(
          //                 labelText: 'Date From',
          //                 border: OutlineInputBorder(),
          //                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //                 suffixIcon: Icon(Icons.calendar_today),
          //               ),
          //               readOnly: true,
          //               onTap: () => _selectDate(_dateFromController),
          //             ),
          //           ),
          //           const SizedBox(width: 12),
          //           Expanded(
          //             child: TextField(
          //               controller: _dateToController,
          //               decoration: const InputDecoration(
          //                 labelText: 'Date To',
          //                 border: OutlineInputBorder(),
          //                 contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //                 suffixIcon: Icon(Icons.calendar_today),
          //               ),
          //               readOnly: true,
          //               onTap: () => _selectDate(_dateToController),
          //             ),
          //           ),
          //         ],
          //       ),
          //       const SizedBox(height: 12),
          //       SizedBox(
          //         width: double.infinity,
          //         child: ElevatedButton(
          //           onPressed: _loadDues,
          //           child: const Text('Search'),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // Data Section
          Expanded(
            child: BlocBuilder<DuesBloc, DuesState>(
              builder: (context, state) {
                if (state is DuesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DuesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${state.message}',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadDues,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is DuesLoaded) {
                  if (state.dues.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox, size: 64),
                          SizedBox(height: 16),
                          Text('No dues found', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _refreshDues(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12.0),
                      itemCount: state.dues.length,
                      itemBuilder: (context, index) {
                        final due = state.dues[index];
                        return _buildDueCard(due);
                      },
                    ),
                  );
                }

                return const Center(
                  child: Text('Pull to refresh or search to load data'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDueCard(DuesModel due) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
        side: BorderSide(width: 1, color: Colors.grey[400]!),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    due.billNo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Text(
                    due.type,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Date Information
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Bill Date',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(due.billDate),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Due Date',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(due.dueDate),
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Amount Information
            Row(
              children: [
                if (due.debit > 0) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Debit',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '₹${due.debit.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (due.credit > 0) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Credit',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '₹${due.credit.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Outstanding',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${due.outStandingAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
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
}
