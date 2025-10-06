import 'package:equatable/equatable.dart';

abstract class GalleryEvent extends Equatable {
  const GalleryEvent();

  @override
  List<Object?> get props => [];
}

class LoadGalleryTypes extends GalleryEvent {
  const LoadGalleryTypes();
}

class RefreshGalleryTypes extends GalleryEvent {
  const RefreshGalleryTypes();
}
