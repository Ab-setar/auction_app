import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static const _keyUsername = 'username';
  static const _keyLastBidAmount = 'last_bid_amount';
  static const _keyLastBidProduct = 'last_bid_product';

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserttname, username);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername);
  }

  Future<void> saveLastBid({
    required double amount,
    required String productTitle,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyLastBidAmount, amount);
    await prefs.setString(_keyLastBidProduct, productTitle);
  }

  Future<Map<String, dynamic>?> getLastBid() async {
    final prefs = await SharedPreferences.getInstance();
    final amount = prefs.getDouble(_keyLastBidAmount);
    final product = prefs.getString(_keyLastBidProduct);
    if (amount == null || product == null) return null;
    return {'amount': amount, 'product': product};
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
