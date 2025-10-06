import 'package:flutter_bloc/flutter_bloc.dart';
import 'gallery_type_event.dart';
import 'gallery_type_state.dart';
import '../service/gallery_type_service.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  final GalleryService galleryService;

  GalleryBloc({required this.galleryService}) : super(const GalleryInitial()) {
    on<LoadGalleryTypes>(_onLoadGalleryTypes);
    on<RefreshGalleryTypes>(_onRefreshGalleryTypes);
  }

  Future<void> _onLoadGalleryTypes(
    LoadGalleryTypes event,
    Emitter<GalleryState> emit,
  ) async {
    emit(const GalleryLoading());
    try {
      final response = await galleryService.getAllGalleryTypes();
      if (response.success) {
        emit(GalleryLoaded(galleryTypes: response.data));
      } else {
        emit(GalleryError(message: response.message.isEmpty 
            ? 'Failed to load gallery types' 
            : response.message));
      }
    } catch (e) {
      emit(GalleryError(message: e.toString()));
    }
  }

  Future<void> _onRefreshGalleryTypes(
    RefreshGalleryTypes event,
    Emitter<GalleryState> emit,
  ) async {
    try {
      final response = await galleryService.getAllGalleryTypes();
      if (response.success) {
        emit(GalleryLoaded(galleryTypes: response.data));
      } else {
        emit(GalleryError(message: response.message.isEmpty 
            ? 'Failed to refresh gallery types' 
            : response.message));
      }
    } catch (e) {
      emit(GalleryError(message: e.toString()));
    }
  }
}
