import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/services/values.dart';

class StorageServices {
  static late SharedPreferences _preferences;

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();


  
  static int gettaskid(){
    int? id = _preferences.getInt(Last_taskID);
    if (id==null){
      _preferences.setInt(Last_taskID, 1);
      return 0;
    }
    else{
      _preferences.setInt(Last_taskID, id+1);
      return id;
    }
  }

  static Future setUsername(String username) async {
    await _preferences.setString(USERNAME, username);
  }

  static String getUsername(){
    String? username = _preferences.getString(USERNAME);
    return username ?? 'New User';
  }

  static bool getLightMode(){
    bool? currentMode = _preferences.getBool(THEMEMODE);
    return currentMode ?? true;
  }

  static Future changeLightMode() async {
    bool current = getLightMode();
    _preferences.setBool(THEMEMODE, !current);
  }

}
