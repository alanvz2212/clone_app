import 'package:equatable/equatable.dart';
import '../model/gallery_type_model.dart';

abstract class GalleryState extends Equatable {
  const GalleryState();

  @override
  List<Object?> get props => [];
}

class GalleryInitial extends GalleryState {
  const GalleryInitial();
}

class GalleryLoading extends GalleryState {
  const GalleryLoading();
}

class GalleryLoaded extends GalleryState {
  final List<GalleryType> galleryTypes;

  const GalleryLoaded({required this.galleryTypes});

  @override
  List<Object?> get props => [galleryTypes];
}

class GalleryError extends GalleryState {
  final String message;

  const GalleryError({required this.message});

  @override
  List<Object?> get props => [message];
}
