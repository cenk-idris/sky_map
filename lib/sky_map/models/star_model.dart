class Star {
  final String name;
  final String constellation;
  final double rightAscensionHours;
  // final double declinationDegrees;
  // final double apparentMagnitude;
  // final double distanceLightYear;

  Star({
    required this.name,
    required this.constellation,
    required this.rightAscensionHours,
    // required this.declinationDegrees,
    // required this.apparentMagnitude,
    // required this.distanceLightYear,
  });

  factory Star.fromJson(Map<String, dynamic> json) {
    try {
      double rightAscensionHours =
          _parseRightAscensionHours(json['right_ascension']);
      return Star(
        name: json['name'],
        constellation: json['constellation'],
        rightAscensionHours: rightAscensionHours,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static double _parseRightAscensionHours(String ra) {
    final parts = ra.split('h');
    final hours = double.parse(parts[0].trim());
    final minAndSec = parts[1].split('m');
    final minutes = double.parse(minAndSec[0].trim());
    final seconds = double.parse(minAndSec[1].replaceAll('s', '').trim());
    return hours + (minutes / 60) + (seconds / 3600);
  }
}
