import 'package:shared_preferences/shared_preferences.dart';

class SpService {
  void setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('Authorization', token);
  }

  Future<String?> getToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('Authorization');
  }
}
