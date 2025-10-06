import 'package:flutter_bloc/flutter_bloc.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';
import '../services/gallery_service.dart';

class GalleryDocumentBloc extends Bloc<GalleryDocumentEvent, GalleryDocumentState> {
  final GalleryDocumentService galleryDocumentService;

  GalleryDocumentBloc({required this.galleryDocumentService}) 
      : super(const GalleryDocumentInitial()) {
    on<LoadGalleryDocuments>(_onLoadGalleryDocuments);
    on<RefreshGalleryDocuments>(_onRefreshGalleryDocuments);
  }

  Future<void> _onLoadGalleryDocuments(
    LoadGalleryDocuments event,
    Emitter<GalleryDocumentState> emit,
  ) async {
    emit(const GalleryDocumentLoading());
    try {
      final response = await galleryDocumentService.getGalleryDocuments(event.galleryTypeId);
      if (response.success) {
        emit(GalleryDocumentLoaded(documents: response.data));
      } else {
        emit(const GalleryDocumentError(message: 'Failed to load gallery documents'));
      }
    } catch (e) {
      emit(GalleryDocumentError(message: e.toString()));
    }
  }

  Future<void> _onRefreshGalleryDocuments(
    RefreshGalleryDocuments event,
    Emitter<GalleryDocumentState> emit,
  ) async {
    try {
      final response = await galleryDocumentService.getGalleryDocuments(event.galleryTypeId);
      if (response.success) {
        emit(GalleryDocumentLoaded(documents: response.data));
      } else {
        emit(const GalleryDocumentError(message: 'Failed to refresh gallery documents'));
      }
    } catch (e) {
      emit(GalleryDocumentError(message: e.toString()));
    }
  }
}
