/// Detects suspiciously rapid bidding activity.
///
/// Rules:
///   - Tracks the last [windowSize] bid timestamps.
///   - If [windowSize] bids all fall within [windowSeconds] seconds → flagged.
///   - After a warning the cooldown resets, giving the user a clean slate.
class FraudDetector {
  FraudDetector._();
  static final FraudDetector instance = FraudDetector._();

  /// Number of bids within the time window that triggers a warning.
  static const int windowSize = 3;

  /// Time window in seconds.
  static const int windowSeconds = 10;

  final List<DateTime> _timestamps = [];

  /// Records a bid attempt and returns `true` if fraud is suspected.
  bool recordBid() {
    final now = DateTime.now();
    _timestamps.add(now);

    // Keep only the most recent [windowSize] entries
    if (_timestamps.length > windowSize) {
      _timestamps.removeAt(0);
    }

    if (_timestamps.length < windowSize) return false;

    final oldest = _timestamps.first;
    final diff = now.difference(oldest).inSeconds;

    if (diff <= windowSeconds) {
      _timestamps.clear(); // reset after warning
      return true;
    }

    return false;
  }

  void reset() => _timestamps.clear();
}
