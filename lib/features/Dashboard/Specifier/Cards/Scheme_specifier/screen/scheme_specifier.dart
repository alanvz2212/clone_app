import 'package:clone/constants/string_constants.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Scheme_specifier/bloc/scheme_event.bloc.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Scheme_specifier/bloc/scheme_specifier_bloc.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Scheme_specifier/bloc/scheme_state_bloc.dart';
import 'package:clone/features/Dashboard/Specifier/Cards/Scheme_specifier/model/scheme_specifier_model.dart';
import 'package:clone/features/auth/dealer/bloc/dealer_auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class SchemeSpecifier extends StatelessWidget {
  const SchemeSpecifier({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final authState = context.read<DealerAuthBloc>().state;
        final specifierId = authState.dealer?.id ?? 0;

        print('=== SchemeSpecifier Init ===');
        print('Dealer ID: $specifierId');
        print('Auth State: $authState');
        return SchemeSpecifierBloc()..add(LoadSchemes(userId: specifierId));
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
        body: BlocBuilder<SchemeSpecifierBloc, SchemeSpecifierState>(
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
                  context.read<SchemeSpecifierBloc>().add(
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
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
              Image.asset('assets/33.png', width: 100, height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchemeList(List<SchemeSpecifierModel> schemes) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: schemes.length,
      itemBuilder: (context, index) {
        final scheme = schemes[index];
        return _buildSchemeCard(context, scheme);
      },
    );
  }

  Widget _buildSchemeCard(BuildContext context, SchemeSpecifierModel scheme) {
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
              const SizedBox(height: 10),
              if (scheme.fileName != null && scheme.fileName.isNotEmpty)
                GestureDetector(
                  onTap: () =>
                      _showFullScreenImage(context, scheme.fullImageUrl),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      scheme.fullImageUrl,
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFFCEB007),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 160,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

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
                      'From: ${scheme.startDate.split('T')[0]}   To: ${scheme.endDate.split('T')[0]}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black87,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.zero,
          child: Stack(
            children: [
              // Fullscreen image with zoom capability
              GestureDetector(
                onTap: () => Navigator.pop(dialogContext),
                child: Container(
                  color: Colors.black,
                  child: Center(
                    child: InteractiveViewer(
                      panEnabled: true,
                      minScale: 0.5,
                      maxScale: 4.0,
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                  color: const Color(0xFFCEB007),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Loading image...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Colors.red,
                                  size: 50,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Failed to load image',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _openImageInBrowser(context, imageUrl),
                                  icon: const Icon(Icons.open_in_browser),
                                  label: const Text('Open in Browser'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCEB007),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Close button
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(dialogContext),
                  ),
                ),
              ),
              // Open in browser button
              Positioned(
                top: 40,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.open_in_browser,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _openImageInBrowser(context, imageUrl);
                    },
                  ),
                ),
              ),
              // Pinch to zoom hint
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pinch to zoom • Tap to close',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openImageInBrowser(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Try to launch the URL
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        // If launch failed, show error message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Unable to open image in browser'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Copy URL',
                textColor: Colors.white,
                onPressed: () {
                  // You can implement clipboard copy here if needed
                  // Clipboard.setData(ClipboardData(text: url));
                },
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening image: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
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
          Icon(Icons.description_outlined, size: 80, color: Colors.grey[400]),
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
              context.read<SchemeSpecifierBloc>().add(
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
            Icon(Icons.error_outline, size: 80, color: Colors.red[300]),
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
                context.read<SchemeSpecifierBloc>().add(
                  RetryLoadSchemes(userId: userId),
                );
              },
              icon: const Icon(Icons.refresh),
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
