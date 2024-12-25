import 'package:santai_technician/app/services/secure_storage_service.dart';

enum SessionManagerType {
  accessToken,
  refreshToken,
  userId,
  userType,
  businessCode,
  userName,
  timeZone,
  phoneNumber,
  imageProfile,
  referralCode,
  commonFileUrl,
  deviceId,
}

extension SessionManagerTypeExtension on SessionManagerType {
  String get value {
    switch (this) {
      case SessionManagerType.accessToken:
        return "access_token";
      case SessionManagerType.refreshToken:
        return "refresh_token";
      case SessionManagerType.userId:
        return "user_id";
      case SessionManagerType.userType:
        return "user_type";
      case SessionManagerType.businessCode:
        return "business_code";
      case SessionManagerType.userName:
        return "user_name";
      case SessionManagerType.timeZone:
        return "time_zone";
      case SessionManagerType.phoneNumber:
        return "phone_number";
      case SessionManagerType.imageProfile:
        return "image_profile_url";
      case SessionManagerType.referralCode:
        return "referral_code";
      case SessionManagerType.commonFileUrl:
        return "common_file_url";
      case SessionManagerType.deviceId:
        return "device_id";
      default:
        return "";
    }
  }
}

class SessionManager {
  final _secureStorage = SecureStorageService();
  Future<void> registerSessionForLogin({
    required String accessToken,
    required String refreshToken,
    required String userId,
    required String userType,
    required String businessCode,
    required String userPhoneNumber,
  }) async {
    await _secureStorage.writeSecureData(
        SessionManagerType.accessToken.value, accessToken);
    await _secureStorage.writeSecureData(
        SessionManagerType.refreshToken.value, refreshToken);
    await _secureStorage.writeSecureData(
        SessionManagerType.userId.value, userId);
    await _secureStorage.writeSecureData(
        SessionManagerType.userType.value, userType);
    await _secureStorage.writeSecureData(
        SessionManagerType.businessCode.value, businessCode);
    await _secureStorage.writeSecureData(
        SessionManagerType.phoneNumber.value, userPhoneNumber);
  }

  Future<void> registerCommonFileUrl({required String path}) async {
    await _secureStorage.writeSecureData(
        SessionManagerType.commonFileUrl.value, path);
  }

  Future<void> registerSessionForProfile({
    required String userName,
    required String timeZone,
    required String phoneNumber,
    required String imageProfile,
    required String referralCode,
  }) async {
    await _secureStorage.writeSecureData(
        SessionManagerType.userName.value, userName);
    await _secureStorage.writeSecureData(
        SessionManagerType.timeZone.value, timeZone);
    await _secureStorage.writeSecureData(
        SessionManagerType.phoneNumber.value, phoneNumber);
    await _secureStorage.writeSecureData(
        SessionManagerType.imageProfile.value, imageProfile);
    await _secureStorage.writeSecureData(
        SessionManagerType.referralCode.value, referralCode);
  }

  Future<void> updateSessionForProfile({
    required String userName,
    required String timeZone,
    required String imageProfile,
  }) async {
    await _secureStorage.writeSecureData(
        SessionManagerType.userName.value, userName);
    await _secureStorage.writeSecureData(
        SessionManagerType.timeZone.value, timeZone);
    await _secureStorage.writeSecureData(
        SessionManagerType.imageProfile.value, imageProfile);
  }

  Future<String> getSessionBy(SessionManagerType type) async {
    return await _secureStorage.readSecureData(type.value) ?? '';
  }

  Future<void> setSessionBy(SessionManagerType type, String value) async {
    await _secureStorage.writeSecureData(type.value, value);
  }
}
