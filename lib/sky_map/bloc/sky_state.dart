import 'dart:ui';

abstract class SkyState {}

class SkyInitial extends SkyState {}

class SkyLoading extends SkyState {}

class SkyError extends SkyState {
  final String errorMessage;

  SkyError(this.errorMessage);
}

class SkyOffsetUpdated extends SkyState {
  final Offset offset;
  SkyOffsetUpdated(this.offset);
}
