import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bloc/gallery_bloc.dart';
import '../bloc/gallery_event.dart';
import '../bloc/gallery_state.dart';
import '../../../../../../core/di/injection.dart';

class GalleryScreen extends StatelessWidget {
  final int galleryTypeId;
  final String galleryTypeName;

  const GalleryScreen({
    Key? key,
    required this.galleryTypeId,
    required this.galleryTypeName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<GalleryDocumentBloc>()
            ..add(LoadGalleryDocuments(galleryTypeId: galleryTypeId)),
      child: GalleryView(
        galleryTypeName: galleryTypeName,
        galleryTypeId: galleryTypeId,
      ),
    );
  }
}

class GalleryView extends StatelessWidget {
  final String galleryTypeName;
  final int galleryTypeId;

  const GalleryView({
    Key? key,
    required this.galleryTypeName,
    required this.galleryTypeId,
  }) : super(key: key);

  bool _isVideoFile(String fileName) {
    final videoExtensions = [
      '.mp4',
      '.avi',
      '.mov',
      '.mkv',
      '.flv',
      '.wmv',
      '.webm',
    ];
    final lowerFileName = fileName.toLowerCase();
    return videoExtensions.any((ext) => lowerFileName.endsWith(ext));
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
            const SizedBox(width: 30),
            Expanded(
              child: Text(
                galleryTypeName,
                style: const TextStyle(
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
      body: BlocBuilder<GalleryDocumentBloc, GalleryDocumentState>(
        builder: (context, state) {
          if (state is GalleryDocumentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GalleryDocumentLoaded) {
            if (state.documents.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No gallery documents available',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GalleryDocumentBloc>().add(
                  RefreshGalleryDocuments(galleryTypeId: galleryTypeId),
                );
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: state.documents.length,
                itemBuilder: (context, index) {
                  final document = state.documents[index];
                  final isVideo = _isVideoFile(document.fileName);

                  return GestureDetector(
                    onTap: () =>
                        _openImageInBrowser(document.fullImageUrl, context),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: isVideo
                                  ? Container(
                                      color: Colors.grey[200],
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          const Icon(
                                            Icons.videocam,
                                            size: 60,
                                            color: Color(0xFFCEB007),
                                          ),
                                          Positioned(
                                            bottom: 8,
                                            right: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: const Text(
                                                'VIDEO',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : CachedNetworkImage(
                                      imageUrl: document.fullImageUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            color: Colors.grey[200],
                                            child: const Icon(
                                              Icons.picture_as_pdf,
                                              size: 50,
                                              color: Colors.red,
                                            ),
                                          ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              document.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is GalleryDocumentError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GalleryDocumentBloc>().add(
                        LoadGalleryDocuments(galleryTypeId: galleryTypeId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _openImageInBrowser(String fileUrl, BuildContext context) async {
    final Uri url = Uri.parse(fileUrl);
    final isVideo = _isVideoFile(fileUrl);

    try {
      // Use externalApplication mode to force opening in an external app
      final launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isVideo
                  ? 'Could not open video. No compatible app found.'
                  : 'Could not open image. No compatible app found.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error launching URL: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
