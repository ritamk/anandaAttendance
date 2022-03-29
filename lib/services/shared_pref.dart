import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPref {
  static SharedPreferences? sharedPreferences;
  static const _verifiedKey = "verified";
  static const _userKey = "uid";
  static const _enterCheck = "enterCheck";

  static Future init() async =>
      sharedPreferences = await SharedPreferences.getInstance();

  static Future setVerifiedOrNot(bool verified) async =>
      await sharedPreferences!.setBool(_verifiedKey, verified);

  static bool? getVerifiedOrNot() {
    try {
      return sharedPreferences!.getBool(_verifiedKey);
    } catch (e) {
      return false;
    }
  }

  static Future setUser(String uid) async {
    return await sharedPreferences!.setString(_userKey, uid);
  }

  static String? getUser() {
    try {
      String? user = sharedPreferences!.getString(_userKey);
      return user != null
          ? user == "noUser"
              ? null
              : user
          : null;
    } catch (e) {
      return null;
    }
  }

  static Future setEnterCheck({bool enteredLast = false}) async {
    return await sharedPreferences!.setBool(_enterCheck, enteredLast);
  }

  static bool? getEnterCheck() {
    try {
      return sharedPreferences!.getBool(_enterCheck);
    } catch (e) {
      return null;
    }
  }
}
