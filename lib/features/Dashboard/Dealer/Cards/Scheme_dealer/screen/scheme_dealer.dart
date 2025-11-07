import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/scheme_dealer_bloc.dart';
import '../bloc/scheme_event_bloc.dart';
import '../bloc/scheme_state_bloc.dart';
import '../models/scheme_dealer_model.dart';
import '../../../../../auth/dealer/bloc/dealer_auth_bloc.dart';

class SchemeDealer extends StatelessWidget {
  const SchemeDealer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<DealerAuthBloc>().state;
        final dealerId = authState.dealer?.id ?? 0;

        print('=== SchemeDealer Init ===');
        print('Dealer ID: $dealerId');
        print('Auth State: $authState');

        return SchemeDealerBloc()..add(LoadSchemes(userId: dealerId));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFCEB007),
          elevation: 2,
          shadowColor: const Color(0xFFCEB007).withOpacity(0.3),
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
              const SizedBox(width: 30),
              const Expanded(
                child: Text(
                  'Scheme',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          titleSpacing: 0,
        ),
        body: BlocBuilder<SchemeDealerBloc, SchemeDealerState>(
          builder: (context, state) {
            if (state is SchemeLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFCEB007)),
              );
            } else if (state is SchemeLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  final authState = context.read<DealerAuthBloc>().state;
                  final dealerId = authState.dealer?.id ?? 0;
                  context.read<SchemeDealerBloc>().add(
                    RefreshSchemes(userId: dealerId),
                  );
                },
                child: _buildSchemeList(state.schemes),
              );
            } else if (state is SchemeRefreshing) {
              return Stack(
                children: [
                  _buildSchemeList(state.currentSchemes),
                  const Center(
                    child: CircularProgressIndicator(color: Color(0xFFCEB007)),
                  ),
                ],
              );
            } else if (state is SchemeEmpty) {
              return _buildEmptyState(context, state.userId);
            } else if (state is SchemeError) {
              return _buildErrorState(context, state.message, state.userId);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildSchemeList(List<SchemeDealerModel> schemes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schemes.length,
      itemBuilder: (context, index) {
        final scheme = schemes[index];
        return _buildSchemeCard(scheme);
      },
    );
  }

  Widget _buildSchemeCard(SchemeDealerModel scheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scheme.name,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Scheme ID: ${scheme.schemeId}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Text(
                      '${scheme.point} Points',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'From: ${scheme.startDate.split('T')[0]}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'To: ${scheme.endDate.split('T')[0]}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Text(
              //   'User Type: ${scheme.userType}',
              //   style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildEmptyState(BuildContext context, int userId) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            'No Schemes Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'There are no active schemes for your account',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<SchemeDealerBloc>().add(
                RefreshSchemes(userId: userId),
              );
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCEB007),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, int userId) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            Text(
              'Error Loading Schemes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SchemeDealerBloc>().add(
                  RetryLoadSchemes(userId: userId),
                );
              },
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCEB007),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
