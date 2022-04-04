import 'package:cloud_firestore/cloud_firestore.dart';
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

  static Future setEnterCheck(
      {bool enteredLast = false, Timestamp? time}) async {
    return await sharedPreferences!.setStringList(_enterCheck, [
      enteredLast.toString(),
      time!.toDate().toString().substring(0, 10).trim()
    ]);
  }

  static bool? getEnterCheck({Timestamp? time}) {
    try {
      final list = sharedPreferences!.getStringList(_enterCheck);
      if (list![0].contains("true") &&
          time!.toDate().toString().substring(0, 10).trim() == list[1]) {
        return true;
      } else if (list[0].contains("false") &&
          time!.toDate().toString().substring(0, 10).trim() == list[1]) {
        return false;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
