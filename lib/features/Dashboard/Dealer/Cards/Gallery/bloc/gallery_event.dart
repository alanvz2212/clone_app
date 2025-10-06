import 'package:equatable/equatable.dart';

abstract class GalleryDocumentEvent extends Equatable {
  const GalleryDocumentEvent();

  @override
  List<Object?> get props => [];
}

class LoadGalleryDocuments extends GalleryDocumentEvent {
  final int galleryTypeId;

  const LoadGalleryDocuments({required this.galleryTypeId});

  @override
  List<Object?> get props => [galleryTypeId];
}

class RefreshGalleryDocuments extends GalleryDocumentEvent {
  final int galleryTypeId;

  const RefreshGalleryDocuments({required this.galleryTypeId});

  @override
  List<Object?> get props => [galleryTypeId];
}
