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
import 'package:clone/constants/string_constants.dart';
import 'package:clone/core/di/injection.dart';
import 'package:clone/services/user_service.dart';
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
  Future<int> _getLoggedInCustomerId() async {
    final userService = getIt<UserService>();
    return await userService.getCurrentCustomerIdWithFallback();
  }
  Future<void> _loadDues() async {
    final customerId = await _getLoggedInCustomerId();
    final request = DuesRequest(
      dateFrom: _dateFromController.text,
      dateTo: _dateToController.text,
      customerId: customerId,
    );
    context.read<DuesBloc>().add(LoadDues(request));
  }
  Future<void> _refreshDues() async {
    final customerId = await _getLoggedInCustomerId();
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
          SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<DuesBloc, DuesState>(
              builder: (context, state) {
                if (state is DuesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCEB007)),
                  );
                } else if (state is DuesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading dues',
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
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _loadDues,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFCEB007),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is DuesLoaded) {
                  if (state.dues.isEmpty) {
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
                            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async => _refreshDues(),
                    color: const Color(0xFFCEB007),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
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
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
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
                Image.asset(
                  'assets/33.png',
                  width: 100,
                  height: 100,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildDueCard(DuesModel due) {
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
                    due.billNo,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
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
                    color: Color(0xFFCEB007),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    due.type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bill Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(due.billDate),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy').format(due.dueDate),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                if (due.debit > 0) ...[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Debit',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${due.debit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
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
                        Text(
                          'Credit',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          '₹${due.credit.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[700],
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
                      Text(
                        'Outstanding',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        '₹${due.outStandingAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
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

