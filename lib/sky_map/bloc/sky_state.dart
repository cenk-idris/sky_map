import 'dart:ui';

abstract class SkyState {}

class SkyInitial extends SkyState {}

class SkyOffsetUpdated extends SkyState {
  final Offset offset;
  SkyOffsetUpdated(this.offset);
}
