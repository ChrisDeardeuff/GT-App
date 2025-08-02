class GalacticTimeService {
  static getGT() {
    var diff = (DateTime.now().toUtc().millisecondsSinceEpoch + 3471267600000) / 1000;
    return (diff / 1.0878277570776).toString();
  }
  static String convertToGalacticTime(DateTime earthTime) {
    var diff =
        (earthTime.toUtc().millisecondsSinceEpoch + 3471267600000) / 1000;

    return (diff / 1.0878277570776).toString();
  }

  /// Converts galactic time to a regular DateTime
  static DateTime convertFromGalacticTime(String galacticTime) {
    // Parse the galactic time string to double
    double gTime = double.parse(galacticTime);

    // Reverse the conversion process
    double seconds = gTime * 1.0878277570776;
    double milliseconds = seconds * 1000;
    int earthMilliseconds = (milliseconds - 3471267600000).round();

    // Create DateTime from milliseconds since epoch
    return DateTime.fromMillisecondsSinceEpoch(earthMilliseconds, isUtc: true);
  }

  static String formatGalacticTime(String galacticTimeStr) {
    double totalTime = double.parse(galacticTimeStr);

    // Base system:
    // 1 minute = 100 seconds
    // 1 hour = 100 minutes = 10,000 seconds
    // 1 day = 10 hours = 100,000 seconds
    // 1 week = 10 days = 1,000,000 seconds
    // 1 month = 10 weeks = 10,000,000 seconds
    // 1 year = 10 months = 100,000,000 seconds

    int years = (totalTime / 100000000).floor();
    double remaining = totalTime % 100000000;

    int months = (remaining / 10000000).floor();
    remaining = remaining % 10000000;

    int weeks = (remaining / 1000000).floor();
    remaining = remaining % 1000000;

    int days = (remaining / 100000).floor();
    remaining = remaining % 100000;

    int hours = (remaining / 10000).floor();
    remaining = remaining % 10000;

    int minutes = (remaining / 100).floor();
    int seconds = (remaining % 100).floor();

    return '$years.$months.$weeks$days $hours.$minutes.$seconds';
  }

  // Optional: Add method to explain each component
  static Map<String, int> parseGalacticTime(String galacticTimeStr) {
    double totalTime = double.parse(galacticTimeStr);

    int years = (totalTime / 100000000).floor();
    double remaining = totalTime % 100000000;

    int months = (remaining / 10000000).floor();
    remaining = remaining % 10000000;

    int weeks = (remaining / 1000000).floor();
    remaining = remaining % 1000000;

    int days = (remaining / 100000).floor();
    remaining = remaining % 100000;

    int hours = (remaining / 10000).floor();
    remaining = remaining % 10000;

    int minutes = (remaining / 100).floor();
    int seconds = (remaining % 100).floor();

    return {
      'years': years,
      'months': months, // 0-9 (10 months per year)
      'weeks': weeks, // 0-9 (10 weeks per month)
      'days': days, // 0-9 (10 days per week)
      'hours': hours, // 0-9 (10 hours per day)
      'minutes': minutes, // 0-99 (100 minutes per hour)
      'seconds': seconds // 0-99 (100 seconds per minute)
    };
  }
}
