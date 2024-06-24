class Star {
  final String name;
  final String constellation;
  final double rightAscensionHours;
  final double declinationDegrees;
  final double apparentMagnitude;
  final double distanceLightYear;

  Star({
    required this.name,
    required this.constellation,
    required this.rightAscensionHours,
    required this.declinationDegrees,
    required this.apparentMagnitude,
    required this.distanceLightYear,
  });

  // factory Star.fromJson(Map<String, dynamic> json) {
  //
  // }
}
