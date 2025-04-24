import 'package:assignment/features/meal/data/model/user_info_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class UserInfoLocalDataSource {
  Future<void> cacheUserInfo(UserInfoModel userInfoModel);
  Future<UserInfoModel?> getLastUserInfo();
}

class SharedPrefsUserInfoLocalDataSource implements UserInfoLocalDataSource {
  final SharedPreferences sharedPreferences;

  SharedPrefsUserInfoLocalDataSource({required this.sharedPreferences});

  @override
  Future<void> cacheUserInfo(UserInfoModel userInfoModel) {
    return sharedPreferences.setString(
      'USER_INFO',
      jsonEncode(userInfoModel.toJson()),
    );
  }

  @override
  Future<UserInfoModel?> getLastUserInfo() async {
    final jsonString = sharedPreferences.getString('USER_INFO');
    if (jsonString != null) {
      return UserInfoModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }
}
