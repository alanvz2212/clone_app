import 'package:equatable/equatable.dart';
import '../model/gallery_document_model.dart';

abstract class GalleryDocumentState extends Equatable {
  const GalleryDocumentState();

  @override
  List<Object?> get props => [];
}

class GalleryDocumentInitial extends GalleryDocumentState {
  const GalleryDocumentInitial();
}

class GalleryDocumentLoading extends GalleryDocumentState {
  const GalleryDocumentLoading();
}

class GalleryDocumentLoaded extends GalleryDocumentState {
  final List<GalleryDocument> documents;

  const GalleryDocumentLoaded({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class GalleryDocumentError extends GalleryDocumentState {
  final String message;

  const GalleryDocumentError({required this.message});

  @override
  List<Object?> get props => [message];
}
