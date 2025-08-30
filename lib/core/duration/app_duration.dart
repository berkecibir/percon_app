final class AppDuration {
  // Private constructor to prevent instantiation
  const AppDuration._();

  /// Commonly used durations
  static const Duration oneSecond = Duration(seconds: 1);
  static const Duration twoSecond = Duration(seconds: 2);
  static const Duration threeSecond = Duration(seconds: 3);
  static const Duration short = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration long = Duration(milliseconds: 1000);
}
