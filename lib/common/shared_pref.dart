import 'dart:convert';
import 'package:ismart_web/common/models/downloaded_file.dart';
import 'package:ismart_web/common/models/users.dart';
import 'package:ismart_web/features/auth/model/coop_value.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  static const _userKey = "AppUser";
  static const _coOpValue = "CoOpValue";
  static const _firstTimeAppOpen = 'firstTimeAppOpen';
  static const _appAccessToken = 'appToken';
  static const _refresh_token = 'refresh_token';

  static const _rememberNumber = "rememberNumber";
  static const showChatBot = "ChatBot";
  static const _enableVoiceChat = 'VoiceChat';
  static const _biometricLogin = "biometricLogin";
  static const _deviceUUID = "deviceUUID";
  static const _downloadedFilesList = "downloadedFilesList";

  static Future addDownloadedFiles(DownloadedFile fileDetails) async {
    final _instance = await SharedPreferences.getInstance();
    final String downloadedFileString =
        _instance.getString(_downloadedFilesList) ?? "";
    final List<DownloadedFile> _downloadedFiles = DownloadedFile.decode(
      downloadedFileString,
    );
    _downloadedFiles.add(fileDetails);
    String _savedString = DownloadedFile.encode(_downloadedFiles);
    print(_savedString);
    await _instance.setString(_downloadedFilesList, _savedString);
  }

  static Future getDownloads() async {
    final _instance = await SharedPreferences.getInstance();
    final String downloadedFileString =
        _instance.getString(_downloadedFilesList) ?? "";
    final List<DownloadedFile> _downloadedFiles = DownloadedFile.decode(
      downloadedFileString,
    );
    _downloadedFiles.sort(
      (a, b) => b.downloadedDate.compareTo(a.downloadedDate),
    );
    return _downloadedFiles;
  }

  static Future setFirstTimeAppOpen(bool status) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setBool(_firstTimeAppOpen, status);
  }

  static Future<bool> getFirstTimeAppOpen() async {
    final _instance = await SharedPreferences.getInstance();
    _instance.getKeys().forEach((e) {
      print("Keys");
      print(e);
      print("Keys");
    });
    print("The bool for first_run is : ${_instance.getBool('first_run')}");
    final bool _isFirstRuniOS = _instance.getBool('first_run') ?? true;
    if (_isFirstRuniOS) {
      _instance.clear();
      _instance.setBool('first_run', false);
      return true;
    }
    final res = _instance.getBool(_firstTimeAppOpen);
    if (res == null) {
      return true;
    }
    return res;
  }

  static Future setUser(User user) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setString(_userKey, json.encode(user.toJson()));
  }

  static Future<User?> getUser() async {
    final _instance = await SharedPreferences.getInstance();

    final res = _instance.getString(_userKey);
    if (res == null) {
      return null;
    }
    User? _localUser;
    try {
      _localUser = User.fromJson(json.decode(res));
    } catch (e) {
      return null;
    }
    return _localUser;
  }

  static Future deleteUser() async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.remove(_userKey);
  }

  static Future setLoginCoop(LoginCoOpValue user) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setString(_coOpValue, json.encode(user.toJson()));
  }

  static Future<LoginCoOpValue?> getLoginCoop() async {
    final _instance = await SharedPreferences.getInstance();

    final res = _instance.getString(_coOpValue);
    if (res == null) {
      return null;
    }
    LoginCoOpValue? _localLoginCoOpValue;
    try {
      _localLoginCoOpValue = LoginCoOpValue.fromJson(json.decode(res));
    } catch (e) {
      return null;
    }
    return _localLoginCoOpValue;
  }

  static Future deleteLoginCoOp() async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.remove(_userKey);
  }

  static Future setAccessToken(String jwtToken) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setString(_appAccessToken, jwtToken);
  }

  static Future getRememberNumber() async {
    final _instance = await SharedPreferences.getInstance();
    final _res = _instance.getString(_rememberNumber);
    return _res ?? "";
  }

  static Future setRememberUserNumber(String phoneNumber) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setString(_rememberNumber, phoneNumber);
  }

  static Future removeRememberMeNumber() async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.remove(_rememberNumber);
  }

  static Future<String> getAccessToken() async {
    final _instance = await SharedPreferences.getInstance();
    final res = _instance.getString(_appAccessToken);
    return res ?? "";
  }

  static Future setRefreshToken(String refreshToken) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setString(_refresh_token, refreshToken);
  }

  static Future<String> getRefreshToken() async {
    final _instance = await SharedPreferences.getInstance();
    final res = _instance.getString(_refresh_token);
    return res ?? "";
  }

  static Future deleteAccessToken() async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.remove(_appAccessToken);
    await _instance.remove(_refresh_token);
  }

  static Future setBiometricLogin(bool status) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setBool(_biometricLogin, status);
  }

  static Future<bool?> getBiometricLogin() async {
    final _instance = await SharedPreferences.getInstance();
    final res = _instance.getBool(_biometricLogin);
    return res;
  }

  static Future removeBiometricLogin() async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.remove(_biometricLogin);
  }

  static Future setDeviceUUID(String uuid) async {
    print(uuid);
    final _instance = await SharedPreferences.getInstance();
    await _instance.setString(_deviceUUID, uuid);
  }

  static Future deleteDeviceUUID() async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.remove(_deviceUUID);
  }

  static Future getDeviceUUID() async {
    final _instance = await SharedPreferences.getInstance();
    return _instance.get(_deviceUUID);
  }

  //for ChatBot
  static Future<void> setChatBotVisibility(bool isVisible) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setBool(showChatBot, isVisible);
  }

  static Future<bool> getChatBotVisibility() async {
    final _instance = await SharedPreferences.getInstance();
    return _instance.getBool(showChatBot) ?? true;
  }

  static Future<void> setVoiceChatVisibility(bool isVisible) async {
    final _instance = await SharedPreferences.getInstance();
    await _instance.setBool(_enableVoiceChat, isVisible);
  }

  static Future<bool> getVoiceChatVisibility() async {
    final _instance = await SharedPreferences.getInstance();
    return _instance.getBool(_enableVoiceChat) ?? true;
  }

  static Future<void> toggleChatBotVisibility() async {
    final isVisible = await getChatBotVisibility();
    await setChatBotVisibility(!isVisible);
  }
}
