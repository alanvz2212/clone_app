import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clone/constants/string_constants.dart';
import '../bloc/gallery_type_bloc.dart';
import '../bloc/gallery_type_event.dart';
import '../bloc/gallery_type_state.dart';
import '../../../../../../core/di/injection.dart';
import '../../Gallery/screen/gallery_screen.dart';

class GalleryTypeScreen extends StatelessWidget {
  const GalleryTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<GalleryBloc>()..add(const LoadGalleryTypes()),
      child: const GalleryView(),
    );
  }
}

class GalleryView extends StatelessWidget {
  const GalleryView({Key? key}) : super(key: key);

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
            const SizedBox(width: 30),
            const Text(
              'Gallery',
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

      body: BlocBuilder<GalleryBloc, GalleryState>(
        builder: (context, state) {
          if (state is GalleryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GalleryLoaded) {
            if (state.galleryTypes.isEmpty) {
              return const Center(
                child: Text(
                  'No gallery types available',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<GalleryBloc>().add(const RefreshGalleryTypes());
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.galleryTypes.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.galleryTypes.length) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        top: 410,
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
                    );
                  }
                  final galleryType = state.galleryTypes[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 60,
                        height: 60,
                        child: galleryType.icon.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://tmsapi.abm4trades.com/${galleryType.icon}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image,
                                      size: 30,
                                      color: Color(0xFFCEB007),
                                    );
                                  },
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      },
                                ),
                              )
                            : const Icon(
                                Icons.image,
                                size: 30,
                                color: Color(0xFFCEB007),
                              ),
                      ),
                      title: Text(
                        galleryType.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          if (galleryType.company != null) ...[
                            const SizedBox(height: 4),
                          ],
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryScreen(
                              galleryTypeId: galleryType.id,
                              galleryTypeName: galleryType.name,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          } else if (state is GalleryError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<GalleryBloc>().add(const LoadGalleryTypes());
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 8),
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
    );
  }
}
