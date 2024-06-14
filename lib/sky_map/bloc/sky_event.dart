import 'dart:ui';

abstract class SkyEvent {}

class UpdateOffset extends SkyEvent {
  final Offset offset;

  UpdateOffset(this.offset);
}
