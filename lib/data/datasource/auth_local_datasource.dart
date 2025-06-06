import 'package:flutter_pos/data/model/response/auth_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
//   save auth data
  Future<void> saveAuthData(AuthResponseModel authResponseModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_data', authResponseModel.toJson());
  }

// remove auth data
  Future<void> removeAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_data');
  }
// get auth data
  Future<AuthResponseModel> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authDataUser = prefs.getString('auth_data');
    return AuthResponseModel.fromJson(authDataUser!);
  }
// is auth data
  Future<bool> isAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final authDataUser = prefs.getString('auth_data');
    return authDataUser != null;
  }
}